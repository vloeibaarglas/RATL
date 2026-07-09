# RATL

[![CI](https://github.com/vloeibaarglas/RATL/actions/workflows/test.yml/badge.svg)](https://github.com/vloeibaarglas/RATL/actions/workflows/test.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

R-based Array Manipulation Language — a stack-based esoteric language for code golf, built on R's statistical and matrix capabilities.

Requires R 3.0.0+.

## Quick Start

```bash
git clone https://github.com/vloeibaarglas/RATL.git
cd RATL
make test
```

## Usage

Run a RATL program:

```bash
Rscript src/RATL.R "1 2 +"
```

Read the [specification](https://vloeibaarglas.github.io/RATL/RATL_SPEC.html) for the full symbol reference.

## Examples

| Code | Description | Output |
|------|-------------|--------|
| `1 2+` | Addition | `3` |
| `10.D&p` | 10×10 multiplication table | printed table |
| `10.2^s` | Sum of squares 1–10 | `385` |
| `100.{mp}e` | Primes ≤ 100 | 2 3 5 7 ... |

### FizzBuzz

```
20.(
  D15%0=?'FizzBuzz'p]
  D15%0=~?
    D3%0=?'Fizz'p]
    D5%0=?'Buzz'p]
    D3%0=~?D5%0=~?Dp]]]
  x)
```

### Fibonacci

```
0 1
10.(
  x
  D p D c3 + c4 w
)
x x
```

First 10 Fibonacci numbers using clipboards c3/c4 for state.

## Development

| Command | Description |
|---------|-------------|
| `make test` | Run all tests |
| `make spec` | Regenerate spec markdown + HTML |
| `make gen-tests` | Regenerate unit tests from TSV |
| `make clean` | Remove generated files |

## Architecture

1. **Parser** (`src/ratl_parse.R`) — tokenizes input into literals and blocks
2. **Evaluator** (`src/ratl_eval.R`) — tree-walking interpreter on a live stack
3. **Dispatch** (`src/ratl_dispatch.R`) — hashed O(1) symbol lookup
4. **Stack** (`src/ratl_stack.R`) — pointer-based stack implementation
5. **Library** (`src/ratl_lib.R`) — statistical and helper functions

## Contributions

Contributions are welcome! Open a pull request with:

- New symbols (add to `src/ratl_def.tsv`, implement in `src/ratl_eval.R`)
- Bug fixes
- Test coverage
- Documentation improvements

## [License (MIT)](LICENSE)
