is_truthy <- function(x) {
  if (is.null(x) || length(x) == 0) return(FALSE)
  if (any(is.na(x))) return(FALSE)
  if (is.numeric(x)) return(all(x != 0))
  if (is.logical(x)) return(all(x))
  if (is.character(x)) return(all(nchar(x) > 0))
  TRUE
}

ratl_eval <- function(tokens, ctx) {
  for (t in tokens) {
    type <- t$type
    val <- t$value
    
    if (type == "literal") {
      stack_push(ctx$stack, val)
    } else if (type == "block") {
      stack_push(ctx$stack, t)
    } else if (type == "symbol") {
      if (val == "H") {
        if (stack_length(ctx$stack) == 0) stop("Stack underflow for H")
        ctx$clipboards$H <- stack_pop(ctx$stack)
      } else if (val == "G") {
        if (is.null(ctx$clipboards$H)) stop("Clipboard H is empty")
        stack_push(ctx$stack, ctx$clipboards$H)
      } else if (val == "L") {
        if (stack_length(ctx$stack) == 0) stop("Stack underflow for L")
        ctx$clipboards$L <- stack_pop(ctx$stack)
      } else if (val == "M") {
        if (is.null(ctx$clipboards$L)) stop("Clipboard L is empty")
        stack_push(ctx$stack, ctx$clipboards$L)
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
      } else {
        entry <- ctx$dispatch[[val]]
        if (!is.null(entry)) {
          if (stack_length(ctx$stack) < entry$n_in) stop(paste("Stack underflow for symbol", val))
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
          warning(paste("Unknown symbol:", val))
        }
      }
    } else if (type == "vector_block") {
      sub_clipboards <- as.environment(as.list(ctx$clipboards, all.names = TRUE))
      parent.env(sub_clipboards) <- emptyenv()
      sub_ctx <- new.env(parent = emptyenv())
      sub_ctx$stack <- make_stack()
      sub_ctx$dispatch <- ctx$dispatch
      sub_ctx$clipboards <- sub_clipboards
      sub_ctx$stdin <- ctx$stdin
      sub_ctx$in_loop <- ctx$in_loop
      ratl_eval(val, sub_ctx)
      res <- unlist(stack_to_list(sub_ctx$stack))
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
  }
}
