is_truthy <- function(x) {
  if (is.null(x) || length(x) == 0) return(FALSE)
  if (any(is.na(x))) return(FALSE)
  if (is.numeric(x)) return(all(x != 0))
  if (is.logical(x)) return(all(x))
  if (is.character(x)) return(all(nchar(x) > 0))
  TRUE
}

sub_ctx <- function(item, block_tokens, parent_ctx, prelude = NULL, reuse = NULL) {
  if (is.null(reuse)) {
    tmp_ctx <- new.env(parent = emptyenv())
    tmp_ctx$stack <- make_stack()
    tmp_ctx$dispatch <- parent_ctx$dispatch
    tmp_ctx$clipboards <- parent_ctx$clipboards
    tmp_ctx$stdin <- parent_ctx$stdin
  } else {
    tmp_ctx <- reuse
    tmp_ctx$stack$top <- 0L
  }
  stack_push(tmp_ctx$stack, item)
  if (!is.null(prelude)) prelude(tmp_ctx$stack)
  tmp_ctx$in_loop <- FALSE
  ratl_eval(block_tokens, tmp_ctx)
  tmp_ctx
}

eval_block_array <- function(arr, blk, parent_ctx, mode) {
  n <- length(arr)
  if (n == 0) return(numeric(0))
  pool_ctx <- NULL
  if (mode %in% c("map")) {
    results <- vector("list", n)
    for (idx in seq_len(n)) {
      it <- if (is.list(arr)) arr[[idx]] else arr[[idx]]
      tmp_ctx <- sub_ctx(it, blk, parent_ctx, reuse = pool_ctx)
      if (is.null(pool_ctx)) pool_ctx <- tmp_ctx
      sl <- stack_length(tmp_ctx$stack)
      if (sl == 1) {
        results[[idx]] <- stack_peek(tmp_ctx$stack)
      } else if (sl > 1) {
        results[[idx]] <- stack_to_list(tmp_ctx$stack)
      } else {
        results[[idx]] <- NULL
      }
    }
    all_atomic_1 <- all(vapply(results, function(r) is.atomic(r) && length(r) == 1, logical(1)))
    if (all_atomic_1) unlist(results) else results
  } else if (mode == "filter") {
    out <- list()
    for (idx in seq_len(n)) {
      it <- if (is.list(arr)) arr[[idx]] else arr[[idx]]
      tmp_ctx <- sub_ctx(it, blk, parent_ctx, reuse = pool_ctx)
      if (is.null(pool_ctx)) pool_ctx <- tmp_ctx
      if (stack_length(tmp_ctx$stack) > 0 && is_truthy(stack_peek(tmp_ctx$stack))) {
        out[[length(out) + 1]] <- it
      }
    }
    if (length(out) == 0) numeric(0)
    else if (all(vapply(out, is.atomic, logical(1)))) unlist(out)
    else out
  } else if (mode == "keys") {
    keys <- vector("list", n)
    for (idx in seq_len(n)) {
      it <- if (is.list(arr)) arr[[idx]] else arr[[idx]]
      tmp_ctx <- sub_ctx(it, blk, parent_ctx, reuse = pool_ctx)
      if (is.null(pool_ctx)) pool_ctx <- tmp_ctx
      keys[[idx]] <- stack_peek(tmp_ctx$stack)
    }
    unlist(keys)
  } else {
    stop("unknown eval_block_array mode")
  }
}

ratl_eval <- function(tokens, ctx) {
  for (i in seq_along(tokens)) {
    t <- tokens[[i]]
    type <- t$type
    val <- t$value
    tok_label <- if (type == "symbol") paste0("'", val, "'") else paste0("<", type, ">")

    tryCatch({
      if (type == "literal") {
        stack_push(ctx$stack, val)

      } else if (type == "block") {
        stack_push(ctx$stack, t)

      } else if (type == "symbol") {

        if (val == "a") {
          if (stack_length(ctx$stack) == 0) stop("Stack underflow for a")
          ctx$clipboards$a <- stack_pop(ctx$stack)

        } else if (val == "b") {
          if (is.null(ctx$clipboards$a)) stop("Clipboard a is empty")
          stack_push(ctx$stack, ctx$clipboards$a)

        } else if (val == "c") {
          if (stack_length(ctx$stack) == 0) stop("Stack underflow for c")
          ctx$clipboards$c <- stack_pop(ctx$stack)

        } else if (val == "d") {
          if (is.null(ctx$clipboards$c)) stop("Clipboard c is empty")
          stack_push(ctx$stack, ctx$clipboards$c)

        } else if (val == "i") {
          inp <- scan(ctx$stdin, what=character(), n=1, quiet=TRUE)
          if (length(inp) > 0) stack_push(ctx$stack, inp) else stack_push(ctx$stack, NA)

        } else if (val == "X") {
          if (!isTRUE(ctx$in_loop)) stop("X called outside of a loop")
          cond <- simpleCondition("break", call = NULL)
          class(cond) <- c("ratl_break", "condition")
          stop(cond)

        } else if (val == "@") {
          blk_token <- stack_pop(ctx$stack)
          if (blk_token$type != "block") stop("Top of stack is not a block for @")
          ratl_eval(blk_token$value, ctx)

        } else if (val == "U") {
          if (stack_length(ctx$stack) < 1) stop("Stack underflow for U (unpack)")
          arr <- stack_pop(ctx$stack)
          if (!is.null(arr) && length(arr) > 0) {
            for (item in arr) stack_push(ctx$stack, item)
            if (is.list(arr) && !is.null(names(arr))) {
            }
          }

        } else if (val == "Fq" || val == "q") {
          if (stack_length(ctx$stack) < 2) stop("Stack underflow for Fq (map)")
          blk_token <- stack_pop(ctx$stack)
          if (blk_token$type != "block") stop("Fq requires a block")
          arr <- stack_pop(ctx$stack)
          res <- tryCatch(eval_block_array(arr, blk_token$value, ctx, "map"), error = function(e) stop(e))
          stack_push(ctx$stack, res)

        } else if (val == "Ft" || val == "e" || val == "Ef") {
          if (val == "e") {
            entry <- ctx$dispatch[["e"]]
            if (!is.null(entry) && stack_length(ctx$stack) >= 2) {
              top <- stack_peek(ctx$stack)
              second <- ctx$stack$data[[ctx$stack$top - 1]]
              is_block_top <- is.list(top) && !is.null(top$type) && top$type == "block"
              is_block_second <- is.list(second) && !is.null(second$type) && second$type == "block"
              if (!(is_block_top || is_block_second)) {
                if (stack_length(ctx$stack) < entry$n_in) stop(paste0("Stack underflow for '", val, "'"))
                args <- list()
                for (k in 1:entry$n_in) args[[k]] <- stack_pop(ctx$stack)
                r <- do.call(entry$fn, args)
                if (entry$n_out == 1) stack_push(ctx$stack, r) else for (rr in r) stack_push(ctx$stack, rr)
                next
              }
            }
          }
          if (stack_length(ctx$stack) < 2) stop("Stack underflow for Ft (filter)")
          blk_token <- stack_pop(ctx$stack)
          if (blk_token$type != "block") stop("Ft requires a block")
          arr <- stack_pop(ctx$stack)
          res <- eval_block_array(arr, blk_token$value, ctx, "filter")
          stack_push(ctx$stack, res)

        } else if (val == "Fr" || val == "y") {
          if (stack_length(ctx$stack) < 2) stop("Stack underflow for Fr (reduce)")
          blk_token <- stack_pop(ctx$stack)
          if (blk_token$type != "block") stop("Fr requires a block")
          arr <- stack_pop(ctx$stack)
          if (is.null(arr) || length(arr) == 0) {
            stack_push(ctx$stack, numeric(0))
          } else if (length(arr) == 1) {
            stack_push(ctx$stack, arr[[1]])
          } else {
            acc <- arr[[1]]
            pool_ctx <- NULL
            for (j in 2:length(arr)) {
              idx <- j
              tmp_ctx <- sub_ctx(acc, blk_token$value, ctx,
                                 prelude = function(s) { stack_push(s, arr[[idx]]) },
                                 reuse = pool_ctx)
              if (is.null(pool_ctx)) pool_ctx <- tmp_ctx
              if (stack_length(tmp_ctx$stack) > 0) {
                acc <- stack_peek(tmp_ctx$stack)
              }
            }
            stack_push(ctx$stack, acc)
          }

        } else if (val == "Fx" || val == "z") {
          if (stack_length(ctx$stack) < 2) stop("Stack underflow for Fx (repeat)")
          blk_token <- stack_pop(ctx$stack)
          if (blk_token$type != "block") stop("Fx requires a block")
          n <- stack_pop(ctx$stack)
          n <- as.integer(n)
          old_in_loop <- ctx$in_loop
          ctx$in_loop <- TRUE
          for (k in seq_len(n)) {
            broken <- FALSE
            tryCatch({
              ratl_eval(blk_token$value, ctx)
            }, ratl_break = function(e) {
              broken <<- TRUE
            })
            if (broken) break
          }
          ctx$in_loop <- old_in_loop

        } else if (val == "ev") {
          code_str <- stack_pop(ctx$stack)
          tokens2 <- ratl_parse(code_str, ctx$dispatch)
          ratl_eval(tokens2, ctx)

        } else if (val == "zX") {
          cmd <- stack_pop(ctx$stack)
          result <- system(cmd, intern = TRUE)
          stack_push(ctx$stack, result)

        } else if (val == "zD") {
          stack_push(ctx$stack, names(ctx$dispatch))

        } else if (val == "zS") {
          if (stack_length(ctx$stack) < 1) stop("Stack underflow for 'zS': needs at least 1 arg")
          name <- stack_pop(ctx$stack)
          entry <- ctx$dispatch[[name]]
          if (is.null(entry)) stop(paste0("Unknown symbol: '", name, "'"))
          args <- list()
          if (entry$n_in > 0) {
            if (stack_length(ctx$stack) < entry$n_in) stop(paste0("Stack underflow for '", name, "': needs ", entry$n_in, " args"))
            for (k in 1:entry$n_in) args[[k]] <- stack_pop(ctx$stack)
          }
          res <- do.call(entry$fn, args)
          if (entry$n_out == 1) {
            stack_push(ctx$stack, res)
          } else if (entry$n_out > 1) {
            if (is.list(res)) {
              for (rr in res) stack_push(ctx$stack, rr)
            } else {
              stack_push(ctx$stack, res)
            }
          }

        } else if (val == "zB") {
          blk_token <- stack_pop(ctx$stack)
          if (blk_token$type != "block") stop("zB requires a block")
          arr <- stack_pop(ctx$stack)
          if (length(arr) == 0) {
            stack_push(ctx$stack, arr)
          } else {
            keys <- eval_block_array(arr, blk_token$value, ctx, "keys")
            stack_push(ctx$stack, arr[order(keys)])
          }

        } else if (val == "zG") {
          blk_token <- stack_pop(ctx$stack)
          if (blk_token$type != "block") stop("zG requires a block")
          arr <- stack_pop(ctx$stack)
          if (length(arr) == 0) {
            stack_push(ctx$stack, list())
          } else {
            keys <- eval_block_array(arr, blk_token$value, ctx, "keys")
            stack_push(ctx$stack, split(arr, keys))
          }

        } else if (val == "zC") {
          blk_token <- stack_pop(ctx$stack)
          if (blk_token$type != "block") stop("zC requires a block")
          arr <- stack_pop(ctx$stack)
          if (length(arr) == 0) {
            stack_push(ctx$stack, numeric(0))
          } else if (length(arr) == 1) {
            stack_push(ctx$stack, arr)
          } else {
            acc <- arr[[1]]
            result <- list(acc)
            pool_ctx <- NULL
            for (j in 2:length(arr)) {
              idx <- j
              tmp_ctx <- sub_ctx(acc, blk_token$value, ctx,
                                 prelude = function(s) { stack_push(s, arr[[idx]]) },
                                 reuse = pool_ctx)
              if (is.null(pool_ctx)) pool_ctx <- tmp_ctx
              acc <- stack_peek(tmp_ctx$stack)
              result[[length(result) + 1]] <- acc
            }
            stack_push(ctx$stack, unlist(result))
          }

        } else if (val == "zT") {
          blk_token <- stack_pop(ctx$stack)
          if (blk_token$type != "block") stop("zT requires a block")
          arr <- stack_pop(ctx$stack)
          if (length(arr) == 0) {
            stack_push(ctx$stack, arr)
          } else {
            result <- list()
            pool_ctx <- NULL
            for (idx in seq_along(arr)) {
              item <- if (is.list(arr)) arr[[idx]] else arr[[idx]]
              tmp_ctx <- sub_ctx(item, blk_token$value, ctx, reuse = pool_ctx)
              if (is.null(pool_ctx)) pool_ctx <- tmp_ctx
              if (!is_truthy(stack_peek(tmp_ctx$stack))) break
              result[[length(result) + 1]] <- item
            }
            if (length(result) == 0) stack_push(ctx$stack, numeric(0))
            else if (all(vapply(result, is.atomic, logical(1)))) stack_push(ctx$stack, unlist(result))
            else stack_push(ctx$stack, result)
          }

        } else if (val == "zW") {
          blk_token <- stack_pop(ctx$stack)
          if (blk_token$type != "block") stop("zW requires a block")
          arr <- stack_pop(ctx$stack)
          if (length(arr) == 0) {
            stack_push(ctx$stack, arr)
          } else {
            skipping <- TRUE
            result <- list()
            pool_ctx <- NULL
            for (idx in seq_along(arr)) {
              item <- if (is.list(arr)) arr[[idx]] else arr[[idx]]
              if (skipping) {
                tmp_ctx <- sub_ctx(item, blk_token$value, ctx, reuse = pool_ctx)
                if (is.null(pool_ctx)) pool_ctx <- tmp_ctx
                if (is_truthy(stack_peek(tmp_ctx$stack))) next
                skipping <- FALSE
              }
              result[[length(result) + 1]] <- item
            }
            if (length(result) == 0) stack_push(ctx$stack, numeric(0))
            else if (all(vapply(result, is.atomic, logical(1)))) stack_push(ctx$stack, unlist(result))
            else stack_push(ctx$stack, result)
          }

        } else if (val == "zZ") {
          blk_token <- stack_pop(ctx$stack)
          if (blk_token$type != "block") stop("zZ requires a block")
          arr2 <- stack_pop(ctx$stack)
          arr1 <- stack_pop(ctx$stack)
          mlen <- min(length(arr1), length(arr2))
          if (mlen == 0) {
            stack_push(ctx$stack, numeric(0))
          } else {
            result <- list()
            pool_ctx <- NULL
            for (idx in seq_len(mlen)) {
              i1 <- if (is.list(arr1)) arr1[[idx]] else arr1[[idx]]
              i2 <- if (is.list(arr2)) arr2[[idx]] else arr2[[idx]]
              tmp_ctx <- sub_ctx(i1, blk_token$value, ctx,
                                 prelude = function(s) { stack_push(s, i2) },
                                 reuse = pool_ctx)
              if (is.null(pool_ctx)) pool_ctx <- tmp_ctx
              result[[length(result) + 1]] <- stack_peek(tmp_ctx$stack)
            }
            if (all(vapply(result, function(r) is.atomic(r) && length(r) == 1, logical(1)))) {
              stack_push(ctx$stack, unlist(result))
            } else {
              stack_push(ctx$stack, result)
            }
          }

        } else if (val == "L") {
          stack_push(ctx$stack, stack_length(ctx$stack))

        } else if (val == "g") {
          if (stack_length(ctx$stack) < 1) stop("Stack underflow for g (pick)")
          n <- as.integer(stack_pop(ctx$stack))
          sl <- stack_length(ctx$stack)
          if (n < 0 || n >= sl) stop(paste0("Pick index out of bounds: ", n, " (stack depth: ", sl, ")"))
          stk <- stack_to_list(ctx$stack)
          stack_push(ctx$stack, stk[[sl - n]])

        } else if (val == "+") {
          if (stack_length(ctx$stack) < 2) stop("Stack underflow for +")
          b <- stack_pop(ctx$stack)
          a <- stack_pop(ctx$stack)
          stack_push(ctx$stack, a + b)

        } else if (val == "-") {
          if (stack_length(ctx$stack) < 2) stop("Stack underflow for -")
          b <- stack_pop(ctx$stack)
          a <- stack_pop(ctx$stack)
          stack_push(ctx$stack, a - b)

        } else if (val == "_") {
          if (stack_length(ctx$stack) < 2) stop("Stack underflow for _ (extract [[)")
          idx <- stack_pop(ctx$stack)
          obj <- stack_pop(ctx$stack)
          stack_push(ctx$stack, obj[[idx]])

        } else {
          entry <- ctx$dispatch[[val]]
          if (!is.null(entry)) {
            if (stack_length(ctx$stack) < entry$n_in) stop(paste0("Stack underflow for '", val, "': needs ", entry$n_in, " args, has ", stack_length(ctx$stack)))
            args <- list()
            if (entry$n_in > 0) {
              for (k in 1:entry$n_in) args[[k]] <- stack_pop(ctx$stack)
            }
            res <- do.call(entry$fn, args)
            if (entry$n_out == 1) {
              stack_push(ctx$stack, res)
            } else if (entry$n_out > 1) {
              if (is.list(res)) {
                for (r in res) stack_push(ctx$stack, r)
              } else {
                stack_push(ctx$stack, res)
              }
            }
          } else {
            stop(paste0("Unknown symbol: '", val, "'. Check src/ratl_def.tsv for available symbols."))
          }
        }

      } else if (type == "vector_block") {
        if (length(val) == 0) {
          stack_push(ctx$stack, numeric(0))
        } else {
          sub_clipboards <- as.environment(as.list(ctx$clipboards, all.names = TRUE))
          parent.env(sub_clipboards) <- emptyenv()
          vb_ctx <- new.env(parent = emptyenv())
          vb_ctx$stack <- make_stack()
          vb_ctx$dispatch <- ctx$dispatch
          vb_ctx$clipboards <- sub_clipboards
          vb_ctx$stdin <- ctx$stdin
          vb_ctx$in_loop <- ctx$in_loop
          ratl_eval(val, vb_ctx)
          sl <- stack_length(vb_ctx$stack)
          if (sl == 0) {
            stack_push(ctx$stack, numeric(0))
          } else {
            lst <- stack_to_list(vb_ctx$stack)
            flat <- unlist(lst, recursive = FALSE)
            if (is.null(flat)) flat <- numeric(0)
            stack_push(ctx$stack, flat)
          }
        }

      } else if (type == "if_block") {
        if (stack_length(ctx$stack) == 0) stop("Stack underflow for ?")
        if (is_truthy(stack_pop(ctx$stack))) ratl_eval(val, ctx)

      } else if (type == "ifelse_block") {
        if (stack_length(ctx$stack) == 0) stop("Stack underflow for ?")
        if (is_truthy(stack_pop(ctx$stack))) {
          ratl_eval(t$if_val, ctx)
        } else {
          ratl_eval(t$else_val, ctx)
        }

      } else if (type == "while_block") {
        old_in_loop <- ctx$in_loop
        ctx$in_loop <- TRUE
        repeat {
          if (stack_length(ctx$stack) == 0) break
          cond <- stack_pop(ctx$stack)
          if (!is_truthy(cond)) break
          broken <- FALSE
          tryCatch({
            ratl_eval(val, ctx)
          }, ratl_break = function(e) {
            broken <<- TRUE
          })
          if (broken) break
        }
        ctx$in_loop <- old_in_loop

      } else if (type == "foreach_block") {
        if (stack_length(ctx$stack) == 0) stop("Stack underflow for (")
        items <- stack_pop(ctx$stack)
        if (!is.null(items) && length(items) > 0) {
          old_in_loop <- ctx$in_loop
          ctx$in_loop <- TRUE
          for (item in items) {
            stack_push(ctx$stack, item)
            broken <- FALSE
            tryCatch({
              ratl_eval(val, ctx)
            }, ratl_break = function(e) {
              broken <<- TRUE
            })
            if (broken) break
          }
          ctx$in_loop <- old_in_loop
        }

      } else if (type == "infinite_block") {
        old_in_loop <- ctx$in_loop
        ctx$in_loop <- TRUE
        tryCatch({
          repeat ratl_eval(val, ctx)
        }, ratl_break = function(e) {
          invisible(NULL)
        })
        ctx$in_loop <- old_in_loop
      }
    }, error = function(e) {
      if (inherits(e, "ratl_break")) stop(e)
      msg <- paste0(e$message, " [token ", i, ": ", tok_label, "]")
      stop(msg)
    })
  }
}
