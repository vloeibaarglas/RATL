#!/usr/bin/env Rscript

initial.options <- commandArgs(trailingOnly = FALSE)
file.arg.name <- "--file="
script.name <- sub(file.arg.name, "", initial.options[grep(file.arg.name, initial.options)])
script.dir <- dirname(normalizePath(script.name))

source(file.path(script.dir, "ratl_lib.R"))
source(file.path(script.dir, "ratl_stack.R"))
source(file.path(script.dir, "ratl_dispatch.R"))
source(file.path(script.dir, "ratl_parse.R"))
source(file.path(script.dir, "ratl_eval.R"))

args <- commandArgs(trailingOnly = TRUE)
interactive <- "--interactive" %in% args
dump_tokens <- "--dump-tokens" %in% args

non_flags <- args[!grepl("^--", args)]
code <- if (length(non_flags) > 0) non_flags[length(non_flags)] else ""

if (!interactive && nchar(code) == 0) {
  stop("Usage: RATL [--dump-tokens] [--interactive] <code_string>")
}

dispatch_env <- build_dispatch(file.path(script.dir, "ratl_def.tsv"))

show_stack <- function(label = "Stack:") {
  s <- ctx$stack
  len <- stack_length(s)
  if (len == 0) {
    cat(label, " (empty)\n", sep = "")
  } else if (len == 1) {
    cat(label, " ", sep = "")
    ratl_print(stack_peek(s))
  } else {
    cat(label, "\n", sep = "")
    lst <- rev(stack_to_list(s))
    for (j in seq_along(lst)) {
      cat(sprintf("  [%d] ", j))
      print(lst[[j]])
    }
  }
}

# ---- Interactive / Scripted REPL mode ----
if (interactive) {
  ctx <- new.env(parent = emptyenv())
  ctx$stack <- make_stack()
  ctx$dispatch <- dispatch_env
  ctx$clipboards <- new.env(parent = emptyenv())
  ctx$stdin <- stdin()
  ctx$in_loop <- FALSE

  all_lines <- readLines("stdin")
  for (line in all_lines) {
    line <- trimws(line)
    if (nchar(line) == 0) next
    if (line == "quit" || line == "exit") break
    if (line == "/stack") { show_stack(); next }
    if (line == "/clip") {
      for (nm in c("a", "c")) {
        val <- ctx$clipboards[[nm]]
        if (is.null(val)) cat("  ", nm, ": (empty)\n", sep = "")
        else { cat("  ", nm, ": ", sep = ""); print(val) }
      }
      next
    }
    tokens <- ratl_parse(line, dispatch_env)
    if (length(tokens) == 0) next
    tryCatch({
      ratl_eval(tokens, ctx)
      show_stack()
    }, error = function(e) {
      cat("Error:", e$message, "\n")
    })
  }
  quit(save = "no", status = 0)
}

# ---- Batch mode ----
ratl_stdin <- file("stdin", "r")
ctx <- new.env(parent = emptyenv())
ctx$stack <- make_stack()
ctx$dispatch <- dispatch_env
ctx$clipboards <- new.env(parent = emptyenv())
ctx$stdin <- ratl_stdin
ctx$in_loop <- FALSE

tokens <- ratl_parse(code, dispatch_env)

if (dump_tokens) {
  cat("Tokens:\n")
  for (i in seq_along(tokens)) {
    t <- tokens[[i]]
    if (t$type == "symbol") {
      cat(sprintf("  [%d] SYMBOL '%s'\n", i, t$value))
    } else if (t$type == "literal") {
      cat(sprintf("  [%d] LITERAL %s\n", i, deparse(t$value)))
    } else if (t$type == "block") {
      cat(sprintf("  [%d] BLOCK (%d tokens)\n", i, length(t$value)))
    } else if (t$type == "vector_block") {
      cat(sprintf("  [%d] VECTOR [%d tokens]\n", i, length(t$value)))
    } else if (t$type == "if_block") {
      cat(sprintf("  [%d] IF (%d tokens)\n", i, length(t$value)))
    } else if (t$type == "ifelse_block") {
      cat(sprintf("  [%d] IF-ELSE (if=%d else=%d)\n", i, length(t$if_val), length(t$else_val)))
    } else if (t$type == "foreach_block") {
      cat(sprintf("  [%d] FOR-EACH (%d tokens)\n", i, length(t$value)))
    } else if (t$type == "while_block") {
      cat(sprintf("  [%d] WHILE (%d tokens)\n", i, length(t$value)))
    } else if (t$type == "infinite_block") {
      cat(sprintf("  [%d] INFINITE (%d tokens)\n", i, length(t$value)))
    } else {
      cat(sprintf("  [%d] %s\n", i, t$type))
    }
  }
  quit(save = "no", status = 0)
}

tryCatch({
  ratl_eval(tokens, ctx)
}, error = function(e) {
  cat("Error:", e$message, "\n")
  cat("Stack trace (top to bottom):\n")
  s_list <- rev(stack_to_list(ctx$stack))
  if (length(s_list) > 0) {
    for (i in seq_along(s_list)) {
      cat(paste0("[", i, "]: "))
      print(s_list[[i]])
    }
  } else {
    cat("(empty)\n")
  }
  quit(status = 1)
})

s <- ctx$stack
if (stack_length(s) == 1) {
  ratl_print(stack_peek(s))
} else if (stack_length(s) > 1) {
  print(stack_to_list(s))
}
