is_truthy <- function(x) {
  if (is.null(x) || length(x) == 0) return(FALSE)
  if (any(is.na(x))) return(FALSE)
  if (is.numeric(x)) return(all(x != 0))
  if (is.logical(x)) return(all(x))
  if (is.character(x)) return(all(nchar(x) > 0))
  TRUE
}

# Build an isolated sub-context for evaluating block tokens on an item.
# Pass reuse = a previous context to avoid per-element allocation.
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
        if (val == "c1") {
          if (stack_length(ctx$stack) == 0) stop("Stack underflow for c1")
          ctx$clipboards$c1 <- stack_pop(ctx$stack)
        } else if (val == "c2") {
          if (is.null(ctx$clipboards$c1)) stop("Clipboard c1 is empty")
          stack_push(ctx$stack, ctx$clipboards$c1)
        } else if (val == "c3") {
          if (stack_length(ctx$stack) == 0) stop("Stack underflow for c3")
          ctx$clipboards$c3 <- stack_pop(ctx$stack)
        } else if (val == "c4") {
          if (is.null(ctx$clipboards$c3)) stop("Clipboard c3 is empty")
          stack_push(ctx$stack, ctx$clipboards$c3)
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

        } else if (val == "Fq" || val == "q") {
          if (stack_length(ctx$stack) < 2) stop("Stack underflow for Fq (map)")
          blk_token <- stack_pop(ctx$stack)
          if (blk_token$type != "block") stop("Fq requires a block")
          arr <- stack_pop(ctx$stack)
          results <- list()
          pool_ctx <- NULL
          for (item in arr) {
            tmp_ctx <- sub_ctx(item, blk_token$value, ctx, reuse = pool_ctx)
            if (is.null(pool_ctx)) pool_ctx <- tmp_ctx
            sl <- stack_length(tmp_ctx$stack)
            if (sl == 1) {
              results[[length(results) + 1]] <- stack_peek(tmp_ctx$stack)
            } else if (sl > 1) {
              results[[length(results) + 1]] <- stack_to_list(tmp_ctx$stack)
            }
          }
          all_atomic <- all(vapply(results, function(r) is.atomic(r) && length(r) == 1, logical(1)))
          if (all_atomic) {
            stack_push(ctx$stack, unlist(results))
          } else {
            stack_push(ctx$stack, results)
          }

        } else if (val == "Ft") {
          if (stack_length(ctx$stack) < 2) stop("Stack underflow for Ft (filter)")
          blk_token <- stack_pop(ctx$stack)
          if (blk_token$type != "block") stop("Ft requires a block")
          arr <- stack_pop(ctx$stack)
          filtered <- list()
          pool_ctx <- NULL
          for (item in arr) {
            tmp_ctx <- sub_ctx(item, blk_token$value, ctx, reuse = pool_ctx)
            if (is.null(pool_ctx)) pool_ctx <- tmp_ctx
            if (stack_length(tmp_ctx$stack) > 0 && is_truthy(stack_peek(tmp_ctx$stack))) {
              filtered[[length(filtered) + 1]] <- item
            }
          }
          if (length(filtered) == 0) {
            stack_push(ctx$stack, list())
          } else if (all(vapply(filtered, is.atomic, logical(1)))) {
            stack_push(ctx$stack, unlist(filtered))
          } else {
            stack_push(ctx$stack, filtered)
          }

        } else if (val == "Fr" || val == "y") {
          if (stack_length(ctx$stack) < 2) stop("Stack underflow for Fr (reduce)")
          blk_token <- stack_pop(ctx$stack)
          if (blk_token$type != "block") stop("Fr requires a block")
          arr <- stack_pop(ctx$stack)
          if (length(arr) == 0) {
            stack_push(ctx$stack, NULL)
          } else if (length(arr) == 1) {
            stack_push(ctx$stack, arr[[1]])
          } else {
            acc <- arr[[1]]
            pool_ctx <- NULL
            for (i in 2:length(arr)) {
              tmp_ctx <- sub_ctx(acc, blk_token$value, ctx,
                                 prelude = function(s) { stack_push(s, arr[[i]]) },
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
          for (i in seq_len(n)) {
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
          tokens <- ratl_parse(code_str, ctx$dispatch)
          ratl_eval(tokens, ctx)

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
          stack_push(ctx$stack, res)

        } else if (val == "zB") {
          blk_token <- stack_pop(ctx$stack)
          if (blk_token$type != "block") stop("zB requires a block")
          arr <- stack_pop(ctx$stack)
          pool_ctx <- NULL
          keys <- sapply(arr, function(item) {
            tmp_ctx <- sub_ctx(item, blk_token$value, ctx, reuse = pool_ctx)
            if (is.null(pool_ctx)) pool_ctx <<- tmp_ctx
            stack_peek(tmp_ctx$stack)
          })
          stack_push(ctx$stack, arr[order(keys)])

        } else if (val == "zG") {
          blk_token <- stack_pop(ctx$stack)
          if (blk_token$type != "block") stop("zG requires a block")
          arr <- stack_pop(ctx$stack)
          pool_ctx <- NULL
          keys <- sapply(arr, function(item) {
            tmp_ctx <- sub_ctx(item, blk_token$value, ctx, reuse = pool_ctx)
            if (is.null(pool_ctx)) pool_ctx <<- tmp_ctx
            stack_peek(tmp_ctx$stack)
          })
          stack_push(ctx$stack, split(arr, keys))

        } else if (val == "zC") {
          blk_token <- stack_pop(ctx$stack)
          if (blk_token$type != "block") stop("zC requires a block")
          arr <- stack_pop(ctx$stack)
          acc <- arr[[1]]
          result <- list(acc)
          pool_ctx <- NULL
          for (i in 2:length(arr)) {
            tmp_ctx <- sub_ctx(acc, blk_token$value, ctx,
                               prelude = function(s) { stack_push(s, arr[[i]]) },
                               reuse = pool_ctx)
            if (is.null(pool_ctx)) pool_ctx <- tmp_ctx
            acc <- stack_peek(tmp_ctx$stack)
            result[[length(result) + 1]] <- acc
          }
          stack_push(ctx$stack, unlist(result))

        } else if (val == "zT") {
          blk_token <- stack_pop(ctx$stack)
          if (blk_token$type != "block") stop("zT requires a block")
          arr <- stack_pop(ctx$stack)
          result <- list()
          pool_ctx <- NULL
          for (item in arr) {
            tmp_ctx <- sub_ctx(item, blk_token$value, ctx, reuse = pool_ctx)
            if (is.null(pool_ctx)) pool_ctx <- tmp_ctx
            if (!is_truthy(stack_peek(tmp_ctx$stack))) break
            result[[length(result) + 1]] <- item
          }
          stack_push(ctx$stack, unlist(result))

        } else if (val == "zW") {
          blk_token <- stack_pop(ctx$stack)
          if (blk_token$type != "block") stop("zW requires a block")
          arr <- stack_pop(ctx$stack)
          skipping <- TRUE
          result <- list()
          pool_ctx <- NULL
          for (item in arr) {
            if (skipping) {
              tmp_ctx <- sub_ctx(item, blk_token$value, ctx, reuse = pool_ctx)
              if (is.null(pool_ctx)) pool_ctx <- tmp_ctx
              if (is_truthy(stack_peek(tmp_ctx$stack))) next
              skipping <- FALSE
            }
            result[[length(result) + 1]] <- item
          }
          stack_push(ctx$stack, unlist(result))

        } else if (val == "zZ") {
          blk_token <- stack_pop(ctx$stack)
          if (blk_token$type != "block") stop("zZ requires a block")
          arr2 <- stack_pop(ctx$stack)
          arr1 <- stack_pop(ctx$stack)
          result <- list()
          pool_ctx <- NULL
          for (i in seq_along(arr1)) {
            tmp_ctx <- sub_ctx(arr1[[i]], blk_token$value, ctx,
                               prelude = function(s) { stack_push(s, arr2[[i]]) },
                               reuse = pool_ctx)
            if (is.null(pool_ctx)) pool_ctx <- tmp_ctx
            result[[length(result) + 1]] <- stack_peek(tmp_ctx$stack)
          }
          stack_push(ctx$stack, unlist(result))

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
          if (stack_length(ctx$stack) >= 2) {
            b <- stack_pop(ctx$stack)
            a <- stack_pop(ctx$stack)
            stack_push(ctx$stack, a + b)
          } else if (stack_length(ctx$stack) == 1) {
            a <- stack_pop(ctx$stack)
            stack_push(ctx$stack, a + 1)
          } else {
            stop("Stack underflow for +")
          }

        } else if (val == "-") {
          if (stack_length(ctx$stack) >= 2) {
            b <- stack_pop(ctx$stack)
            a <- stack_pop(ctx$stack)
            stack_push(ctx$stack, a - b)
          } else if (stack_length(ctx$stack) == 1) {
            a <- stack_pop(ctx$stack)
            stack_push(ctx$stack, a - 1)
          } else {
            stop("Stack underflow for -")
          }

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
              for (r in res) stack_push(ctx$stack, r)
            }
          } else {
            stop(paste0("Unknown symbol: '", val, "'. Check src/ratl_def.tsv for available symbols."))
          }
        }

      } else if (type == "vector_block") {
        sub_clipboards <- as.environment(as.list(ctx$clipboards, all.names = TRUE))
        parent.env(sub_clipboards) <- emptyenv()
        vb_ctx <- new.env(parent = emptyenv())
        vb_ctx$stack <- make_stack()
        vb_ctx$dispatch <- ctx$dispatch
        vb_ctx$clipboards <- sub_clipboards
        vb_ctx$stdin <- ctx$stdin
        vb_ctx$in_loop <- ctx$in_loop
        ratl_eval(val, vb_ctx)
        res <- unlist(stack_to_list(vb_ctx$stack))
        stack_push(ctx$stack, res)

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
      msg <- paste0(e$message, " [token ", i, ": ", tok_label, "]")
      stop(msg)
    })
  }
}
