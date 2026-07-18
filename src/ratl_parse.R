ratl_parse <- function(code, defs) {
  known_symbols <- if(is.data.frame(defs)) defs$src else names(defs)
  known_symbols <- known_symbols[order(nchar(known_symbols), decreasing = TRUE)]
  sym_lens <- nchar(known_symbols)
  unique_lens <- sort(unique(sym_lens), decreasing = TRUE)
  sym_by_len <- split(known_symbols, sym_lens)
  len <- nchar(code)

  parse_inner <- function(start_idx, terminators = NULL) {
    tokens <- list()
    i <- start_idx
    line_start <- TRUE
    while (i <= len) {
      char <- substr(code, i, i)

      if (line_start) {
        j <- i
        while (j <= len && substr(code, j, j) %in% c(" ", "\t", "\r")) j <- j + 1
        if (j <= len && substr(code, j, j) == "#") {
          while (j <= len && substr(code, j, j) != "\n") j <- j + 1
          i <- j + 1
          line_start <- TRUE
          next
        }
      }

      if (char == "\n") { line_start <- TRUE; i <- i + 1; next }
      if (grepl("[ \t\r]", char)) { i <- i + 1; next }

      if (!is.null(terminators) && char %in% terminators) return(list(tokens = tokens, next_idx = i + 1, terminator = char))

      prev_char <- if (i > 1) substr(code, i-1, i-1) else " "
      is_neg_sign <- char == "-" && i < len && grepl("[0-9]", substr(code, i+1, i+1)) && grepl("[\\s\\[\\{\\(\\?\\`\\\"]", prev_char, perl = TRUE)

      if (grepl("[0-9]", char) || is_neg_sign) {
        rest <- substr(code, i, len)
        int_match <- regexpr("^-?[0-9]+", rest)
        if (int_match > 0) {
          int_len <- attr(int_match, "match.length")
          after_int <- i + int_len
          if (after_int <= len && substr(code, after_int, after_int) == ".") {
            next_char <- if (after_int + 1 <= len) substr(code, after_int + 1, after_int + 1) else ""
            if (grepl("[0-9]", next_char)) {
              peek_after_dot <- ""
              k <- after_int + 1
              while (k <= len && grepl("[0-9]", substr(code, k, k))) { peek_after_dot <- paste0(peek_after_dot, substr(code, k, k)); k <- k + 1 }
              after_num <- k
              delim_ok <- after_num > len || grepl("[ \\t\\n\\r\\]\\}\\)\\;\\`\\\"\\?\\[\\{\\(\\']", substr(code, after_num, after_num))
              if (!delim_ok) {
                num_str <- substr(code, i, after_int - 1)
                tokens <- c(tokens, list(list(type = "literal", value = as.numeric(num_str))))
                i <- after_int
                next
              } else {
                f_match <- regexpr("^-?[0-9]*\\.?[0-9]+", rest)
                if (f_match > 0) {
                  f_len <- attr(f_match, "match.length")
                  num_str <- substr(code, i, i + f_len - 1)
                  tokens <- c(tokens, list(list(type = "literal", value = as.numeric(num_str))))
                  i <- i + f_len
                  next
                }
              }
            } else {
              num_str <- substr(code, i, after_int - 1)
              tokens <- c(tokens, list(list(type = "literal", value = as.numeric(num_str))))
              i <- after_int
              next
            }
          } else {
            f_match <- regexpr("^-?[0-9]*\\.?[0-9]+", rest)
            f_len <- attr(f_match, "match.length")
            next_c <- if (i + f_len <= len) substr(code, i + f_len, i + f_len) else ""
            if (next_c == "." && grepl("[0-9]", substr(code, i + f_len - 1, i + f_len - 1))) {
              num_str <- substr(code, i, i + f_len - 1)
              tokens <- c(tokens, list(list(type = "literal", value = as.numeric(num_str))))
              i <- i + f_len
              next
            } else {
              num_str <- substr(code, i, i + f_len - 1)
              tokens <- c(tokens, list(list(type = "literal", value = as.numeric(num_str))))
              i <- i + f_len
              next
            }
          }
        } else {
          num_match <- regexpr("^-?[0-9]*\\.[0-9]+", rest)
          if (num_match > 0) {
            num_str <- substr(code, i, i + attr(num_match, "match.length") - 1)
            tokens <- c(tokens, list(list(type = "literal", value = as.numeric(num_str))))
            i <- i + attr(num_match, "match.length"); next
          }
        }
      }

      if (char == "'") {
        str_val <- ""
        curr <- i + 1
        while (curr <= len) {
          if (substr(code, curr, curr) == "'") {
            if (curr < len && substr(code, curr + 1, curr + 1) == "'") {
              str_val <- paste0(str_val, "'"); curr <- curr + 2
            } else {
              curr <- curr + 1; break
            }
          } else {
            str_val <- paste0(str_val, substr(code, curr, curr)); curr <- curr + 1
          }
        }
        tokens <- c(tokens, list(list(type = "literal", value = str_val))); i <- curr; line_start <- FALSE; next
      }

      if (char == "[") {
        res <- parse_inner(i + 1, "]"); tokens <- c(tokens, list(list(type = "vector_block", value = res$tokens))); i <- res$next_idx; line_start <- FALSE; next
      }
      if (char == "{") {
        res <- parse_inner(i + 1, "}"); tokens <- c(tokens, list(list(type = "block", value = res$tokens))); i <- res$next_idx; line_start <- FALSE; next
      }
      if (char == "(") {
        res <- parse_inner(i + 1, ")"); tokens <- c(tokens, list(list(type = "foreach_block", value = res$tokens))); i <- res$next_idx; line_start <- FALSE; next
      }
      if (char == "?") {
        res_if <- parse_inner(i + 1, c(";", "]"))
        if (res_if$terminator == ";") {
          res_else <- parse_inner(res_if$next_idx, "]")
          tokens <- c(tokens, list(list(type = "ifelse_block", if_val = res_if$tokens, else_val = res_else$tokens)))
          i <- res_else$next_idx
        } else {
          tokens <- c(tokens, list(list(type = "if_block", value = res_if$tokens)))
          i <- res_if$next_idx
        }
        line_start <- FALSE
        next
      }
      if (char == "\"") {
        res <- parse_inner(i + 1, "\""); tokens <- c(tokens, list(list(type = "while_block", value = res$tokens))); i <- res$next_idx; line_start <- FALSE; next
      }
      if (char == "`") {
        res <- parse_inner(i + 1, "`"); tokens <- c(tokens, list(list(type = "infinite_block", value = res$tokens))); i <- res$next_idx; line_start <- FALSE; next
      }

      matched <- FALSE
      for (slen in unique_lens) {
        if (i + slen - 1 <= len) {
          candidate <- substr(code, i, i + slen - 1)
          if (candidate %in% sym_by_len[[as.character(slen)]]) {
            tokens <- c(tokens, list(list(type = "symbol", value = candidate)))
            i <- i + slen; matched <- TRUE; line_start <- FALSE; break
          }
        }
      }
      if (!matched) { tokens <- c(tokens, list(list(type = "symbol", value = char))); i <- i + 1; line_start <- FALSE }
    }
    return(list(tokens = tokens, next_idx = i))
  }
  return(parse_inner(1, NULL)$tokens)
}
