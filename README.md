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
- **Statistical Mean**: `./src/RATL.R "1 5:m"`
- **FizzBuzz**: `./src/RATL.R "$(cat examples/17_fizzbuzz.ratl)"`

## Architecture

1.  **Parser (`src/ratl_parse.R`)**: Tokenizes input into literals and blocks.
2.  **Evaluator (`src/ratl_eval.R`)**: Tree-walking interpreter that executes tokens on a live stack.
3.  **Dispatch (`src/ratl_dispatch.R`)**: Hashed environment for O(1) symbol lookup.
4.  **Stack (`src/ratl_stack.R`)**: Pointer-based stack implementation for performance.
5.  **Library (`src/ratl_lib.R`)**: Statistical and helper functions.

## Testing

Run all tests and example checks:
```bash
./tests/test_ratl.sh
```

## License
MIT
