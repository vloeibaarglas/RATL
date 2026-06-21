#!/usr/bin/env python3
"""Generate RATL_SPEC.qmd from src/ratl_def.tsv"""

import sys
import argparse
from collections import OrderedDict


TIER_MAP = {
    'Stack & Control': 1,
    'Arithmetic & Comparison': 1,
    'Array Operations': 1,
    'Bitwise Operations': 1,
    'Type & Introspection': 1,
    'Higher-Order Functions': 2,
    'Matrix': 2,
    'String Operations': 2,
    'Set Operations': 2,
    'Statistics': 3,
    'Distributions & Tests': 3,
    'Combinatorics & Special': 3,
    'Complex Numbers': 3,
    'File I/O': 3,
    'System': 3,
    'Statistical Modeling': 3,
}

TIER_NAMES = {1: 'Core', 2: 'Toolkit', 3: 'Extensions'}

TIER_DESCRIPTIONS = {
    1: 'stack manipulation, arrays, blocks, control flow, arithmetic',
    2: 'grouping, mapping, reduction, matrix operations, strings, sets',
    3: 'statistics, distributions, filesystem, shell access, meta-programming',
}


def load_def(path):
    symbols = []
    with open(path) as f:
        header = f.readline()
        for line in f:
            parts = line.rstrip('\n').split('\t')
            if len(parts) >= 6:
                unsafe = parts[8].strip() == '1' if len(parts) > 8 else False
                symbols.append({
                    'src': parts[0],
                    'r_code': parts[1],
                    'n_in': int(parts[2]),
                    'n_out': int(parts[3]),
                    'desc': parts[4],
                    'category': parts[5],
                    'unsafe': unsafe,
                })
    return symbols


def categorize(symbols):
    cats = OrderedDict()
    for s in symbols:
        cat = s['category']
        if cat not in cats:
            cats[cat] = []
        cats[cat].append(s)
    return cats


def hr():
    return "***"


def generate_spec(symbols, include_unsafe):
    cats = categorize(symbols)

    lines = []

    lines.append("---")
    lines.append("title: RATL Specification")
    lines.append("---")
    lines.append("")

    lines.append("RATL (**R** **A**rray Manipula**T**ion **L**anguage) is a stack-based, esoteric programming language inspired by [MATL](https://github.com/lmendo/MATL). It leverages R's powerful statistical and matrix capabilities through a concise, postfix syntax, making it highly suitable for code golf.")
    lines.append("")
    lines.append("RATL eliminates variable names and assignment — every character counts. The stack model means `3 5 +` instead of `result = a + b`. Single-byte tokens are reserved for the most frequent golf operations (arithmetic, stack manipulation, array transforms), while 2-byte namespaced tokens cover everything else. The implementation translates RATL to R, then evaluates.")
    lines.append("")
    lines.append(f"**Total symbols: {len(symbols)}** (all 2-byte or shorter)")
    lines.append("")

    # =========================================================================
    # 1. GETTING STARTED
    # =========================================================================
    lines.append("## Getting Started")
    lines.append("")
    lines.append("RATL programs are sequences of tokens evaluated left to right on a stack. No variable declarations, no semicolons — just push values and apply operations.")
    lines.append("")
    lines.append("### Basic Arithmetic")
    lines.append("```")
    lines.append("3 5 +       → 8        # push 3, push 5, add")
    lines.append("10 3 /      → 3.333...  # divide")
    lines.append("2 3 ^       → 8        # power")
    lines.append("```")
    lines.append("")
    lines.append("### Arrays")
    lines.append("```")
    lines.append("[1 2 3] l    → 3        # length")
    lines.append("[1 2 3] s    → 6        # sum")
    lines.append("[1 2 3] m    → 2        # mean")
    lines.append("[3 1 2] O    → 1 2 3    # sort")
    lines.append("```")
    lines.append("")
    lines.append("### Blocks (Higher-Order Functions)")
    lines.append("```")
    lines.append("[1 2 3] {2 *} q    → 2 4 6      # map: double each")
    lines.append("[1 2 3 4] {2 %} e  → 2 4         # filter: keep evens")
    lines.append("[1 2 3 4] {+} y    → 10          # reduce: sum")
    lines.append("```")
    lines.append("")
    lines.append("### Control Flow")
    lines.append("```")
    lines.append("3 5 > ? 'yes' ; 'no' ]    → 'no'    # conditional")
    lines.append("1 5 ( p )                  → 1 2 3 4 5  # for-each")
    lines.append("```")
    lines.append("")

    # =========================================================================
    # 2. LANGUAGE OVERVIEW
    # =========================================================================
    lines.append(hr())
    lines.append("")
    lines.append("## Language Overview")
    lines.append("")
    lines.append("### Design Philosophy")
    lines.append("")
    lines.append("RATL is designed as a **stack-based array manipulation language** for code golf. Its core model is:")
    lines.append("")
    lines.append("1. **Stack** — all operations work on a single global stack")
    lines.append("2. **Arrays** — the primary data structure for bulk operations")
    lines.append("3. **Blocks** — first-class code fragments for higher-order operations")
    lines.append("")
    lines.append("### Symbol Tiers")
    lines.append("")
    lines.append("RATL organizes its symbol set into three conceptual tiers:")
    lines.append("")

    for tier in [1, 2, 3]:
        name = TIER_NAMES[tier]
        desc = TIER_DESCRIPTIONS[tier]
        tier_cats = [c for c, t in TIER_MAP.items() if t == tier]
        count = sum(len(cats[c]) for c in tier_cats if c in cats)
        lines.append(f"**Tier {tier} — {name}** ({desc})")
        lines.append(f": {count} symbols across {len(tier_cats)} categories")
        lines.append("")

    has_unsafe = any(s['unsafe'] for s in symbols)
    if has_unsafe and not include_unsafe:
        lines.append("**Note:** This document excludes unsafe operations by default. Pass `--allow-unsafe-operations` to include them.")
        lines.append("")

    # =========================================================================
    # 3. THE STACK
    # =========================================================================
    lines.append(hr())
    lines.append("")
    lines.append("## The Stack")
    lines.append("")
    lines.append("RATL uses a single global stack (an R `list`). Every operation interacts with this stack — pushing, popping, or transforming elements.")
    lines.append("")
    lines.append("### Stack Notation")
    lines.append("")
    lines.append("Throughout this specification, stack effects are described using the notation:")
    lines.append("")
    lines.append("- `$1` — top of stack (most recently pushed)")
    lines.append("- `$2` — second element from top")
    lines.append("- `$n` — nth element from top")
    lines.append("- `n → m` — operation consumes n elements, produces m elements")
    lines.append("")
    lines.append("For example, `+` has stack effect `2 → 1`: it pops two values and pushes their sum.")
    lines.append("")
    lines.append("### Stack Manipulation Primitives")
    lines.append("")
    lines.append("| Symbol | Name | Description | Stack Effect |")
    lines.append("|--------|------|-------------|--------------|")
    lines.append("| `D` | Duplicate | Copies the top element | 1 → 2 |")
    lines.append("| `w` | Swap | Swaps the top two elements | 2 → 2 |")
    lines.append("| `x` | Delete | Removes the top element | 1 → 0 |")
    lines.append("| `U` | Unpack | Pushes each element of an array onto the stack individually | 1 → n |")
    lines.append("| `Ls` | Stack Length | Pushes the current number of elements on the stack | 0 → 1 |")
    lines.append("")
    lines.append("### Clipboards")
    lines.append("")
    lines.append("RATL provides four clipboards for temporary storage outside the stack:")
    lines.append("")
    lines.append("- `H`, `G`, `L`, `M` — each holds one value independently of the stack")
    lines.append("- Useful for saving intermediate results without stack gymnastics")
    lines.append("")

    # =========================================================================
    # FORMAL GRAMMAR (before Literals)
    # =========================================================================
    lines.append(hr())
    lines.append("")
    lines.append("## Formal Grammar")
    lines.append("")
    lines.append("```")
    lines.append("program     ::= statement*")
    lines.append("statement   ::= literal | symbol | block")
    lines.append("")
    lines.append("literal     ::= number | array | string")
    lines.append("number      ::= [ '-' ] DIGIT+ [ '.' DIGIT+ ]")
    lines.append("array       ::= '[' statement* ']'")
    lines.append("string      ::= Apostrophe { NOT_APOSTROPHE } Apostrophe")
    lines.append("")
    lines.append("block       ::= '{' statement* '}'")
    lines.append("")
    lines.append("symbol      ::= <any 1-2 character token not matching the above>")
    lines.append("comment     ::= '#' { NOT_NEWLINE } NEWLINE")
    lines.append("")
    lines.append("# Whitespace rules:")
    lines.append("# - Space and newline act as token separators")
    lines.append("# - Newlines are otherwise ignored (not significant)")
    lines.append("```")
    lines.append("")

    # =========================================================================
    # 4. LITERALS
    # =========================================================================
    lines.append(hr())
    lines.append("")
    lines.append("## Literals")
    lines.append("")
    lines.append("Literals are pushed onto the stack as soon as they are encountered during parsing.")
    lines.append("")
    lines.append("### Numbers")
    lines.append("Standard numeric notation: `1`, `10`, `3.14`, `-5`.")
    lines.append("")
    lines.append("### Numerical Arrays (Vectors)")
    lines.append("Enclosed in square brackets `[...]`. Elements are separated by spaces.")
    lines.append("Example: `[1 2 3]` pushes a numeric vector of length 3.")
    lines.append("")
    lines.append("### Character Arrays (Strings)")
    lines.append("Enclosed in single quotes `'...'`.")
    lines.append("Example: `'hello'` pushes a character vector of length 1.")
    lines.append("")
    lines.append("### Cell Arrays (Lists)")
    lines.append("Enclosed in curly braces `{...}`.")
    lines.append("Example: `{1 'a' [1 2]}` pushes an R list containing three different types.")
    lines.append("")

    # =========================================================================
    # 5. BLOCKS AND EVALUATION
    # =========================================================================
    lines.append(hr())
    lines.append("")
    lines.append("## Blocks and Evaluation Model")
    lines.append("")
    lines.append("Blocks are first-class code fragments enclosed in `{...}`. They are **not** executed when pushed — they are pushed as values and later consumed by higher-order operators.")
    lines.append("")
    lines.append("### Block Creation")
    lines.append("```")
    lines.append("{2 *}    → pushes a block onto the stack (value, not execution)")
    lines.append("{+}      → pushes a block that adds the top two elements")
    lines.append("```")
    lines.append("")
    lines.append("### Block Consumption")
    lines.append("")
    lines.append("Blocks are consumed by operators that pop them from the stack:")
    lines.append("")
    lines.append("| Operator | Name | Behavior |")
    lines.append("|----------|------|----------|")
    lines.append("| `{block} array q` | Map | Applies block to each element, collects results into array |")
    lines.append("| `{block} array e` | Filter | Keeps elements where block returns truthy |")
    lines.append("| `{block} array y` | Reduce | Folds array left using block as binary operator |")
    lines.append("| `N {block} z` | Repeat | Executes block N times, returns last result |")
    lines.append("| `{block} @` | Execute | Pops and executes a block immediately |")
    lines.append("| `{block} array zB` | Sort By | Sorts array using block as key function |")
    lines.append("| `{block} array zG` | Group By | Groups array elements by block's return value |")
    lines.append("| `{block} array zC` | Scan | Like reduce, but returns all intermediate results |")
    lines.append("| `{block} array zT` | Take While | Takes elements while block returns truthy |")
    lines.append("| `{block} array zW` | Drop While | Drops elements while block returns truthy |")
    lines.append("| `{block} A B zZ` | Zip With | Applies block pairwise to two arrays |")
    lines.append("")
    lines.append("### Execution Environment")
    lines.append("")
    lines.append("When a block executes, the following rules apply:")
    lines.append("")
    lines.append("1. **Stack access**: The block can read the stack via `$1`, `$2`, etc.")
    lines.append("2. **Element binding**: For `q`, `e`, `zB`, `zG`, `zT`, `zW` — the current element is pushed before block execution, available as `$1`")
    lines.append("3. **Return value**: The last value remaining on the block's internal stack after execution is the result")
    lines.append("4. **Stack isolation**: The block's internal stack operations do not leak into the outer stack — only the return value is pushed back")
    lines.append("5. **Nesting**: Blocks may contain other block literals; nested blocks are pushed as values, not executed")
    lines.append("")
    lines.append("### Examples")
    lines.append("```")
    lines.append("# Map: double each element")
    lines.append("# Block {2 *} receives each element as $1")
    lines.append("[1 2 3] {2 *} q    → [2 4 6]")
    lines.append("")
    lines.append("# Filter: keep positive numbers")
    lines.append("# Block {0 >} receives each element; truthy keeps it")
    lines.append("[3 -1 4 -2] {0 >} e    → [3 4]")
    lines.append("")
    lines.append("# Reduce: sum")
    lines.append("# Block {+} receives accumulator as $2, current element as $1")
    lines.append("[1 2 3 4] {+} y    → 10")
    lines.append("")
    lines.append("# Sort by: absolute value")
    lines.append("# Block {0-} computes key for each element")
    lines.append("[3 -1 4 -2] {0-} zB    → -1 -2 3 4")
    lines.append("")
    lines.append("# Execute: run immediately")
    lines.append("{3 5 +} @    → 8")
    lines.append("```")
    lines.append("")

    # =========================================================================
    # 6. TRUTHINESS
    # =========================================================================
    lines.append(hr())
    lines.append("")
    lines.append("## Truthiness")
    lines.append("")
    lines.append("RATL follows R's truthiness rules. Truthiness is used by control flow (`?`), filter (`e`), while loops (double-quote), take-while (`zT`), and drop-while (`zW`).")
    lines.append("")
    lines.append("**Falsy** values:")
    lines.append("")
    lines.append("| Value | Reason |")
    lines.append("|-------|--------|")
    lines.append("| `FALSE` | Boolean false |")
    lines.append("| `0` | Numeric zero |")
    lines.append("| `\"\"` | Empty string |")
    lines.append("| `NULL` | Null value |")
    lines.append("| `NA` | Missing value |")
    lines.append("| `numeric(0)` | Empty numeric vector |")
    lines.append("| `character(0)` | Empty character vector |")
    lines.append("| `logical(0)` | Empty logical vector |")
    lines.append("")
    lines.append("**Truthy** values: everything else, including:")
    lines.append("")
    lines.append("- `TRUE`")
    lines.append("- Any non-zero number (positive or negative)")
    lines.append("- Any non-empty string")
    lines.append("- Any non-empty vector or list")
    lines.append("- Matrices and data frames")
    lines.append("")
    lines.append("**Edge case — `NA`**: In R, `NA` is neither `TRUE` nor `FALSE`, but for RATL control flow it is treated as **falsy**.")
    lines.append("")

    # =========================================================================
    # 7. CONTROL FLOW
    # =========================================================================
    lines.append(hr())
    lines.append("")
    lines.append("## Control Flow")
    lines.append("")
    lines.append("### Conditional Branching (`? ... ]`)")
    lines.append("")
    lines.append("- **`?`** starts a conditional block, **`]`** ends it")
    lines.append("- **If-Else**: `? condition ; then-branch ; else-branch ]`")
    lines.append("- **Behavior**: Pops the top element. If truthy, executes until first `;` or `]`. If falsy, skips to the `;` branch (if present) or skips to `]`.")
    lines.append("```")
    lines.append("1 ? 'yes' ; 'no' ]        → 'yes'    # truthy")
    lines.append("0 ? 'yes' ; 'no' ]        → 'no'     # falsy")
    lines.append("0 ? 'yes' ]                → (empty)  # no else branch")
    lines.append("```")
    lines.append("")
    lines.append("### While/Repeat Loop (`\" ... \"`)")
    lines.append("")
    lines.append("- **Symbol**: `\"` (opening and closing)")
    lines.append("- **Behavior**: Executes the loop body. At the closing `\"`, pops the top element. If truthy, repeats from the opening `\"`. If falsy, exits the loop.")
    lines.append("```")
    lines.append("3 \" 1 - D p \"    → 3 2 1    # counts down")
    lines.append("```")
    lines.append("")
    lines.append("### For-Each Loop (`( ... )`)")
    lines.append("")
    lines.append("- **`(`** pops an array/list, **`)`** marks the end")
    lines.append("- **Behavior**: Iterates through each element, pushing it onto the stack and executing the body.")
    lines.append("```")
    lines.append("[1 2 3] ( p )        → 1 2 3    # prints each element")
    lines.append("[3 5 7] ( D + )       → 6 10 14  # doubles each")
    lines.append("```")
    lines.append("")
    lines.append("### Infinite Loop (`` ` ... ` ``)")
    lines.append("")
    lines.append("- **Symbol**: `` ` `` (backtick, opening and closing)")
    lines.append("- **Behavior**: Executes the body repeatedly. Use `X` (break) to exit the loop.")
    lines.append("```")
    lines.append("` 'quit' i X `        → 'quit'    # reads until 'quit'")
    lines.append("```")
    lines.append("")

    # =========================================================================
    # 8. STATEMENTS AND SEPARATORS
    # =========================================================================
    lines.append(hr())
    lines.append("")
    lines.append("## Statements and Separators")
    lines.append("")
    lines.append("- **Space**: Acts as a token separator.")
    lines.append("- **Newline**: Ignored by the parser but acts as a token separator.")
    lines.append("- **Comments**: Lines starting with `#` are treated as comments and ignored.")
    lines.append("")

    # =========================================================================
    # 9. IMPLICIT ACTIONS
    # =========================================================================
    lines.append(hr())
    lines.append("")
    lines.append("## Implicit Actions")
    lines.append("")
    lines.append("### Initial Actions")
    lines.append("- The stack is initialized as an empty `list()`.")
    lines.append("- A connection to `stdin` is opened for input operations.")
    lines.append("")
    lines.append("### Final Actions")
    lines.append("- **Implicit Print**: If the stack contains exactly one element, it is printed automatically. If it contains more than one, the entire stack is printed as a list.")
    lines.append("- **Invisible Output**: The final evaluation result is returned invisibly in R.")
    lines.append("")

    # =========================================================================
    # 10. META-PROGRAMMING
    # =========================================================================
    lines.append(hr())
    lines.append("")
    lines.append("## Meta-Programming")
    lines.append("")
    lines.append("RATL supports meta-programming — code that generates or manipulates other code at runtime.")
    lines.append("")

    if include_unsafe:
        lines.append("::: {.callout-warning}")
        lines.append("## Unsafe Operations")
        lines.append("The operations marked with ⚠ below execute arbitrary code, shell commands, or dynamic dispatch. They are powerful but security-sensitive and difficult to sandbox. Use with caution.")
        lines.append(":::")
        lines.append("")

    lines.append("### Dynamic Evaluation (`ev`)")
    lines.append("")
    lines.append("Pops a string from the stack and executes it as RATL code:")
    lines.append("")
    lines.append("```")
    lines.append("'3 5 +' ev        → 8")
    lines.append("'[1 2 3] s' ev    → 6")
    lines.append("'5 fp' ev         → 120")
    lines.append("```")
    lines.append("")
    lines.append("### Dispatch List (`zD`)")
    lines.append("")
    lines.append("Pushes a list of all available symbol names onto the stack:")
    lines.append("")
    lines.append("```")
    lines.append("zD    → [+ - * / D w x ...]")
    lines.append("```")
    lines.append("")
    lines.append("### Dynamic Dispatch (`zS`)")
    lines.append("")
    lines.append("Calls a symbol by name (string):")
    lines.append("")
    lines.append("```")
    lines.append("3 5 '+' zS    → 8")
    lines.append("5 'sq' zS     → 2.236...")
    lines.append("```")
    lines.append("")
    lines.append("### Shell Exec (`zX`)")
    lines.append("")
    lines.append("Runs a shell command and pushes the output:")
    lines.append("")
    lines.append("```")
    lines.append("'echo hello' zX    → \"hello\"")
    lines.append("'ls' zX            → file listing")
    lines.append("```")
    lines.append("")
    lines.append("### Sort By (`zB`)")
    lines.append("")
    lines.append("Sorts an array using a block as the key function:")
    lines.append("")
    lines.append("```")
    lines.append("[3 1 4 1 5] {0-} zB    → 1 1 3 4 5 (reverse sort)")
    lines.append("[1 2 3] {2 *} zB       → 1 2 3")
    lines.append("```")
    lines.append("")
    lines.append("### Group By (`zG`)")
    lines.append("")
    lines.append("Groups array elements by the block's return value:")
    lines.append("")
    lines.append("```")
    lines.append("[1 2 3 4 5 6] {2 %} zG    → $0: [2 4 6] $1: [1 3 5]")
    lines.append("```")
    lines.append("")
    lines.append("### Scan (`zC`)")
    lines.append("")
    lines.append("Like reduce, but returns all intermediate results:")
    lines.append("")
    lines.append("```")
    lines.append("[1 2 3 4 5] {+} zC    → 1 3 6 10 15")
    lines.append("[2 3 4] {*} zC        → 2 6 24")
    lines.append("```")
    lines.append("")
    lines.append("### Take While (`zT`)")
    lines.append("")
    lines.append("Takes elements while the block returns truthy:")
    lines.append("")
    lines.append("```")
    lines.append("[1 2 3 4 5] {4 <} zT    → 1 2 3")
    lines.append("```")
    lines.append("")
    lines.append("### Drop While (`zW`)")
    lines.append("")
    lines.append("Drops elements while the block returns truthy:")
    lines.append("")
    lines.append("```")
    lines.append("[1 2 3 4 5] {3 <} zW    → 3 4 5")
    lines.append("```")
    lines.append("")
    lines.append("### Zip With (`zZ`)")
    lines.append("")
    lines.append("Applies a block pairwise to two arrays:")
    lines.append("")
    lines.append("```")
    lines.append("[1 2 3] [4 5 6] {+} zZ    → 5 7 9")
    lines.append("```")
    lines.append("")

    # =========================================================================
    # 11. ERROR HANDLING
    # =========================================================================
    lines.append(hr())
    lines.append("")
    lines.append("## Error Handling")
    lines.append("")
    lines.append("RATL propagates R errors when operations fail. Common error conditions:")
    lines.append("")
    lines.append("| Condition | Error | Example |")
    lines.append("|-----------|-------|---------|")
    lines.append("| Stack underflow | `stack underflow` | `x` on empty stack |")
    lines.append("| Type mismatch | `non-numeric argument` | `+` applied to strings |")
    lines.append("| Divide by zero | Returns `Inf` or `NaN` | `1 0 /` |")
    lines.append("| Index out of bounds | `subscript out of bounds` | `el` with invalid index |")
    lines.append("| Malformed block | `unexpected }` | `{2 *` (missing closing `}`) |")
    lines.append("| Invalid file path | `cannot open connection` | `F` with nonexistent path |")
    lines.append("")

    # =========================================================================
    # 12. SYMBOL REFERENCE
    # =========================================================================
    lines.append(hr())
    lines.append("")
    lines.append("## Symbol Reference")
    lines.append("")

    visible_count = sum(
        len([s for s in syms if include_unsafe or not s['unsafe']])
        for syms in cats.values()
    )
    lines.append(f"**{visible_count} symbols** organized by category. Click a category to expand.")
    lines.append("")

    for cat, syms in cats.items():
        filtered = [s for s in syms if include_unsafe or not s['unsafe']]
        if not filtered:
            continue

        tier = TIER_MAP.get(cat, 3)
        tier_name = TIER_NAMES[tier]
        count = len(filtered)

        lines.append(f'<details open><summary><strong>{cat}</strong> — Tier {tier} ({tier_name}) — {count} symbols</summary>')
        lines.append("")
        lines.append("| Symbol | Description | R Code | Stack Effect |")
        lines.append("|--------|-------------|--------|--------------|")
        for s in sorted(filtered, key=lambda x: x['src']):
            unsafe = " ⚠" if s['unsafe'] else ""
            lines.append(f"| `{s['src']}`{unsafe} | {s['desc']} | `{s['r_code']}` | {s['n_in']} → {s['n_out']} |")
        lines.append("")
        lines.append("</details>")
        lines.append("")

    return '\n'.join(lines)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Generate RATL specification')
    parser.add_argument('tsv', nargs='?', default='src/ratl_def.tsv',
                        help='Path to ratl_def.tsv')
    parser.add_argument('--allow-unsafe-operations', action='store_true',
                        help='Include unsafe operations (marked in TSV) in the spec')
    args = parser.parse_args()

    symbols = load_def(args.tsv)
    spec = generate_spec(symbols, args.allow_unsafe_operations)
    print(spec)
