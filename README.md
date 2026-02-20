# RATL

A programming language based on R and suitable for code golf.

RATL (R-based Array Manipulation Language) is an esoteric, stack-based language inspired by [MATL](https://github.com/lmendo/MATL). It leverages R's powerful statistical and matrix capabilities through a concise, postfix syntax.

The compiler works in R 3.0.0 or newer.

**Installation**: Unpack the files to a folder. Ensure R is installed on your system.

**Test**: Running `./src/RATL.R "1 10:D&p"` from the shell should produce a decimal multiplication table.

**Usage**: See the specification documented in the examples and definition files.

## Examples

- **Addition**: `./src/RATL.R "1 2 + p"` -> `3`
- **Multiplication Table**: `./src/RATL.R "1 10:D&p"`
- **Statistical Mean**: `./src/RATL.R "1 5:μ"`
- **FizzBuzz**: `./src/RATL.R "$(cat examples/17_fizzbuzz.ratl)"`

## Architecture

1.  **Parser (`src/ratl_parse.R`)**: Tokenizes input into literals and symbols.
2.  **Compiler (`src/ratl_compile.R`)**: Translates tokens into R code via `src/ratl_def.tsv`.
3.  **Library (`src/ratl_lib.R`)**: Provides extended statistical and helper functions.

## License
MIT
