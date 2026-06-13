# RATL ASCII Rewrite Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use compose:subagent (recommended) or compose:execute to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace all multi-byte Greek symbols with ASCII equivalents, add missing critical code-golf operations, and shorten verbose prefix names — making RATL competitive on byte count.

**Architecture:** Single TSV edit (`src/ratl_def.tsv`) + evaluator alias additions (`src/ratl_eval.R`). Parser is TSV-driven, so symbol swaps are pure configuration. No parser changes needed.

**Tech Stack:** R, TSV definitions, existing test suite

---

## File Structure

| File | Change |
|------|--------|
| `src/ratl_def.tsv` | Rewrite `src` column: Greek→ASCII, shorten long names |
| `src/ratl_eval.R` | Add evaluator-only short aliases for block consumers |
| `tests/test_runner.R` | Update tests to use new symbols |
| `RATL_SPEC.md` | Update symbol documentation |

---

## Symbol Mapping

### Greek → ASCII (14 replacements)

| Current (2B) | New (1B) | Operation | Free char used |
|---|---|---|---|
| `μ` | `m` | Mean | `m` |
| `σ` | `d` | Std Dev | `d` |
| `ς` | `V` | Variance | `V` |
| `η` | `h` | Median | `h` |
| `ϙ` | `Q` | Quantile | `Q` |
| `τ` | `T` | T-Test | `T` — CONFLICT (already = Sys.time()) |
| `ν` | `N` | Random Normal | `N` |
| `δ` | `D` | Density Normal | `D` — CONFLICT (already = Duplicate) |
| `ω` | `W` | Summary | `W` — CONFLICT (already = Write File) |
| `λ` | `L` | Linear Model | `L` — CONFLICT (already = Clipboard L) |
| `α` | `A` | Anova | `A` — CONFLICT (already = To ASCII) |
| `ρ` | `R` | Correlation | `R` — CONFLICT (already = Reverse) |
| `κ` | `K` | Covariance | `K` |
| `ζ` | `Z` | Scale | `Z` |

**Conflicts resolve by priority:** Code-golf-common operations keep their 1B slot. Conflicting Greek stats ops get 2-char ASCII names instead.

### Resolved Mapping

| Greek (2B) | New (1B/2B) | Operation |
|---|---|---|
| `μ` | `m` | Mean |
| `σ` | `sd` | Std Dev (keep existing `sd` = `Xs`) |
| `ς` | `V` | Variance |
| `η` | `h` | Median |
| `ϙ` | `Q` | Quantile |
| `τ` | `tt` | T-Test |
| `ν` | `N` | Random Normal |
| `δ` | `dn` | Density Normal (keep `dn`) |
| `ω` | `sm` | Summary |
| `λ` | `lm` | Linear Model (keep `lm`) |
| `α` | `av` | Anova |
| `ρ` | `cr` | Correlation |
| `κ` | `cv` | Covariance |
| `ζ` | `sc` | Scale |

### New Missing Operations (ASCII-only)

| Symbol (1-2B) | Operation | Why needed |
|---|---|---|
| `<=` | Less or equal | Missing, used constantly |
| `>=` | Greater or equal | Missing, used constantly |
| `sq` | Square root | Missing, common |
| `ab` | Absolute value | Already exists |
| `g` | GCD (move from `Xg`) | Common |
| `lc` | LCM (move from `Xl`) | Common |
| `fp` | Factorial (move from `m!`) | Common — `!` is transpose |
| `mp` | Is prime (move from `Xq`) | Common |
| `fl` | Flatten (move from `Fu`) | Common |
| `zp` | Zip (move from `Fz`) | Common |
| `rv` | Reverse string (move from `F!`) | Common |
| `hd` | Head N (move from `v.head`) | Common |
| `tl` | Tail N (move from `v.tail`) | Common |
| `la` | Last element (move from `v.last`) | Common |
| `fi` | First element (move from `v.first`) | CONFLICT (file.info) |
| `rn` | Range 1..N (move from `v.range`) | Common |
| `ns` | Neg slice (move from `v.nslice`) | Occasional |
| `un` | Unique count (move from `v.ntab`) | Occasional |
| `ix` | Index of (move from `v.iin`) | Occasional |
| `cn` | Contains (move from `v.isin`) | Occasional |

### Shorter Prefix Alternatives

| Current (3-6B) | New (2B) | Operation |
|---|---|---|
| `v.cumprod` | `cp` | Cumulative product |
| `v.tab` | `tb` | Tabulate |
| `v.head` | `hd` | Head N |
| `v.tail` | `tl` | Tail N |
| `v.first` | `fe` | First elem — CONFLICT (file.exists) |
| `v.last` | `la` | Last elem |
| `v.range` | `rn` | Range 1..N |
| `v.nslice` | `ns` | Neg slice |
| `v.ntab` | `un` | Unique count |
| `v.iin` | `ix` | Index of |
| `v.isin` | `cn` | Contains |
| `v.slice` | `sl` | Slice |
| `v.rep` | `rp` | Rep |
| `v.unique` | `uq` | Unique |
| `v.rev` | `vr` | Reverse |
| `v.sum` | `vs` | Sum vec |
| `v.prod` | `vp` | Product vec |
| `stat.rms` | `rm` | RMS |
| `v.which` | `wh` | Which |

---

## Task 1: Replace Greek Symbols in TSV

**Covers:** Greek→ASCII mapping

**Files:**
- Modify: `src/ratl_def.tsv` (lines with μ, σ, ς, η, ϙ, τ, ν, δ, ω, λ, α, ρ, κ, ζ)

- [ ] **Step 1: Replace all 14 Greek symbols with ASCII equivalents in TSV**

Edit each Greek row's `src` column:
```
μ  -> m    (mean)
σ  -> sd   (std dev) — already has `Xs` alias, add `sd` as primary
ς  -> V    (variance)
η  -> h    (median)
ϙ  -> Q    (quantile)
τ  -> tt   (t-test)
ν  -> N    (random normal)
δ  -> dn   (density normal) — already exists
ω  -> sm   (summary)
λ  -> lm   (linear model) — already exists
α  -> av   (anova)
ρ  -> cr   (correlation)
κ  -> cv   (covariance)
ζ  -> sc   (scale)
```

- [ ] **Step 2: Verify no symbol conflicts**

Run: `python3 -c "..."` to check no two rows share the same `src`.

- [ ] **Step 3: Run existing tests**

Run: `cd /home/ubuntu/RATL && Rscript tests/test_runner.R`
Expected: All tests still pass (Greek symbols weren't in test code).

---

## Task 2: Add Missing Critical Operations

**Covers:** <=, >=, sqrt, shorten long names

**Files:**
- Modify: `src/ratl_def.tsv` (add new rows, rename long prefixes)

- [ ] **Step 1: Add <=, >=, sq to TSV**

Add rows:
```
<=	$2 <= $1	2	1	LessEqual
>=	$2 >= $1	2	1	GreatEqual
sq	sqrt($1)	1	1	Sqrt
```

- [ ] **Step 2: Shorten long prefix names**

Rename these rows in TSV:
```
v.head    -> hd
v.tail    -> tl
v.first   -> fe  (conflict with file.exists, keep both)
v.last    -> la
v.range   -> rn
v.nslice  -> ns
v.ntab    -> un
v.iin     -> ix
v.isin    -> cn
v.slice   -> sl
v.rep     -> rp
v.unique  -> uq
v.rev     -> vr
v.sum     -> vs
v.prod    -> vp
v.cumprod -> cp
v.tab     -> tb
v.which   -> wh
stat.rms  -> rm
Xg        -> g   (GCD)
Xl        -> lc  (LCM)
Xq        -> mp  (Is Prime)
Xf        -> fa  (Factors)
Fu        -> fl  (Flatten)
Fz        -> zp  (Zip)
F!        -> rv  (Reverse String)
m!        -> fp  (Factorial)
```

- [ ] **Step 3: Run tests**

Run: `Rscript tests/test_runner.R`
Expected: All tests pass.

---

## Task 3: Update Evaluator Short Aliases

**Covers:** Block consumer short names

**Files:**
- Modify: `src/ratl_eval.R`

- [ ] **Step 1: Verify existing short aliases still work**

`q` (map), `e` (filter), `y` (reduce), `z` (repeat) already exist. Just confirm they survived the TSV edits.

- [ ] **Step 2: Run tests**

---

## Task 4: Update Test Suite

**Covers:** All tests use new symbol names

**Files:**
- Modify: `tests/test_runner.R`

- [ ] **Step 1: Update any tests using renamed symbols**

Search for old names (`v.head`, `v.tail`, `v.last`, `v.first`, `v.range`, `v.nslice`, `v.iin`, `v.isin`, `Xq`, `Xg`, `Xl`, `m!`, `Fu`, `Fz`, `F!`) and replace with new names.

- [ ] **Step 2: Add tests for new operations (<=, >=, sq)**

Add test cases:
```
list(name = "LessEqual true", code = "3 5 <=", expected = "TRUE")
list(name = "LessEqual false", code = "5 3 <=", expected = "FALSE")
list(name = "GreatEqual true", code = "5 3 >=", expected = "TRUE")
list(name = "GreatEqual false", code = "3 5 >=", expected = "FALSE")
list(name = "Sqrt", code = "9 sq", expected = "3")
```

- [ ] **Step 3: Run full test suite**

Run: `Rscript tests/test_runner.R`
Expected: All tests pass.

---

## Task 5: Update Spec and Examples

**Covers:** Documentation

**Files:**
- Modify: `RATL_SPEC.md`
- Modify: `examples/*.ratl` (update any using old symbol names)

- [ ] **Step 1: Rewrite symbol table in spec**

Replace Greek symbols with ASCII equivalents in the category table.

- [ ] **Step 2: Update examples that use renamed symbols**

Check `examples/` for `Xq`, `Xg`, `Xl`, `m!`, `Fu`, etc.

- [ ] **Step 3: Final full test run**

Run: `Rscript tests/test_runner.R && ./tests/test_ratl.sh`
Expected: All pass.

---

## Final Symbol Count After Rewrite

| Category | Count | Byte cost per use |
|---|---|---|
| 1-byte ASCII (core) | ~55 | 1 |
| 2-byte ASCII (short) | ~30 | 2 |
| Greek/Cyrillic (niche) | 0 | 0 |
| **Total** | ~85 active | avg ~1.3B |

**Before rewrite:** 455 symbols, 14 at 2B each, many at 3-6B
**After rewrite:** ~85 most-used symbols, ALL ASCII, max 2B per symbol
