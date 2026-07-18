build_dispatch <- function(def_file = "ratl_def.tsv") {
  raw_lines <- readLines(def_file, warn = FALSE)
  env <- new.env(hash = TRUE, parent = emptyenv())
  for (i in 2:length(raw_lines)) {
    line <- raw_lines[i]
    if (nchar(trimws(line)) == 0) next
    parts <- strsplit(line, "\t", fixed = TRUE)[[1]]
    if (length(parts) < 6) next
    src <- parts[1]
    r_code <- parts[2]
    n_in <- suppressWarnings(as.integer(parts[3])); if (is.na(n_in)) n_in <- 0L
    n_out <- suppressWarnings(as.integer(parts[4])); if (is.na(n_out)) n_out <- 0L

    clean_code <- gsub("\\$([0-9]+)", "v\\1", r_code)

    if (trimws(clean_code) == "" || trimws(clean_code) == "NULL") {
      fn <- function(...) { NULL }
      if (n_in == 0) formals(fn) <- alist()
      else formals(fn) <- as.pairlist(setNames(replicate(n_in, NULL, simplify = FALSE), paste0("v", seq_len(n_in))))
    } else {
      args_str <- if (n_in > 0) paste0("v", seq_len(n_in), collapse = ", ") else ""
      func_str <- paste0("function(", args_str, ") { ", clean_code, " }")
      fn <- tryCatch(eval(parse(text = func_str)), error = function(e) {
        warning(paste0("build_dispatch: failed to compile symbol '", src, "': ", e$message, " code=[", clean_code, "]"))
        function(...) { stop(paste0("unimplemented: ", src)) }
      })
    }
    assign(src, list(fn = fn, n_in = n_in, n_out = n_out), envir = env)
  }
  return(env)
}
