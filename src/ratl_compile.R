ratl_compile <- function(tokens, def_file = "ratl_def.tsv") {
  defs <- read.table(def_file, header = TRUE, sep = "\t", stringsAsFactors = FALSE, quote = "", comment.char="")
  
  compile_tokens <- function(tokens, defs) {
    lines <- c()
    block_stack <- list()
    
    for (t in tokens) {
      if (t$type == "literal") {
        val <- t$value
        if (is.character(val)) val <- paste0("'", val, "'")
        lines <- c(lines, paste0("stack[[length(stack) + 1]] <- ", val))
      } else if (t$type == "vector_literal") {
        sub_lines <- compile_tokens(t$value, defs)
        lines <- c(lines, "{")
        lines <- c(lines, "  old_stack <- stack")
        lines <- c(lines, "  stack <- list()")
        lines <- c(lines, sub_lines)
        lines <- c(lines, "  res_vec <- unlist(stack)")
        lines <- c(lines, "  stack <- old_stack")
        lines <- c(lines, "  stack[[length(stack) + 1]] <- res_vec")
        lines <- c(lines, "}")
      } else if (t$type == "list_literal") {
        sub_lines <- compile_tokens(t$value, defs)
        lines <- c(lines, "{")
        lines <- c(lines, "  old_stack <- stack")
        lines <- c(lines, "  stack <- list()")
        lines <- c(lines, sub_lines)
        lines <- c(lines, "  res_list <- stack")
        lines <- c(lines, "  stack <- old_stack")
        lines <- c(lines, "  stack[[length(stack) + 1]] <- res_list")
        lines <- c(lines, "}")
      } else if (t$type == "symbol") {
        # Direct Symbol Logic
        if (t$value == "?") {
          lines <- c(lines, "if (length(stack) < 1) stop('Stack underflow for ?')")
          lines <- c(lines, "cond <- stack[[length(stack)]]")
          lines <- c(lines, "stack <- head(stack, -1)")
          lines <- c(lines, "if (isTRUE(as.logical(cond)) && length(cond) > 0 && cond != 0) {")
          block_stack <- c(block_stack, list("?"))
        } else if (t$value == "\"") {
          if (length(block_stack) > 0 && block_stack[[length(block_stack)]] == "\"") {
             lines <- c(lines, "  if (length(stack) < 1) stop('Stack underflow for \"')")
             lines <- c(lines, "  cond <- stack[[length(stack)]]")
             lines <- c(lines, "  stack <- head(stack, -1)")
             lines <- c(lines, "  if (!(isTRUE(as.logical(cond)) && length(cond) > 0 && cond != 0)) break")
             lines <- c(lines, "}")
             block_stack <- head(block_stack, -1)
          } else {
             lines <- c(lines, "repeat {")
             lines <- c(lines, "  if (length(stack) < 1) stop('Stack underflow for \"')")
             lines <- c(lines, "  cond <- stack[[length(stack)]]")
             lines <- c(lines, "  stack <- head(stack, -1)")
             lines <- c(lines, "  if (!(isTRUE(as.logical(cond)) && length(cond) > 0 && cond != 0)) break")
             block_stack <- c(block_stack, list("\""))
          }
        } else if (t$value == "(") {
          lines <- c(lines, "if (length(stack) < 1) stop('Stack underflow for (')")
          lines <- c(lines, "items <- stack[[length(stack)]]")
          lines <- c(lines, "stack <- head(stack, -1)")
          lines <- c(lines, "for (item in items) {")
          lines <- c(lines, "  stack[[length(stack) + 1]] <- item")
          block_stack <- c(block_stack, list("("))
        } else if (t$value == ")") {
          lines <- c(lines, "}")
          block_stack <- head(block_stack, -1)
        } else if (t$value == "`") {
          if (length(block_stack) > 0 && block_stack[[length(block_stack)]] == "`") {
             lines <- c(lines, "  if (length(stack) < 1) stop('Stack underflow for `')")
             lines <- c(lines, "  cond <- stack[[length(stack)]]")
             lines <- c(lines, "  stack <- head(stack, -1)")
             lines <- c(lines, "  if (!(isTRUE(as.logical(cond)) && length(cond) > 0 && cond != 0)) break")
             lines <- c(lines, "}")
             block_stack <- head(block_stack, -1)
          } else {
             lines <- c(lines, "repeat {")
             block_stack <- c(block_stack, list("`"))
          }
        } else if (t$value == "}") {
          lines <- c(lines, "}")
          block_stack <- head(block_stack, -1)
        } else if (t$value == "H") {
          lines <- c(lines, "if (length(stack) < 1) stop('Stack underflow for H')")
          lines <- c(lines, "clipboard_h <- stack[[length(stack)]]")
          lines <- c(lines, "stack <- head(stack, -1)")
        } else if (t$value == "G") {
          lines <- c(lines, "if (is.null(clipboard_h)) stop('Clipboard H is empty')")
          lines <- c(lines, "stack[[length(stack) + 1]] <- clipboard_h")
        } else if (t$value == "L") {
          lines <- c(lines, "if (length(stack) < 1) stop('Stack underflow for L')")
          lines <- c(lines, "clipboard_l <- stack[[length(stack)]]")
          lines <- c(lines, "stack <- head(stack, -1)")
        } else if (t$value == "M") {
          lines <- c(lines, "if (is.null(clipboard_l)) stop('Clipboard L is empty')")
          lines <- c(lines, "stack[[length(stack) + 1]] <- clipboard_l")
        } else {
          # Lookup in TSV
          row <- defs[defs$src == t$value, ]
          if (nrow(row) == 0) {
            warning(paste("Unknown symbol:", t$value))
            next
          }
          n_in <- row$n_in[1]
          code_tmpl <- row$r_code[1]
          n_out <- row$n_out[1]
          
          if (n_in > 0) {
            safe_val <- gsub("\\", "\\\\", t$value, fixed=TRUE)
            lines <- c(lines, paste0("if (length(stack) < ", n_in, ") stop('Stack underflow for symbol ", safe_val, "')"))
            for (i in 1:n_in) {
               idx_expr <- paste0("length(stack) - ", (i-1))
               lines <- c(lines, paste0("v", i, " <- stack[[", idx_expr, "]]"))
            }
            lines <- c(lines, paste0("stack <- head(stack, -", n_in, ")"))
          }
          actual_code <- code_tmpl
          for (i in 1:n_in) {
            actual_code <- gsub(paste0("$", i), paste0("v", i), actual_code, fixed=TRUE)
          }
          lines <- c(lines, paste0("res <- ", actual_code))
          if (n_out == 1) {
             lines <- c(lines, "stack[[length(stack) + 1]] <- res")
          } else if (n_out > 1) {
             lines <- c(lines, "for (r in res) stack[[length(stack) + 1]] <- r")
          }
        }
      }
    }
    return(lines)
  }

  main_lines <- c("ratl_stdin <- file('stdin', 'r')")
  main_lines <- c(main_lines, "stack <- list()")
  main_lines <- c(main_lines, "clipboard_h <- NULL")
  main_lines <- c(main_lines, "clipboard_l <- NULL")
  
  # Print helper
  main_lines <- c(main_lines, "ratl_print <- function(x) {")
  main_lines <- c(main_lines, "  if (is.atomic(x) && length(x) <= 10) {")
  main_lines <- c(main_lines, "    cat(x, '\\n', sep='')")
  main_lines <- c(main_lines, "  } else {")
  main_lines <- c(main_lines, "    print(x)")
  main_lines <- c(main_lines, "  }")
  main_lines <- c(main_lines, "}")
  
  compiled_code <- compile_tokens(tokens, defs)
  main_lines <- c(main_lines, compiled_code)
  
  # Implicit print: if 1 item, print it directly. If >1, print the list.
  main_lines <- c(main_lines, "if (length(stack) == 1) {")
  main_lines <- c(main_lines, "  ratl_print(stack[[1]])")
  main_lines <- c(main_lines, "} else if (length(stack) > 1) {")
  main_lines <- c(main_lines, "  print(stack)")
  main_lines <- c(main_lines, "}")
  main_lines <- c(main_lines, "invisible()")
  
  return(main_lines)
}
