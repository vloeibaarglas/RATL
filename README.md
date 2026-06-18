# RATL

[![CI](https://github.com/vloeibaarglas/RATL/actions/workflows/ci.yml/badge.svg)](https://github.com/vloeibaarglas/RATL/actions/workflows/ci.yml)

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
Rscript src/RATL.R "your code here"
```

Read the [specification](specs/RATL_SPEC.pdf) for the full symbol reference.

## Examples

| Code | Description | Output |
|------|-------------|--------|
| `1 2+` | Addition | `3` |
| `10.D&p` | 10×10 multiplication table | printed table |
| `5fp` | Factorial | `120` |
| `10.2^s` | Sum of squares 1–10 | `385` |
| `3y!` | 3×3 identity matrix | identity matrix |
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
  D p D L + M w
)
x x
```

First 10 Fibonacci numbers using clipboards L/M for state.

## Development

| Command | Description |
|---------|-------------|
| `make test` | Run all tests (399 unit + 60 integration) |
| `make spec` | Regenerate spec markdown + PDF |
| `make gen-tests` | Regenerate unit tests from TSV |
| `make clean` | Remove generated files |

### Source of Truth

`src/ratl_def.tsv` defines all symbols, categories, and test cases. The spec and tests are auto-generated from it:

- `scripts/gen_spec.py` → `specs/RATL_SPEC.md` → `specs/RATL_SPEC.pdf`
- `scripts/gen_tests.py` → `tests/test_all_symbols.R`

### CI

GitHub Actions runs on every push:
- **Tests** — runs `make test` on all pushes
- **Spec rebuild** — regenerates spec + tests on main, auto-commits with `[skip ci]`

Doc-only changes (`*.md`, `specs/`, `examples/`) are excluded from CI.

## Architecture

1. **Parser** (`src/ratl_parse.R`) — tokenizes input into literals and blocks
2. **Evaluator** (`src/ratl_eval.R`) — tree-walking interpreter on a live stack
3. **Dispatch** (`src/ratl_dispatch.R`) — hashed O(1) symbol lookup
4. **Stack** (`src/ratl_stack.R`) — pointer-based stack implementation
5. **Library** (`src/ratl_lib.R`) — statistical and helper functions

## License

MIT
