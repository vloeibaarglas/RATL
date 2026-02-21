# RATL Specification

RATL (R-based Array Manipulation Language) is a stack-based, esoteric programming language inspired by [MATL](https://github.com/lmendo/MATL). It leverages R's powerful statistical and matrix capabilities through a concise, postfix syntax, making it highly suitable for code golf.

## 1. Introduction

RATL is implemented in R and uses R's internal data structures (vectors, lists, matrices) to handle stack operations. It translates RATL code into R code, which is then evaluated.

### 1.1 The Name
The name stands for **R-based Array Manipulation Language**, reflecting its foundation in R and its primary focus on array-based operations.

### 1.2 Notation
- `$n`: Represents the $n$-th element popped from the stack (starting from the top).
- `stack`: The global list used for storage.
- `H, G, L, M`: Clipboards for temporary storage outside the stack.

---

## 2. The Stack and Data Types

RATL is a stack-based language where every operation interacts with a global stack (an R `list`).

### Data Types
RATL uses native R types:
- **Numeric**: Integers and floating-point numbers (R `numeric`).
- **Logical**: Boolean values (`TRUE`, `FALSE`).
- **Character**: Strings of text (R `character`).
- **List/Cell Array**: Collections of items, which can be of mixed types (R `list`).
- **Matrix**: 2D arrays (R `matrix`).

---

## 3. Statements and Separators

- **Space**: Acts as a token separator.
- **Newline**: Ignored by the parser but acts as a token separator.
- **Comments**: Lines starting with `#` are treated as comments and ignored.

---

## 4. Literals

Literals are pushed onto the stack as soon as they are encountered.

### 4.1 Numbers
Standard numeric notation: `1`, `10`, `3.14`, `-5`.

### 4.2 Numerical Arrays (Vectors)
Enclosed in square brackets `[...]`. Elements are separated by spaces.
Example: `[1 2 3]` pushes a numeric vector of length 3.

### 4.3 Character Arrays (Strings)
Enclosed in single quotes `'...'`.
Example: `'hello'` pushes a character vector of length 1.

### 4.4 Cell Arrays (Lists)
Enclosed in curly braces `{...}`.
Example: `{1 'a' [1 2]}` pushes an R list containing three different types.

---

## 5. Functions

RATL features over 400 predefined symbols. Functions are defined in `src/ratl_def.tsv` and categorized as follows:

### 5.1 Normal Functions
- **Arithmetic**: `+`, `-`, `*`, `/`, `%` (modulo), `^` (power).
- **Trigonometry**: `Ys` (sin), `Yc` (cos), `Yt` (tan), etc.
- **Statistics**: `μ` (mean), `σ` (std dev), `η` (median), `ς` (variance).
- **Matrix**: `!` (transpose), `Y*` (matrix mult), `Yi` (identity), `Dt` (determinant).

### 5.2 Meta-Functions
- **Greedy Matching**: Symbols can be single characters or multi-character (e.g., `Xp`, `Vrn`, `db.norm`).

### 5.3 Stack Rearranging Functions
- `D`: Duplicate the top element.
- `w`: Swap the top two elements.
- `x`: Delete the top element.
- `U`: Unpack an array/list onto the stack.

### 5.4 Clipboard Functions
- **Clipboard H/L**:
  - `H`: Move the top of the stack to Clipboard H.
  - `G`: Push the contents of Clipboard H onto the stack.
  - `L`: Move the top of the stack to Clipboard L.
  - `M`: Push the contents of Clipboard L onto the stack.

---

## 6. Control Flow

RATL uses special symbols for conditional branching and loops.

### 6.1 Conditional Branching (`? ... ]`)
- **Symbols**: `?` starts the block, `]` ends it.
- **If-Else**: `? truthy ; falsy ]`. The `;` separator distinguishes the "then" and "else" branches.
- **Logic**: Pops the top element. If it's true, it executes the code until `]` (or `;`). If false and `;` is present, it executes the code between `;` and `]`.

### 6.2 While/Repeat Loop (`" ... "`)
- **Symbol**: `"`
- **Logic**: Starts a loop. At the end of the loop (marked by another `"`), it pops the top element. If it's true, it repeats.

### 6.3 For-Each Loop (`( ... )`)
- **Symbols**: `(` and `)`
- **Logic**: `(` pops an array/list. It then iterates through each element, pushing it onto the stack and executing the code between `(` and `)`.

### 6.4 Infinite Loop (`` ` ... ` ``)
- **Symbols**: `` ` `` starts and ends the loop.
- **Logic**: Executes the code within the backticks repeatedly. Use the `X` (break) symbol to exit.

---

## 7. Implicit Actions

### 7.1 Initial Actions
- The stack is initialized as an empty `list()`.
- A connection to `stdin` is opened for input operations.

### 7.2 Final Actions
- **Implicit Print**: If the stack contains exactly one element, it is printed automatically. If it contains more than one, the entire stack is printed as a list.
- **Invisible Output**: The final evaluation result is returned invisibly in R.

---

## 8. Detailed Function Categories

| Category | Symbols (Examples) |
| :--- | :--- |
| **Arithmetic** | `+`, `-`, `*`, `/`, `^`, `%`, `Id` |
| **Statistics** | `μ`, `σ`, `η`, `varsigma`, `v`, `Xp`, `Xs`, `Bm`, `Bs` |
| **Prob. Distributions** | `Vrn`, `Vdn`, `db.norm`, `pb.binom`, `rb.pois` |
| **Trigonometry** | `Ys`, `Yc`, `Yt`, `Ya`, `Yb`, `Yd`, `Y2` |
| **Matrix Operations** | `!`, `Y*`, `Yi`, `Dt`, `R9`, `Tc`, `Dg`, `Tu`, `Tl`, `Kr` |
| **String Manipulation** | `C`, `j`, `J`, `S`, `Up`, `Lw`, `Nc`, `Pa`, `Sp` |
| **Stack/Clipboard** | `D`, `w`, `x`, `U`, `H`, `G`, `L`, `M` |
| **System/I/O** | `i`, `T`, `F`, `W`, `Da`, `Gd`, `Sw`, `sys.op` |

For a full list of symbols, refer to `src/ratl_def.tsv`.
