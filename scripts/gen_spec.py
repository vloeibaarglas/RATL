#!/usr/bin/env python3
"""Generate RATL_SPEC.md from src/ratl_def.tsv"""

import sys
from collections import OrderedDict

def load_def(path):
    symbols = []
    with open(path) as f:
        header = f.readline()
        for line in f:
            parts = line.rstrip('\n').split('\t')
            if len(parts) >= 6:
                src, r_code, n_in, n_out, desc, category = (
                    parts[0], parts[1], parts[2], parts[3], parts[4], parts[5]
                )
                symbols.append({
                    'src': src, 'r_code': r_code,
                    'n_in': int(n_in), 'n_out': int(n_out),
                    'desc': desc, 'category': category
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

def format_symbol(s, max_code_len=30):
    src = s['src'].replace('|', '\\|')
    r_code = s['r_code'].replace('|', '\\|')
    if len(r_code) > max_code_len:
        r_code = r_code[:max_code_len-1] + '…'
    desc = s['desc']
    n_in = s['n_in']
    n_out = s['n_out']
    return f"| `{src}` | `{r_code}` | {desc} | {n_in} → {n_out} |"

def hr():
    return "***"

def generate_spec(symbols):
    cats = categorize(symbols)

    lines = []
    lines.append("# RATL Specification")
    lines.append("")
    lines.append("RATL (R-based Array Manipulation Language) is a stack-based, esoteric programming language inspired by [MATL](https://github.com/lmendo/MATL). It leverages R's powerful statistical and matrix capabilities through a concise, postfix syntax, making it highly suitable for code golf.")
    lines.append("")
    lines.append(f"**Total symbols: {len(symbols)}** (all 2-byte or shorter)")
    lines.append("")
    lines.append("## 1. Introduction")
    lines.append("")
    lines.append("RATL is implemented in R and uses R's internal data structures (vectors, lists, matrices) to handle stack operations. It translates RATL code into R code, which is then evaluated.")
    lines.append("")
    lines.append("### 1.1 The Name")
    lines.append("The name stands for **R-based Array Manipulation Language**, reflecting its foundation in R and its primary focus on array-based operations.")
    lines.append("")
    lines.append("### 1.2 Notation")
    lines.append("- `$n`: Represents the $n$-th element popped from the stack (starting from the top).")
    lines.append("- `stack`: The global list used for storage.")
    lines.append("- `H, G, L, M`: Clipboards for temporary storage outside the stack.")
    lines.append("")
    lines.append(hr())
    lines.append("")
    lines.append("## 2. The Stack and Data Types")
    lines.append("")
    lines.append("RATL is a stack-based language where every operation interacts with a global stack (an R `list`).")
    lines.append("")
    lines.append("### Data Types")
    lines.append("RATL uses native R types:")
    lines.append("- **Numeric**: Integers and floating-point numbers (R `numeric`).")
    lines.append("- **Logical**: Boolean values (`TRUE`, `FALSE`).")
    lines.append("- **Character**: Strings of text (R `character`).")
    lines.append("- **List/Cell Array**: Collections of items, which can be of mixed types (R `list`).")
    lines.append("- **Matrix**: 2D arrays (R `matrix`).")
    lines.append("")
    lines.append(hr())
    lines.append("")
    lines.append("## 3. Statements and Separators")
    lines.append("")
    lines.append("- **Space**: Acts as a token separator.")
    lines.append("- **Newline**: Ignored by the parser but acts as a token separator.")
    lines.append("- **Comments**: Lines starting with `#` are treated as comments and ignored.")
    lines.append("")
    lines.append(hr())
    lines.append("")
    lines.append("## 4. Literals")
    lines.append("")
    lines.append("Literals are pushed onto the stack as soon as they are encountered.")
    lines.append("")
    lines.append("### 4.1 Numbers")
    lines.append("Standard numeric notation: `1`, `10`, `3.14`, `-5`.")
    lines.append("")
    lines.append("### 4.2 Numerical Arrays (Vectors)")
    lines.append("Enclosed in square brackets `[...]`. Elements are separated by spaces.")
    lines.append("Example: `[1 2 3]` pushes a numeric vector of length 3.")
    lines.append("")
    lines.append("### 4.3 Character Arrays (Strings)")
    lines.append("Enclosed in single quotes `'...'`.")
    lines.append("Example: `'hello'` pushes a character vector of length 1.")
    lines.append("")
    lines.append("### 4.4 Cell Arrays (Lists)")
    lines.append("Enclosed in curly braces `{...}`.")
    lines.append("Example: `{1 'a' [1 2]}` pushes an R list containing three different types.")
    lines.append("")
    lines.append(hr())
    lines.append("")
    lines.append("## 5. Control Flow")
    lines.append("")
    lines.append("RATL uses special symbols for conditional branching and loops.")
    lines.append("")
    lines.append("### 5.1 Conditional Branching (`? ... ]`)")
    lines.append("- **Symbols**: `?` starts the block, `]` ends it.")
    lines.append("- **If-Else**: `? truthy ; falsy ]`. The `;` separator distinguishes the \"then\" and \"else\" branches.")
    lines.append("- **Logic**: Pops the top element. If it's true, it executes the code until `]` (or `;`). If false and `;` is present, it executes the code between `;` and `]`.")
    lines.append("")
    lines.append("### 5.2 While/Repeat Loop (`\" ... \"`)")
    lines.append("- **Symbol**: `\"`")
    lines.append("- **Logic**: Starts a loop. At the end of the loop (marked by another `\"`), it pops the top element. If it's true, it repeats.")
    lines.append("")
    lines.append("### 5.3 For-Each Loop (`( ... )`)")
    lines.append("- **Symbols**: `(` and `)`")
    lines.append("- **Logic**: `(` pops an array/list. It then iterates through each element, pushing it onto the stack and executing the code between `(` and `)`.")
    lines.append("")
    lines.append("### 5.4 Infinite Loop (`` ` ... ` ``)")
    lines.append("- **Symbols**: `` ` `` starts and ends the loop.")
    lines.append("- **Logic**: Executes the code within the backticks repeatedly. Use the `X` (break) symbol to exit.")
    lines.append("")
    lines.append("### 5.5 Higher-Order Functions (Block Consumers)")
    lines.append("")
    lines.append("These functions pop a `{block}` from the stack and apply it to data.")
    lines.append("")
    lines.append("| Symbol | Name | Description |")
    lines.append("|--------|------|-------------|")
    lines.append("| `q` | Map | `{block} array q` — applies block to each element |")
    lines.append("| `e` | Filter | `{block} array e` — keeps elements where block returns truthy |")
    lines.append("| `y` | Reduce | `{block} array y` — fold left with block |")
    lines.append("| `z` | Repeat | `N {block} z` — executes block N times |")
    lines.append("| `@` | Execute | `{block} @` — pops and executes a block immediately |")
    lines.append("")
    lines.append(hr())
    lines.append("")
    lines.append("## 6. Implicit Actions")
    lines.append("")
    lines.append("### 6.1 Initial Actions")
    lines.append("- The stack is initialized as an empty `list()`.")
    lines.append("- A connection to `stdin` is opened for input operations.")
    lines.append("")
    lines.append("### 6.2 Final Actions")
    lines.append("- **Implicit Print**: If the stack contains exactly one element, it is printed automatically. If it contains more than one, the entire stack is printed as a list.")
    lines.append("- **Invisible Output**: The final evaluation result is returned invisibly in R.")
    lines.append("")
    lines.append(hr())
    lines.append("")
    lines.append("## 7. Symbol Reference")
    lines.append("")

    for i, (cat, syms) in enumerate(cats.items(), 1):
        lines.append(f"### 7.{i} {cat}")
        lines.append("")
        lines.append("| Symbol | R Code | Description | Stack Effect |")
        lines.append("|--------|--------|-------------|--------------|")
        for s in sorted(syms, key=lambda x: x['src']):
            lines.append(format_symbol(s))
        lines.append("")

    return '\n'.join(lines)

if __name__ == '__main__':
    tsv_path = sys.argv[1] if len(sys.argv) > 1 else 'src/ratl_def.tsv'
    symbols = load_def(tsv_path)
    spec = generate_spec(symbols)
    print(spec)
