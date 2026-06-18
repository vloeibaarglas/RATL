# RATL Specification

RATL (R-based Array Manipulation Language) is a stack-based, esoteric programming language inspired by [MATL](https://github.com/lmendo/MATL). It leverages R's powerful statistical and matrix capabilities through a concise, postfix syntax, making it highly suitable for code golf.

**Total symbols: 419** (all 2-byte or shorter)

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

## 5. Control Flow

RATL uses special symbols for conditional branching and loops.

### 5.1 Conditional Branching (`? ... ]`)
- **Symbols**: `?` starts the block, `]` ends it.
- **If-Else**: `? truthy ; falsy ]`. The `;` separator distinguishes the "then" and "else" branches.
- **Logic**: Pops the top element. If it's true, it executes the code until `]` (or `;`). If false and `;` is present, it executes the code between `;` and `]`.

### 5.2 While/Repeat Loop (`" ... "`)
- **Symbol**: `"`
- **Logic**: Starts a loop. At the end of the loop (marked by another `"`), it pops the top element. If it's true, it repeats.

### 5.3 For-Each Loop (`( ... )`)
- **Symbols**: `(` and `)`
- **Logic**: `(` pops an array/list. It then iterates through each element, pushing it onto the stack and executing the code between `(` and `)`.

### 5.4 Infinite Loop (`` ` ... ` ``)
- **Symbols**: `` ` `` starts and ends the loop.
- **Logic**: Executes the code within the backticks repeatedly. Use the `X` (break) symbol to exit.

### 5.5 Higher-Order Functions (Block Consumers)

These functions pop a `{block}` from the stack and apply it to data.

| Symbol | Name | Description |
|--------|------|-------------|
| `q` | Map | `{block} array q` — applies block to each element |
| `e` | Filter | `{block} array e` — keeps elements where block returns truthy |
| `y` | Reduce | `{block} array y` — fold left with block |
| `z` | Repeat | `N {block} z` — executes block N times |
| `@` | Execute | `{block} @` — pops and executes a block immediately |

---

## 6. Implicit Actions

### 6.1 Initial Actions
- The stack is initialized as an empty `list()`.
- A connection to `stdin` is opened for input operations.

### 6.2 Final Actions
- **Implicit Print**: If the stack contains exactly one element, it is printed automatically. If it contains more than one, the entire stack is printed as a list.
- **Invisible Output**: The final evaluation result is returned invisibly in R.

---

## 7. Symbol Reference

### 7.1 Arithmetic & Comparison

| Symbol | Description | Stack Effect |
|--------|-------------|--------------|
| `!` | Transpose | 1 → 1 |
| `%` | Modulo | 2 → 1 |
| `*` | Multiply | 2 → 1 |
| `+` | Add | 2 → 1 |
| `-` | Subtract | 2 → 1 |
| `/` | Divide | 2 → 1 |
| `<` | Less | 2 → 1 |
| `<=` | LessEqual | 2 → 1 |
| `=` | Equal | 2 → 1 |
| `>` | Greater | 2 → 1 |
| `>=` | GreatEqual | 2 → 1 |
| `^` | Power | 2 → 1 |
| `ab` | Abs | 1 → 1 |
| `cl` | Ceiling | 1 → 1 |
| `fl` | Floor | 1 → 1 |
| `ro` | Round | 1 → 1 |
| `sg` | Sign | 1 → 1 |
| `sq` | Sqrt | 1 → 1 |
| `tr` | Trunc | 1 → 1 |
| `~` | Not | 1 → 1 |

### 7.2 Stack & Control

| Symbol | Description | Stack Effect |
|--------|-------------|--------------|
| `D` | Duplicate | 1 → 2 |
| `Ls` | Stack Length | 0 → 1 |
| `U` | Unpack | 1 → 0 |
| `i` | Input | 0 → 1 |
| `w` | Swap | 2 → 2 |
| `x` | Delete | 1 → 0 |

### 7.3 Higher-Order Functions

| Symbol | Description | Stack Effect |
|--------|-------------|--------------|
| `Fq` | Map (evaluator) | 0 → 1 |
| `Fr` | Reduce | 2 → 1 |
| `Ft` | Filter (evaluator) | 0 → 1 |
| `Fx` | Repeat (evaluator) | 0 → 1 |
| `e` | Filter (evaluator) | 0 → 1 |
| `q` | Map (evaluator) | 0 → 1 |
| `y` | Reduce (evaluator) | 0 → 1 |
| `z` | Repeat (evaluator) | 0 → 1 |

### 7.4 Array Operations

| Symbol | Description | Stack Effect |
|--------|-------------|--------------|
| `:` | Sequence | 2 → 1 |
| `O` | Sort | 1 → 1 |
| `R` | Reverse | 1 → 1 |
| `SH` | Head | 1 → 1 |
| `SR` | Rank | 1 → 1 |
| `ST` | Tail | 1 → 1 |
| `el` | Extract Element [[ | 2 → 1 |
| `en` | Extract Name $ | 2 → 1 |
| `es` | Extract Subset [ | 2 → 1 |
| `fE` | FirstElem | 1 → 1 |
| `fu` | Flatten | 1 → 1 |
| `hd` | HeadN | 2 → 1 |
| `ix` | IndexOf | 2 → 1 |
| `l` | Length | 1 → 1 |
| `la` | LastElem | 1 → 1 |
| `rv` | Reverse String | 1 → 1 |
| `tb` | Tabulate | 1 → 1 |
| `tl` | TailN | 2 → 1 |
| `u` | Unique | 1 → 1 |
| `un` | UniqueN | 1 → 1 |
| `vH` | WhichArr | 1 → 1 |
| `vW` | SeqLen | 3 → 1 |
| `wh` | Which | 1 → 1 |
| `zp` | Zip | 2 → 1 |

### 7.5 Matrix

| Symbol | Description | Stack Effect |
|--------|-------------|--------------|
| `Bi` | IQR | 1 → 1 |
| `R9` | Rot90 | 1 → 1 |
| `Y!` | Create Matrix | 3 → 1 |
| `Y*` | Matrix Mult | 2 → 1 |
| `YM` | Matrix ByRow | 3 → 1 |
| `mM` | Model Matrix | 1 → 1 |
| `v2` | Solve 2 | 2 → 1 |
| `vL` | Solve | 1 → 1 |
| `vQ` | QR Decomp | 1 → 1 |
| `vV` | SVD | 1 → 1 |
| `y!` | Diag | 1 → 1 |
| `yD` | Identity Matrix | 1 → 1 |
| `yc` | EigenVectors | 1 → 1 |
| `yd` | Determinant | 1 → 1 |
| `yf` | Full | 1 → 1 |
| `yk` | Kronecker | 2 → 1 |
| `yl` | TriLower | 1 → 1 |
| `ym` | Create Matrix | 3 → 1 |
| `yt` | Trace | 1 → 1 |
| `yu` | TriUpper | 1 → 1 |
| `yv` | EigenValues | 1 → 1 |

### 7.6 Statistics

| Symbol | Description | Stack Effect |
|--------|-------------|--------------|
| `B5` | FiveNum | 1 → 1 |
| `BS` | Summary | 1 → 1 |
| `Ba` | MAD | 1 → 1 |
| `Bn` | Min | 1 → 1 |
| `Br` | Range | 1 → 1 |
| `Bx` | Max | 1 → 1 |
| `Ku` | Kurtosis | 1 → 1 |
| `Sd` | CumSD | 1 → 1 |
| `Sk` | Skewness | 1 → 1 |
| `Sm` | MeanNA | 1 → 1 |
| `Sn` | SumNA | 1 → 1 |
| `Sw` | WeightedMean | 2 → 1 |
| `V` | Variance | 1 → 1 |
| `h` | Median | 1 → 1 |
| `m` | Mean | 1 → 1 |
| `mn` | Min2 | 2 → 1 |
| `mx` | Max2 | 2 → 1 |
| `r1` | Range1toN | 1 → 1 |
| `s` | Sum | 1 → 1 |
| `sm` | Summary | 1 → 1 |
| `v` | Variance | 1 → 1 |
| `vB` | PMin | 2 → 1 |
| `vE` | Row Sums | 1 → 1 |
| `vG` | PMax | 2 → 1 |
| `vM` | Col Means | 1 → 1 |
| `vN` | Row Means | 1 → 1 |
| `vS` | Col Sums | 1 → 1 |

### 7.7 Statistical Modeling

| Symbol | Description | Stack Effect |
|--------|-------------|--------------|
| `DN` | Density Normal | 3 → 1 |
| `K!` | Coef | 1 → 1 |
| `KB` | BIC | 1 → 1 |
| `KC` | Cor Test | 2 → 1 |
| `KE` | Residuals | 1 → 1 |
| `KF` | Fitted | 1 → 1 |
| `KL` | LogLik | 1 → 1 |
| `KV` | VCov | 1 → 1 |
| `av` | Anova | 1 → 1 |
| `dB` | Density Binomial | 3 → 1 |
| `dC` | Density Chi-Square | 2 → 1 |
| `dG` | Density Geometric | 2 → 1 |
| `dL` | Density Logistic | 3 → 1 |
| `dN` | Density Neg-Binomial | 3 → 1 |
| `dP` | Density Poisson | 2 → 1 |
| `db` | Density Beta | 3 → 1 |
| `dc` | Density Cauchy | 3 → 1 |
| `de` | Density Exponential | 2 → 1 |
| `df` | Density F | 3 → 1 |
| `dg` | Density Gamma | 3 → 1 |
| `dh` | Density Hypergeometric | 4 → 1 |
| `dl` | Density Log-Normal | 3 → 1 |
| `dn` | Density Normal | 1 → 1 |
| `dt` | Density Student-t | 2 → 1 |
| `du` | Density Uniform | 3 → 1 |
| `dw` | Density Weibull | 3 → 1 |
| `ka` | Anova | 1 → 1 |
| `kb` | Bartlett Test | 1 → 1 |
| `kc` | Chi-Square Test | 1 → 1 |
| `ke` | Predict | 2 → 1 |
| `kf` | Fisher Test | 1 → 1 |
| `kg` | GLM | 1 → 1 |
| `ki` | AIC | 1 → 1 |
| `kk` | KS Test | 2 → 1 |
| `kl` | Linear Model | 1 → 1 |
| `kn` | NLS | 1 → 1 |
| `ko` | Loess | 1 → 1 |
| `kp` | Prop Test | 2 → 1 |
| `kt` | T-Test | 2 → 1 |
| `kv` | F-Test Var | 2 → 1 |
| `kw` | Wilcoxon Test | 2 → 1 |
| `lm` | Linear Model | 1 → 1 |
| `mC` | Conf Int | 1 → 1 |
| `mL` | LM Simple | 2 → 1 |
| `mO` | Offset | 1 → 1 |
| `mP` | Predict | 1 → 1 |
| `mR` | Model Frame | 1 → 1 |
| `mT` | Terms | 1 → 1 |
| `mU` | Update | 2 → 1 |
| `mW` | Formula | 1 → 1 |
| `tt` | T-Test | 2 → 1 |
| `vd` | Density | 1 → 1 |
| `vp` | PCA | 1 → 1 |

### 7.8 Distributions & Tests

| Symbol | Description | Stack Effect |
|--------|-------------|--------------|
| `BC` | Covariance | 2 → 1 |
| `Bc` | Correlation | 2 → 1 |
| `KK` | Kruskal-Wallis | 1 → 1 |
| `LG` | Log Gamma | 1 → 1 |
| `N` | Random Normal | 1 → 1 |
| `PN` | Prob Normal | 3 → 1 |
| `QN` | Quantile Normal | 3 → 1 |
| `RB` | Random Beta | 3 → 1 |
| `RE` | Random Exponential | 2 → 1 |
| `RN` | Random Normal | 3 → 1 |
| `RU` | Random Uniform | 3 → 1 |
| `cr` | Correlation | 2 → 1 |
| `cv` | Covariance | 2 → 1 |
| `di` | Digamma | 1 → 1 |
| `e-` | Exp(x)-1 | 1 → 1 |
| `ex` | Exp | 1 → 1 |
| `ks` | Shapiro-Wilk | 1 → 1 |
| `l+` | Log(1+x) | 1 → 1 |
| `l1` | Log 10 | 1 → 1 |
| `l2` | Log 2 | 1 → 1 |
| `lb` | Log Beta | 2 → 1 |
| `lg` | Log Natural | 1 → 1 |
| `mB` | Beta | 2 → 1 |
| `mG` | Gamma | 1 → 1 |
| `pB` | Prob Binomial | 3 → 1 |
| `pG` | Prob Geometric | 2 → 1 |
| `pL` | Prob Logistic | 3 → 1 |
| `pN` | Prob Neg-Binomial | 3 → 1 |
| `pP` | Prob Poisson | 2 → 1 |
| `pb` | Prob Beta | 3 → 1 |
| `pc` | Prob Cauchy | 3 → 1 |
| `pe` | Prob Exponential | 2 → 1 |
| `pg` | Prob Gamma | 3 → 1 |
| `ph` | Prob Hypergeometric | 4 → 1 |
| `pl` | Prob Log-Normal | 3 → 1 |
| `pn` | Prob Normal | 1 → 1 |
| `ps` | Psigamma | 2 → 1 |
| `pt` | Prob Student-t | 2 → 1 |
| `pu` | Prob Uniform | 3 → 1 |
| `pw` | Prob Weibull | 3 → 1 |
| `qB` | Quantile Binomial | 3 → 1 |
| `qG` | Quantile Geometric | 2 → 1 |
| `qL` | Quantile Logistic | 3 → 1 |
| `qN` | Quantile Neg-Binomial | 3 → 1 |
| `qP` | Quantile Poisson | 2 → 1 |
| `qb` | Quantile Beta | 3 → 1 |
| `qc` | Quantile Cauchy | 3 → 1 |
| `qe` | Quantile Exponential | 2 → 1 |
| `qg` | Quantile Gamma | 3 → 1 |
| `qh` | Quantile Hypergeometric | 4 → 1 |
| `ql` | Quantile Log-Normal | 3 → 1 |
| `qn` | Quantile Normal | 1 → 1 |
| `qt` | Quantile Student-t | 2 → 1 |
| `qu` | Quantile Uniform | 3 → 1 |
| `qw` | Quantile Weibull | 3 → 1 |
| `rB` | Random Binomial | 3 → 1 |
| `rG` | Random Geometric | 2 → 1 |
| `rL` | Random Logistic | 3 → 1 |
| `rN` | Random Neg-Binomial | 3 → 1 |
| `rP` | Random Poisson | 2 → 1 |
| `rb` | Random Binomial | 1 → 1 |
| `rc` | Random Cauchy | 3 → 1 |
| `re` | Random Exp | 1 → 1 |
| `rg` | Random Gamma | 3 → 1 |
| `rh` | Random Hypergeometric | 4 → 1 |
| `rl` | Random Log-Normal | 3 → 1 |
| `rp` | Random Poisson | 1 → 1 |
| `rt` | Random Student-t | 2 → 1 |
| `rw` | Random Weibull | 3 → 1 |
| `s4` | EmptyLog | 0 → 1 |
| `sR` | Regexpr | 2 → 1 |
| `sX` | Gregexpr | 2 → 1 |
| `tg` | Trigamma | 1 → 1 |

### 7.9 Math Functions

| Symbol | Description | Stack Effect |
|--------|-------------|--------------|
| `Bs` | Standard Deviation | 1 → 1 |
| `SP` | Sin(pi*x) | 1 → 1 |
| `XC` | CumSum | 1 → 1 |
| `a2` | ArcTan2 | 2 → 1 |
| `aC` | ArcCos | 1 → 1 |
| `aS` | ArcSin | 1 → 1 |
| `aT` | ArcTan | 1 → 1 |
| `ac` | ArcCosh | 1 → 1 |
| `as` | ArcSinh | 1 → 1 |
| `at` | ArcTanh | 1 → 1 |
| `bA` | BitAnd | 2 → 1 |
| `c1` | CumProd | 1 → 1 |
| `ch` | Cosh | 1 → 1 |
| `cn` | IsIn | 2 → 1 |
| `cp` | Cos(pi*x) | 1 → 1 |
| `mc` | Cos | 1 → 1 |
| `ms` | Sin | 1 → 1 |
| `mt` | Tan | 1 → 1 |
| `sD` | SetDiff | 2 → 1 |
| `sd` | Standard Deviation | 1 → 1 |
| `sh` | Sinh | 1 → 1 |
| `th` | Tanh | 1 → 1 |
| `tp` | Tan(pi*x) | 1 → 1 |
| `vF` | Diff | 1 → 1 |
| `vI` | CumMin | 1 → 1 |
| `vX` | CumMax | 1 → 1 |

### 7.10 Combinatorics & Special

| Symbol | Description | Stack Effect |
|--------|-------------|--------------|
| `MC` | Choose | 2 → 1 |
| `Xn` | Choose (nCr) | 2 → 1 |
| `fp` | Factorial | 1 → 1 |

### 7.11 Complex Numbers

| Symbol | Description | Stack Effect |
|--------|-------------|--------------|
| `cA` | Arg | 1 → 1 |
| `cI` | Imag Part | 1 → 1 |
| `cJ` | Conjugate | 1 → 1 |
| `cM` | Modulus | 1 → 1 |
| `cR` | Real Part | 1 → 1 |

### 7.12 String Operations

| Symbol | Description | Stack Effect |
|--------|-------------|--------------|
| `,` | Concat Vectors | 2 → 1 |
| `C` | Concat | 2 → 1 |
| `J` | Join List | 2 → 1 |
| `S` | Split String | 2 → 1 |
| `S!` | Translate | 3 → 1 |
| `SG` | GSub | 3 → 1 |
| `Xc` | Char Translate | 3 → 1 |
| `Xt` | ToLower | 1 → 1 |
| `a` | To String | 1 → 1 |
| `c` | To Char | 1 → 1 |
| `dS` | Split | 2 → 1 |
| `dU` | Unsplit | 2 → 1 |
| `j` | Join | 2 → 1 |
| `sB` | Grepl | 2 → 1 |
| `sG` | Grep | 2 → 1 |
| `sL` | ToLower | 1 → 1 |
| `sM` | Message | 1 → 0 |
| `sQ` | EmptyChar | 0 → 1 |
| `sS` | Stop | 1 → 0 |
| `sU` | ToUpper | 1 → 1 |
| `sW` | Warning | 1 → 0 |
| `sf` | Sprintf | 2 → 1 |
| `sn` | NChar | 1 → 1 |
| `ss` | Substr | 3 → 1 |
| `st` | TrimWS | 1 → 1 |

### 7.13 Set Operations

| Symbol | Description | Stack Effect |
|--------|-------------|--------------|
| `sF` | SetPrompt | 1 → 0 |
| `sI` | Intersect | 2 → 1 |
| `sJ` | SetWD | 1 → 0 |
| `sN` | Union | 2 → 1 |
| `sY` | SetScipen | 1 → 0 |
| `se` | Setenv | 1 → 0 |

### 7.14 Bitwise Operations

| Symbol | Description | Stack Effect |
|--------|-------------|--------------|
| `bL` | BitShiftL | 2 → 1 |
| `bN` | BitNot | 1 → 1 |
| `bO` | BitOr | 2 → 1 |
| `bR` | BitShiftR | 2 → 1 |
| `bX` | BitXor | 2 → 1 |

### 7.15 Type & Introspection

| Symbol | Description | Stack Effect |
|--------|-------------|--------------|
| `AS` | As Type | 2 → 1 |
| `Xq` | Is Prime | 1 → 1 |
| `is` | Is Type | 2 → 1 |
| `mp` | Is Prime | 1 → 1 |
| `oA` | Attr | 2 → 1 |
| `oC` | Colnames | 1 → 1 |
| `oa` | Attributes | 1 → 1 |
| `oc` | Class | 1 → 1 |
| `od` | Dim | 1 → 1 |
| `on` | Names | 1 → 1 |
| `or` | Rownames | 1 → 1 |
| `ot` | Typeof | 1 → 1 |
| `ou` | Unlist | 1 → 1 |

### 7.16 File I/O

| Symbol | Description | Stack Effect |
|--------|-------------|--------------|
| `F` | Read File | 1 → 1 |
| `FL` | List Files | 1 → 1 |
| `FW` | Write File | 2 → 0 |
| `W` | Write File | 2 → 0 |
| `fA` | Dirname | 1 → 1 |
| `fC` | Write CSV | 2 → 0 |
| `fD` | List Dirs | 1 → 1 |
| `fN` | File Create | 1 → 1 |
| `fP` | Abs Path | 1 → 1 |
| `fT` | Temp File | 0 → 1 |
| `fX` | Dir Exists | 1 → 1 |
| `fb` | Basename | 1 → 1 |
| `fc` | Read CSV | 1 → 1 |
| `fd` | Dir Create | 1 → 1 |
| `fe` | File Exists | 1 → 1 |
| `fi` | File Info | 1 → 1 |
| `fm` | File Remove | 1 → 1 |
| `fr` | Read Table | 1 → 1 |
| `ft` | Temp Dir | 0 → 1 |
| `fw` | Write Table | 2 → 0 |

### 7.17 System

| Symbol | Description | Stack Effect |
|--------|-------------|--------------|
| `T` | Time Epoch | 0 → 1 |
| `ZT` | Timezone | 0 → 1 |
| `ge` | Getenv | 1 → 1 |
| `pi` | GetPID | 0 → 1 |
| `sK` | Toc | 1 → 1 |
| `sP` | Sleep | 1 → 0 |
| `sT` | Tic | 0 → 1 |
| `sV` | RVersion | 0 → 1 |
| `um` | Umask | 1 → 1 |
| `zg` | GC | 0 → 1 |
| `zl` | Locale | 0 → 1 |
| `zo` | Options | 0 → 1 |
| `zt` | SysTime | 0 → 1 |
| `zv` | Version | 0 → 1 |

### 7.18 Other

| Symbol | Description | Stack Effect |
|--------|-------------|--------------|
| `#` | Filter | 2 → 1 |
| `&` | Outer Product | 2 → 1 |
| `..` | Pair | 2 → 1 |
| `A` | To ASCII | 1 → 1 |
| `BT` | Bingo Twin | 1 → 1 |
| `Bz` | Scale | 1 → 1 |
| `Fa` | Apply | 3 → 1 |
| `Ff` | Filter (Func) | 2 → 1 |
| `Fl` | Lapply | 2 → 1 |
| `Fm` | Mapply | 1 → 1 |
| `Fn` | Find (Func) | 2 → 1 |
| `Fp` | Position | 2 → 1 |
| `Fs` | Sapply | 2 → 1 |
| `Fv` | Vapply | 3 → 1 |
| `In` | Inf | 0 → 1 |
| `KA` | AOV | 1 → 1 |
| `Na` | NA | 0 → 1 |
| `P` | Product | 1 → 1 |
| `Pi` | Pi | 0 → 1 |
| `Q` | Quantile | 1 → 1 |
| `XP` | Prime Factors | 1 → 1 |
| `Xb` | To Binary | 1 → 1 |
| `Xd` | To Date | 1 → 1 |
| `Xk` | RLE | 1 → 2 |
| `Xo` | Mode | 1 → 1 |
| `Xr` | RMS | 1 → 1 |
| `Xs` | Std Dev | 1 → 1 |
| `dA` | Aggregate | 3 → 1 |
| `dE` | Cut | 2 → 1 |
| `dO` | Order | 1 → 1 |
| `dT` | Table | 1 → 1 |
| `dX` | XTabs | 2 → 1 |
| `dY` | By | 3 → 1 |
| `fa` | Factors | 1 → 1 |
| `fn` | Negate | 1 → 1 |
| `g` | GCD | 2 → 1 |
| `lA` | Any | 1 → 1 |
| `lX` | Xor | 2 → 1 |
| `lZ` | NNZ | 1 → 1 |
| `lc` | LCM | 2 → 1 |
| `mF` | Factor | 1 → 1 |
| `mI` | IntDiv | 2 → 1 |
| `mQ` | Quantile | 2 → 1 |
| `mf` | Prime Factors | 1 → 1 |
| `ml` | LCM | 2 → 1 |
| `n` | To Number | 1 → 1 |
| `ns` | NegSlice | 2 → 1 |
| `p` | Print | 1 → 0 |
| `pC` | Prob Chi-Square | 2 → 1 |
| `pf` | Prob F | 3 → 1 |
| `qC` | Quantile Chi-Square | 2 → 1 |
| `qf` | Quantile F | 3 → 1 |
| `r` | Random (n) | 1 → 1 |
| `r2` | Rep | 2 → 1 |
| `rC` | Random Chi-Square | 2 → 1 |
| `rf` | Random F | 3 → 1 |
| `rm` | RMS | 1 → 1 |
| `sC` | Cat | 1 → 0 |
| `sE` | Date | 0 → 1 |
| `sH` | GetWD | 0 → 1 |
| `sZ` | EmptyNum | 0 → 1 |
| `sc` | Scale | 1 → 1 |
| `sr` | Sub | 3 → 1 |
| `vA` | All | 1 → 1 |
| `vC` | Col Indices | 1 → 1 |
| `vD` | Drop | 1 → 1 |
| `vR` | Row Indices | 1 → 1 |
| `vT` | RepMat | 3 → 1 |
| `zd` | To Date | 1 → 1 |
| `\|` | Or | 2 → 1 |

