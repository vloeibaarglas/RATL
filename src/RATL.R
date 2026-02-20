#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  stop("Usage: RATL [-c] <code_string>")
}

compile_only <- FALSE
code <- args[length(args)]

if ("-c" %in% args || "--compile" %in% args) {
  compile_only <- TRUE
}

# Get the directory of the current script
initial.options <- commandArgs(trailingOnly = FALSE)
file.arg.name <- "--file="
script.name <- sub(file.arg.name, "", initial.options[grep(file.arg.name, initial.options)])
script.dir <- dirname(normalizePath(script.name))

# Source modules from same directory as RATL.R
source(file.path(script.dir, "ratl_parse.R"))
source(file.path(script.dir, "ratl_compile.R"))
source(file.path(script.dir, "ratl_lib.R"))

# Load definitions
defs <- read.table(file.path(script.dir, "ratl_def.tsv"), header = TRUE, sep = "\t", stringsAsFactors = FALSE, quote = "", comment.char="")

# Parse
tokens <- RATL(code, defs)

# Compile
r_code_lines <- ratl_compile(tokens, def_file = file.path(script.dir, "ratl_def.tsv"))
r_code_str <- paste(r_code_lines, collapse = "\n")

if (compile_only) {
  cat(r_code_str)
  cat("\n")
} else {
  # Run
  invisible(eval(parse(text = r_code_str)))
}
