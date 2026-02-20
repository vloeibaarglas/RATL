RATL <- function(code, defs) {
  code_chars <- strsplit(code, "")[[1]]
  all_symbols <- c(defs$src, "?", "\"", "(", ")", "`", "}", "H", "G", "L", "M")
  # Sort symbols by length (descending) for greedy matching
  all_symbols <- all_symbols[order(nchar(all_symbols), decreasing = TRUE)]
  
  parse_inner <- function(chars, start_idx, terminator = NULL) {
    tokens <- list()
    i <- start_idx
    len <- length(chars)
    
    while (i <= len) {
      char <- chars[i]
      
      # Comment: '#' at absolute start or start of line ONLY
      if (char == "#" && (i == 1 || chars[i-1] == "\n")) {
        while (i <= len && chars[i] != "\n") i <- i + 1
        i <- i + 1
        next
      }

      # Skip whitespace
      if (grepl("\\s", char)) {
        i <- i + 1
        next
      }
      
      # Terminator for recursion
      if (!is.null(terminator) && char == terminator) {
        return(list(tokens=tokens, next_idx=i + 1))
      }
      
      # Number
      if (grepl("[0-9]", char) || (char == "-" && i < len && grepl("[0-9]", chars[i+1]))) {
        num_str <- ""
        if (char == "-") {
          num_str <- "-"
          i <- i + 1
        }
        while (i <= len && grepl("[0-9\\.]", chars[i])) {
          num_str <- paste0(num_str, chars[i])
          i <- i + 1
        }
        tokens <- c(tokens, list(list(type="literal", value=as.numeric(num_str))))
        next
      }
      
      # String
      if (char == "'") {
        str_val <- ""
        i <- i + 1
        while (i <= len && chars[i] != "'") {
          str_val <- paste0(str_val, chars[i])
          i <- i + 1
        }
        tokens <- c(tokens, list(list(type="literal", value=str_val)))
        i <- i + 1
        next
      }
      
      # Vector/List
      if (char == "[") {
        res <- parse_inner(chars, i + 1, "]")
        tokens <- c(tokens, list(list(type="vector_literal", value=res$tokens)))
        i <- res$next_idx
        next
      }
      if (char == "{") {
        res <- parse_inner(chars, i + 1, "}")
        tokens <- c(tokens, list(list(type="list_literal", value=res$tokens)))
        i <- res$next_idx
        next
      }
      
      # Greedy Symbol Matching
      matched <- FALSE
      for (sym in all_symbols) {
        sym_len <- nchar(sym)
        if (i + sym_len - 1 <= len) {
          candidate <- paste(chars[i:(i + sym_len - 1)], collapse = "")
          if (candidate == sym) {
            tokens <- c(tokens, list(list(type="symbol", value=sym)))
            i <- i + sym_len
            matched <- TRUE
            break
          }
        }
      }
      
      if (!matched) {
        # Default fallback for unknown single character symbols
        tokens <- c(tokens, list(list(type="symbol", value=char)))
        i <- i + 1
      }
    }
    return(list(tokens=tokens, next_idx=i))
  }
  
  full_res <- parse_inner(code_chars, 1, NULL)
  return(full_res$tokens)
}
