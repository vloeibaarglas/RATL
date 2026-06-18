#!/usr/bin/env python3
"""Generate RATL_SPEC.md from src/ratl_def.tsv"""

import re
from collections import defaultdict

def load_def(path):
    symbols = []
    with open(path) as f:
        header = f.readline()  # skip header
        for line in f:
            parts = line.rstrip('\n').split('\t')
            if len(parts) >= 5:
                src, r_code, n_in, n_out, desc = parts[0], parts[1], parts[2], parts[3], parts[4]
                symbols.append({
                    'src': src, 'r_code': r_code,
                    'n_in': int(n_in), 'n_out': int(n_out), 'desc': desc
                })
    return symbols

def categorize(symbols):
    cats = defaultdict(list)
    for s in symbols:
        src = s['src']
        desc = s['desc'].lower()
        r = s['r_code']

        if src in ('+', '-', '*', '/', '^', '%', '<=', '>='):
            cats['Arithmetic & Comparison'].append(s)
        elif src in ('<', '>', '=', '~', '!', 'sq', 'ab', 'fl', 'cl', 'tr', 'ro', 'sg'):
            cats['Arithmetic & Comparison'].append(s)
        elif src in ('D', 'w', 'x', 'U', 'H', 'G', 'L', 'M', 'i', 'X'):
            cats['Stack & Control'].append(s)
        elif src in ('Ls',):
            cats['Stack & Control'].append(s)
        elif src in ('q', 'e', 'y', 'z', '@', 'Fq', 'Ft', 'Fr', 'Fx'):
            cats['Higher-Order Functions'].append(s)
        elif 'matrix' in desc or 'diag' in desc or 'det' in desc or 'eigen' in desc or 'solve' in desc or 'qr' in desc or 'svd' in desc or 'trace' in desc or src.startswith('y') or src == 'R9' or src == '!':
            cats['Matrix'].append(s)
        elif 'test' in desc or 'anova' in desc or 'lm' in desc or 'glm' in desc or 'predict' in desc or 'residual' in desc or 'coef' in desc or 'fitted' in desc or 'aic' in desc or 'bic' in desc or 'loglik' in desc or 'vcov' in desc or 'conf' in desc or 'update' in desc or 'offset' in desc or 'formula' in desc or 'terms' in desc or 'model' in desc or 'loess' in desc or 'nls' in desc or 'pca' in desc or 'density' in desc:
            cats['Statistical Modeling'].append(s)
        elif 'norm' in desc or 'pois' in desc or 'exp' in desc or 'binom' in desc or 'chisq' in desc or 't-' in desc or 'f-test' in desc or 'wilcox' in desc or 'shapiro' in desc or 'ks ' in desc or 'fisher' in desc or 'bartlett' in desc or 'kruskal' in desc or 'prop' in desc or 'corr' in desc or 'cov' in desc or 'beta' in desc or 'cauchy' in desc or 'gamma' in desc or 'geom' in desc or 'hyper' in desc or 'lnorm' in desc or 'logis' in desc or 'nbinom' in desc or 'unif' in desc or 'weibull' in desc or 'log' in desc or 'binom' in desc or 'dnorm' in desc or 'pnorm' in desc or 'qnorm' in desc or 'rnorm' in desc or 'dpois' in desc or 'ppois' in desc or 'qpois' in desc or 'rpois' in desc:
            cats['Distributions & Tests'].append(s)
        elif 'sin' in desc or 'cos' in desc or 'tan' in desc or 'asin' in desc or 'acos' in desc or 'atan' in desc or 'sinh' in desc or 'cosh' in desc or 'tanh' in desc or 'exp ' in desc or desc.startswith('exp') or 'log ' in desc or desc.startswith('log') or 'sqrt' in desc or 'cumsum' in desc or 'cumprod' in desc or 'cummin' in desc or 'cummax' in desc or 'diff' in desc or 'sign' in desc or 'round' in desc or 'ceiling' in desc or 'floor' in desc or 'trunc' in desc:
            cats['Math Functions'].append(s)
        elif 'mean' in desc or 'sum' in desc or 'median' in desc or 'var' in desc or 'sd' in desc or 'min' in desc or 'max' in desc or 'range' in desc or 'iqr' in desc or 'summary' in desc or 'fivenum' in desc or 'mad' in desc or 'skew' in desc or 'kurt' in desc or 'weight' in desc or 'na.rm' in desc:
            cats['Statistics'].append(s)
        elif 'sort' in desc or 'rev' in desc or 'rank' in desc or 'unique' in desc or 'tabulate' in desc or 'which' in desc or 'match' in desc or 'element' in desc or 'length' in desc or 'head' in desc or 'tail' in desc or 'flatten' in desc or 'zip' in desc or 'repeat' in desc or 'range' in desc or 'rep ' in desc or 'seq' in desc or 'cumsum' in desc or 'cumprod' in desc or 'diff' in desc or 'pmax' in desc or 'pmin' in desc or 'cummin' in desc or 'cummax' in desc:
            cats['Array Operations'].append(s)
        elif src in ('es', 'el', 'en', 'fu', 'zp', 'hd', 'tl', 'fE', 'la', 'r1', 'mn', 'mx', 'rv', 'c1', 'tb', 'un', 'ix', 'cn'):
            cats['Array Operations'].append(s)
        elif 'string' in desc or 'char' in desc or 'nchar' in desc or 'substr' in desc or 'sub ' in desc or 'gsub' in desc or 'sprintf' in desc or 'trim' in desc or 'paste' in desc or 'concat' in desc or 'join' in desc or 'split' in desc or 'reverse' in desc or 'toupper' in desc or 'tolower' in desc or 'grep' in desc or 'grepl' in desc or 'regexpr' in desc or 'gregexpr' in desc or 'cat(' in desc or 'message' in desc or 'warning' in desc or 'stop' in desc or 'translate' in desc:
            cats['String Operations'].append(s)
        elif 'read' in desc or 'write' in desc or 'file' in desc or 'dir' in desc or 'path' in desc or 'list.files' in desc or 'basename' in desc or 'dirname' in desc or 'temp' in desc:
            cats['File I/O'].append(s)
        elif 'type' in desc or 'class' in desc or 'attr' in desc or 'names' in desc or 'dim' in desc or 'typeof' in desc or 'is ' in desc or 'as ' in desc or 'unlist' in desc:
            cats['Type & Introspection'].append(s)
        elif 'set' in desc or 'intersect' in desc or 'union' in desc or 'setdiff' in desc:
            cats['Set Operations'].append(s)
        elif 'bitwise' in desc or 'bit' in desc:
            cats['Bitwise Operations'].append(s)
        elif 'complex' in desc or 'real' in desc or 'imag' in desc or 'conjugate' in desc or 'arg' in desc or 'modulus' in desc:
            cats['Complex Numbers'].append(s)
        elif 'sys.' in src or 'proc.time' in r or 'Sys.' in r or 'options' in r or 'version' in r or 'locale' in r or 'pid' in r or 'gc()' in r:
            cats['System'].append(s)
        elif 'factorial' in desc or 'choose' in desc or 'gamma' in desc or 'beta' in desc or 'digamma' in desc or 'trigamma' in desc or 'psigamma' in desc or 'lgamma' in desc or 'lbeta' in desc or 'cospi' in desc or 'sinpi' in desc or 'tanpi' in desc or 'log1p' in desc or 'expm1' in desc:
            cats['Combinatorics & Special'].append(s)
        else:
            cats['Other'].append(s)
    return cats

def format_symbol(s):
    src = s['src'].replace('|', '\\|')
    r_code = s['r_code'].replace('|', '\\|')
    desc = s['desc']
    n_in = s['n_in']
    n_out = s['n_out']
    return f"| `{src}` | `{r_code}` | {desc} | {n_in} → {n_out} |"

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
    lines.append("---")
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
    lines.append("---")
    lines.append("")
    lines.append("## 3. Statements and Separators")
    lines.append("")
    lines.append("- **Space**: Acts as a token separator.")
    lines.append("- **Newline**: Ignored by the parser but acts as a token separator.")
    lines.append("- **Comments**: Lines starting with `#` are treated as comments and ignored.")
    lines.append("")
    lines.append("---")
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
    lines.append("---")
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
    lines.append("---")
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
    lines.append("---")
    lines.append("")
    lines.append("## 7. Symbol Reference")
    lines.append("")

    # Order categories nicely
    order = [
        'Arithmetic & Comparison',
        'Stack & Control',
        'Higher-Order Functions',
        'Array Operations',
        'Matrix',
        'Statistics',
        'Statistical Modeling',
        'Distributions & Tests',
        'Math Functions',
        'Combinatorics & Special',
        'Complex Numbers',
        'String Operations',
        'Set Operations',
        'Bitwise Operations',
        'Type & Introspection',
        'File I/O',
        'System',
        'Other',
    ]

    for cat in order:
        if cat not in cats:
            continue
        syms = cats[cat]
        lines.append(f"### 7.{order.index(cat)+1} {cat}")
        lines.append("")
        lines.append("| Symbol | R Code | Description | Stack Effect |")
        lines.append("|--------|--------|-------------|--------------|")
        for s in sorted(syms, key=lambda x: x['src']):
            lines.append(format_symbol(s))
        lines.append("")

    return '\n'.join(lines)

if __name__ == '__main__':
    import sys
    tsv_path = sys.argv[1] if len(sys.argv) > 1 else 'src/ratl_def.tsv'
    symbols = load_def(tsv_path)
    spec = generate_spec(symbols)
    print(spec)
