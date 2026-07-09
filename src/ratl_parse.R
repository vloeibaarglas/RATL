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
    while (i <= len) {
      char <- substr(code, i, i)
      
      if (char == "#" && (i == 1 || i == start_idx || substr(code, i-1, i-1) == "\n")) {
        while (i <= len && substr(code, i, i) != "\n") i <- i + 1
        i <- i + 1; next
      }
      
      if (grepl("[ \t\n\r]", char)) { i <- i + 1; next }
      
      if (!is.null(terminators) && char %in% terminators) return(list(tokens = tokens, next_idx = i + 1, terminator = char))
      
      prev_char <- if (i > 1) substr(code, i-1, i-1) else " "
      is_neg_sign <- char == "-" && i < len && grepl("[0-9]", substr(code, i+1, i+1)) && grepl("[\\s\\[\\{\\(\\?\\`\\\"]", prev_char, perl = TRUE)
      
      if (grepl("[0-9]", char) || is_neg_sign) {
        num_match <- regexpr("^-?[0-9]*\\.?[0-9]+", substr(code, i, len))
        if (num_match > 0) {
          num_str <- substr(code, i, i + attr(num_match, "match.length") - 1)
          tokens <- c(tokens, list(list(type = "literal", value = as.numeric(num_str))))
          i <- i + attr(num_match, "match.length"); next
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
        tokens <- c(tokens, list(list(type = "literal", value = str_val))); i <- curr; next
      }
      
      if (char == "[") {
        res <- parse_inner(i + 1, "]"); tokens <- c(tokens, list(list(type = "vector_block", value = res$tokens))); i <- res$next_idx; next
      }
      if (char == "{") {
        res <- parse_inner(i + 1, "}"); tokens <- c(tokens, list(list(type = "block", value = res$tokens))); i <- res$next_idx; next
      }
      if (char == "(") {
        res <- parse_inner(i + 1, ")"); tokens <- c(tokens, list(list(type = "foreach_block", value = res$tokens))); i <- res$next_idx; next
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
        next
      }
      if (char == "\"") {
        res <- parse_inner(i + 1, "\""); tokens <- c(tokens, list(list(type = "while_block", value = res$tokens))); i <- res$next_idx; next
      }
      if (char == "`") {
        res <- parse_inner(i + 1, "`"); tokens <- c(tokens, list(list(type = "infinite_block", value = res$tokens))); i <- res$next_idx; next
      }
      
      matched <- FALSE
      for (slen in unique_lens) {
        if (i + slen - 1 <= len) {
          candidate <- substr(code, i, i + slen - 1)
          if (candidate %in% sym_by_len[[as.character(slen)]]) {
            tokens <- c(tokens, list(list(type = "symbol", value = candidate)))
            i <- i + slen; matched <- TRUE; break
          }
        }
      }
      if (!matched) { tokens <- c(tokens, list(list(type = "symbol", value = char))); i <- i + 1 }
    }
    return(list(tokens = tokens, next_idx = i))
  }
  return(parse_inner(1, NULL)$tokens)
}
