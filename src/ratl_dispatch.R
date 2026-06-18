build_dispatch <- function(def_file = "ratl_def.tsv") {
  defs <- read.table(def_file, header = TRUE, sep = "\t", 
                     stringsAsFactors = FALSE, quote = "", comment.char="")
  
  env <- new.env(hash = TRUE, parent = emptyenv())
  
  for (i in seq_len(nrow(defs))) {
    row <- defs[i, ]
    n_in <- row$n_in
    n_out <- row$n_out
    src <- row$src
    r_code <- row$r_code
    
    clean_code <- gsub("\\$([0-9]+)", "v\\1", r_code)
    
    args_str <- if (n_in == -1) {
      "v1, v2"
    } else if (n_in > 0) {
      paste0("v", seq_len(n_in), collapse = ", ")
    } else {
      ""
    }
    
    func_str <- paste0("function(", args_str, ") { ", clean_code, " }")
    
    fn <- tryCatch(eval(parse(text = func_str)), error = function(e) {
      warning(paste("build_dispatch: failed to compile symbol '", src, "':", e$message))
      NULL
    })
    
    if (!is.null(fn)) {
      assign(src, list(fn = fn, n_in = n_in, n_out = n_out), envir = env)
    }
  }
  return(env)
}
