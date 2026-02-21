#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  stop("Usage: RATL <code_string>")
}

code <- args[length(args)]

initial.options <- commandArgs(trailingOnly = FALSE)
file.arg.name <- "--file="
script.name <- sub(file.arg.name, "", initial.options[grep(file.arg.name, initial.options)])
script.dir <- dirname(normalizePath(script.name))

source(file.path(script.dir, "ratl_lib.R"))
source(file.path(script.dir, "ratl_stack.R"))
source(file.path(script.dir, "ratl_dispatch.R"))
source(file.path(script.dir, "ratl_parse.R"))
source(file.path(script.dir, "ratl_eval.R"))

ratl_stdin <- file("stdin", "r")
dispatch_env <- build_dispatch(file.path(script.dir, "ratl_def.tsv"))

ctx <- new.env(parent = emptyenv())
ctx$stack <- make_stack()
ctx$dispatch <- dispatch_env
ctx$clipboards <- new.env(parent = emptyenv())
ctx$stdin <- ratl_stdin
ctx$in_loop <- FALSE

tokens <- ratl_parse(code, dispatch_env)

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
