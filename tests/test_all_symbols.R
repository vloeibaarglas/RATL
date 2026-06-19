#!/usr/bin/env Rscript
# Auto-generated unit tests from src/ratl_def.tsv
# Do not edit manually — run: python3 scripts/gen_tests.py

source("src/ratl_lib.R")
source("src/ratl_stack.R")
source("src/ratl_dispatch.R")
source("src/ratl_parse.R")
source("src/ratl_eval.R")
dispatch_env <- build_dispatch("src/ratl_def.tsv")

run_ratl <- function(code) {
  tokens <- ratl_parse(code, dispatch_env)
  ctx <- new.env(parent = emptyenv())
  ctx$stack <- make_stack()
  ctx$dispatch <- dispatch_env
  ctx$clipboards <- new.env(parent = emptyenv())
  ctx$stdin <- file("/dev/null", "r")
  ctx$in_loop <- FALSE
  tryCatch({
    ratl_eval(tokens, ctx)
    close(ctx$stdin)
    s <- ctx$stack
    if (stack_length(s) == 1) paste(stack_peek(s), collapse=" ")
    else if (stack_length(s) > 1) paste(sapply(stack_to_list(s), function(x) paste(x, collapse=" ")), collapse=" ")
    else ""
  }, error = function(e) { tryCatch(close(ctx$stdin), error=function(e2) NULL); paste("ERROR:", e$message) })
}

escape_test_name <- function(s) {
  gsub("[^A-Za-z0-9_]", "_", s)
}

set.seed(42)
passed <- 0
failed <- 0
skipped <- 0
failures <- character()

cat(sprintf("Testing 421 symbols (unit tests)\n"))
cat("============================\n")

# Arithmetic & Comparison: + — Add
test___Add <- function() {
  r <- run_ratl("3 5 +")
  if (grepl("Error:", r)) { cat("FAIL [+] Add: ", r, "\n"); return(FALSE) }
  if (r != "8") {
    cat("FAIL [+] Add: expected [8], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Arithmetic & Comparison: - — Subtract
test___Subtract <- function() {
  r <- run_ratl("3 5 -")
  if (grepl("Error:", r)) { cat("FAIL [-] Subtract: ", r, "\n"); return(FALSE) }
  if (r != "-2") {
    cat("FAIL [-] Subtract: expected [-2], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Arithmetic & Comparison: * — Multiply
test___Multiply <- function() {
  r <- run_ratl("3 5 *")
  if (grepl("Error:", r)) { cat("FAIL [*] Multiply: ", r, "\n"); return(FALSE) }
  if (r != "15") {
    cat("FAIL [*] Multiply: expected [15], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Arithmetic & Comparison: / — Divide
test___Divide <- function() {
  r <- run_ratl("3 5 /")
  if (grepl("Error:", r)) { cat("FAIL [/] Divide: ", r, "\n"); return(FALSE) }
  if (r != "0.6") {
    cat("FAIL [/] Divide: expected [0.6], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Arithmetic & Comparison: % — Modulo
test___Modulo <- function() {
  r <- run_ratl("3 5 %")
  if (grepl("Error:", r)) { cat("FAIL [%] Modulo: ", r, "\n"); return(FALSE) }
  if (r != "3") {
    cat("FAIL [%] Modulo: expected [3], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Arithmetic & Comparison: ^ — Power
test___Power <- function() {
  r <- run_ratl("3 5 ^")
  if (grepl("Error:", r)) { cat("FAIL [^] Power: ", r, "\n"); return(FALSE) }
  if (r != "243") {
    cat("FAIL [^] Power: expected [243], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Arithmetic & Comparison: = — Equal
test___Equal <- function() {
  r <- run_ratl("3 5 =")
  if (grepl("Error:", r)) { cat("FAIL [=] Equal: ", r, "\n"); return(FALSE) }
  if (r != "FALSE") {
    cat("FAIL [=] Equal: expected [FALSE], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Arithmetic & Comparison: < — Less
test___Less <- function() {
  r <- run_ratl("3 5 <")
  if (grepl("Error:", r)) { cat("FAIL [<] Less: ", r, "\n"); return(FALSE) }
  if (r != "TRUE") {
    cat("FAIL [<] Less: expected [TRUE], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Arithmetic & Comparison: > — Greater
test___Greater <- function() {
  r <- run_ratl("3 5 >")
  if (grepl("Error:", r)) { cat("FAIL [>] Greater: ", r, "\n"); return(FALSE) }
  if (r != "FALSE") {
    cat("FAIL [>] Greater: expected [FALSE], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Arithmetic & Comparison: <= — LessEqual
test____LessEqual <- function() {
  r <- run_ratl("3 5 <=")
  if (grepl("Error:", r)) { cat("FAIL [<=] LessEqual: ", r, "\n"); return(FALSE) }
  if (r != "TRUE") {
    cat("FAIL [<=] LessEqual: expected [TRUE], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Arithmetic & Comparison: >= — GreatEqual
test____GreatEqual <- function() {
  r <- run_ratl("3 5 >=")
  if (grepl("Error:", r)) { cat("FAIL [>=] GreatEqual: ", r, "\n"); return(FALSE) }
  if (r != "FALSE") {
    cat("FAIL [>=] GreatEqual: expected [FALSE], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Arithmetic & Comparison: ~ — Not
test___Not <- function() {
  r <- run_ratl("5 ~")
  if (grepl("Error:", r)) { cat("FAIL [~] Not: ", r, "\n"); return(FALSE) }
  if (r != "FALSE") {
    cat("FAIL [~] Not: expected [FALSE], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Arithmetic & Comparison: | — Or
test___Or <- function() {
  r <- run_ratl("3 5 |")
  if (grepl("Error:", r)) { cat("FAIL [|] Or: ", r, "\n"); return(FALSE) }
  if (r != "TRUE") {
    cat("FAIL [|] Or: expected [TRUE], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Arithmetic & Comparison: lX — Xor
test_lX_Xor <- function() {
  r <- run_ratl("3 5 lX")
  if (grepl("Error:", r)) { cat("FAIL [lX] Xor: ", r, "\n"); return(FALSE) }
  if (r != "FALSE") {
    cat("FAIL [lX] Xor: expected [FALSE], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Arithmetic & Comparison: mI — IntDiv
test_mI_IntDiv <- function() {
  r <- run_ratl("3 5 mI")
  if (grepl("Error:", r)) { cat("FAIL [mI] IntDiv: ", r, "\n"); return(FALSE) }
  if (r != "0") {
    cat("FAIL [mI] IntDiv: expected [0], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Stack & Control: D — Duplicate
test_D_Duplicate <- function() {
  r <- run_ratl("5 D")
  if (grepl("Error:", r)) { cat("FAIL [D] Duplicate: ", r, "\n"); return(FALSE) }
  if (r != "5 5") {
    cat("FAIL [D] Duplicate: expected [5 5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Stack & Control: w — Swap
test_w_Swap <- function() {
  r <- run_ratl("3 5 w")
  if (grepl("Error:", r)) { cat("FAIL [w] Swap: ", r, "\n"); return(FALSE) }
  if (r != "5 3") {
    cat("FAIL [w] Swap: expected [5 3], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Stack & Control: x — Delete
test_x_Delete <- function() {
  r <- run_ratl("5 x")
  if (grepl("Error:", r)) { cat("FAIL [x] Delete: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# Stack & Control: U — Unpack
test_U_Unpack <- function() {
  r <- run_ratl("5 U")
  if (grepl("Error:", r)) { cat("FAIL [U] Unpack: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: object of type 'closure' is not subsettable") {
    cat("FAIL [U] Unpack: expected [ERROR: object of type 'closure' is not subsettable], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Stack & Control: Ls — Stack Length
test_Ls_Stack_Length <- function() {
  set.seed(42)
  r <- run_ratl("Ls")
  if (grepl("Error:", r)) { cat("FAIL [Ls] Stack Length: ", r, "\n"); return(FALSE) }
  if (r != "1") {
    cat("FAIL [Ls] Stack Length: expected [1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# SKIP i (Input) — no test_input defined
skipped <- skipped + 1

# SKIP p (Print) — no test_input defined
skipped <- skipped + 1

# SKIP sC (Cat) — no test_input defined
skipped <- skipped + 1

# SKIP sM (Message) — no test_input defined
skipped <- skipped + 1

# SKIP sW (Warning) — no test_input defined
skipped <- skipped + 1

# SKIP sS (Stop) — no test_input defined
skipped <- skipped + 1

# Constants: Pi — Pi
test_Pi_Pi <- function() {
  set.seed(42)
  r <- run_ratl("Pi")
  if (grepl("Error:", r)) { cat("FAIL [Pi] Pi: ", r, "\n"); return(FALSE) }
  if (r != "3.14159265358979") {
    cat("FAIL [Pi] Pi: expected [3.14159265358979], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Constants: Na — NA
test_Na_NA <- function() {
  set.seed(42)
  r <- run_ratl("Na")
  if (grepl("Error:", r)) { cat("FAIL [Na] NA: ", r, "\n"); return(FALSE) }
  if (r != "NA") {
    cat("FAIL [Na] NA: expected [NA], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Constants: In — Inf
test_In_Inf <- function() {
  set.seed(42)
  r <- run_ratl("In")
  if (grepl("Error:", r)) { cat("FAIL [In] Inf: ", r, "\n"); return(FALSE) }
  if (r != "Inf") {
    cat("FAIL [In] Inf: expected [Inf], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Constants: sZ — EmptyNum
test_sZ_EmptyNum <- function() {
  set.seed(42)
  r <- run_ratl("sZ")
  if (grepl("Error:", r)) { cat("FAIL [sZ] EmptyNum: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# Constants: sQ — EmptyChar
test_sQ_EmptyChar <- function() {
  set.seed(42)
  r <- run_ratl("sQ")
  if (grepl("Error:", r)) { cat("FAIL [sQ] EmptyChar: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# Constants: s4 — EmptyLog
test_s4_EmptyLog <- function() {
  set.seed(42)
  r <- run_ratl("s4")
  if (grepl("Error:", r)) { cat("FAIL [s4] EmptyLog: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# Higher-Order Functions: q — Map (evaluator)
test_q_Map__evaluator_ <- function() {
  set.seed(42)
  r <- run_ratl("q")
  if (grepl("Error:", r)) { cat("FAIL [q] Map (evaluator): ", r, "\n"); return(FALSE) }
  if (r != "ERROR: Stack underflow for Fq (map)") {
    cat("FAIL [q] Map (evaluator): expected [ERROR: Stack underflow for Fq (map)], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Higher-Order Functions: e — Filter (evaluator)
test_e_Filter__evaluator_ <- function() {
  set.seed(42)
  r <- run_ratl("e")
  if (grepl("Error:", r)) { cat("FAIL [e] Filter (evaluator): ", r, "\n"); return(FALSE) }
  if (r != "ERROR: Stack underflow for Ft (filter)") {
    cat("FAIL [e] Filter (evaluator): expected [ERROR: Stack underflow for Ft (filter)], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Higher-Order Functions: y — Reduce (evaluator)
test_y_Reduce__evaluator_ <- function() {
  set.seed(42)
  r <- run_ratl("y")
  if (grepl("Error:", r)) { cat("FAIL [y] Reduce (evaluator): ", r, "\n"); return(FALSE) }
  if (r != "ERROR: Stack underflow for Fr (reduce)") {
    cat("FAIL [y] Reduce (evaluator): expected [ERROR: Stack underflow for Fr (reduce)], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Higher-Order Functions: z — Repeat (evaluator)
test_z_Repeat__evaluator_ <- function() {
  set.seed(42)
  r <- run_ratl("z")
  if (grepl("Error:", r)) { cat("FAIL [z] Repeat (evaluator): ", r, "\n"); return(FALSE) }
  if (r != "ERROR: Stack underflow for Fx (repeat)") {
    cat("FAIL [z] Repeat (evaluator): expected [ERROR: Stack underflow for Fx (repeat)], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Higher-Order Functions: Fq — Map (evaluator)
test_Fq_Map__evaluator_ <- function() {
  set.seed(42)
  r <- run_ratl("Fq")
  if (grepl("Error:", r)) { cat("FAIL [Fq] Map (evaluator): ", r, "\n"); return(FALSE) }
  if (r != "ERROR: Stack underflow for Fq (map)") {
    cat("FAIL [Fq] Map (evaluator): expected [ERROR: Stack underflow for Fq (map)], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Higher-Order Functions: Ft — Filter (evaluator)
test_Ft_Filter__evaluator_ <- function() {
  set.seed(42)
  r <- run_ratl("Ft")
  if (grepl("Error:", r)) { cat("FAIL [Ft] Filter (evaluator): ", r, "\n"); return(FALSE) }
  if (r != "ERROR: Stack underflow for Ft (filter)") {
    cat("FAIL [Ft] Filter (evaluator): expected [ERROR: Stack underflow for Ft (filter)], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Higher-Order Functions: Fx — Repeat (evaluator)
test_Fx_Repeat__evaluator_ <- function() {
  set.seed(42)
  r <- run_ratl("Fx")
  if (grepl("Error:", r)) { cat("FAIL [Fx] Repeat (evaluator): ", r, "\n"); return(FALSE) }
  if (r != "ERROR: Stack underflow for Fx (repeat)") {
    cat("FAIL [Fx] Repeat (evaluator): expected [ERROR: Stack underflow for Fx (repeat)], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Higher-Order Functions: Fr — Reduce
test_Fr_Reduce <- function() {
  r <- run_ratl("3 5 Fr")
  if (grepl("Error:", r)) { cat("FAIL [Fr] Reduce: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: $ operator is invalid for atomic vectors") {
    cat("FAIL [Fr] Reduce: expected [ERROR: $ operator is invalid for atomic vectors], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Higher-Order Functions: Fa — Apply
test_Fa_Apply <- function() {
  r <- run_ratl("1 2 3 Fa")
  if (grepl("Error:", r)) { cat("FAIL [Fa] Apply: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: object 'v1' of mode 'function' was not found") {
    cat("FAIL [Fa] Apply: expected [ERROR: object 'v1' of mode 'function' was not found], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Higher-Order Functions: Fl — Lapply
test_Fl_Lapply <- function() {
  r <- run_ratl("3 5 Fl")
  if (grepl("Error:", r)) { cat("FAIL [Fl] Lapply: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: object 'v1' of mode 'function' was not found") {
    cat("FAIL [Fl] Lapply: expected [ERROR: object 'v1' of mode 'function' was not found], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Higher-Order Functions: Fs — Sapply
test_Fs_Sapply <- function() {
  r <- run_ratl("3 5 Fs")
  if (grepl("Error:", r)) { cat("FAIL [Fs] Sapply: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: object 'v1' of mode 'function' was not found") {
    cat("FAIL [Fs] Sapply: expected [ERROR: object 'v1' of mode 'function' was not found], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Higher-Order Functions: Fv — Vapply
test_Fv_Vapply <- function() {
  r <- run_ratl("1 2 3 Fv")
  if (grepl("Error:", r)) { cat("FAIL [Fv] Vapply: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: object 'v2' of mode 'function' was not found") {
    cat("FAIL [Fv] Vapply: expected [ERROR: object 'v2' of mode 'function' was not found], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Higher-Order Functions: Fm — Mapply
test_Fm_Mapply <- function() {
  r <- run_ratl("5 Fm")
  if (grepl("Error:", r)) { cat("FAIL [Fm] Mapply: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: '...' used in an incorrect context") {
    cat("FAIL [Fm] Mapply: expected [ERROR: '...' used in an incorrect context], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Higher-Order Functions: Ff — Filter (Func)
test_Ff_Filter__Func_ <- function() {
  r <- run_ratl("3 5 Ff")
  if (grepl("Error:", r)) { cat("FAIL [Ff] Filter (Func): ", r, "\n"); return(FALSE) }
  if (r != "ERROR: object 'v2' of mode 'function' was not found") {
    cat("FAIL [Ff] Filter (Func): expected [ERROR: object 'v2' of mode 'function' was not found], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Higher-Order Functions: Fn — Find (Func)
test_Fn_Find__Func_ <- function() {
  r <- run_ratl("3 5 Fn")
  if (grepl("Error:", r)) { cat("FAIL [Fn] Find (Func): ", r, "\n"); return(FALSE) }
  if (r != "ERROR: object 'v2' of mode 'function' was not found") {
    cat("FAIL [Fn] Find (Func): expected [ERROR: object 'v2' of mode 'function' was not found], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Higher-Order Functions: Fp — Position
test_Fp_Position <- function() {
  r <- run_ratl("3 5 Fp")
  if (grepl("Error:", r)) { cat("FAIL [Fp] Position: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: object 'v2' of mode 'function' was not found") {
    cat("FAIL [Fp] Position: expected [ERROR: object 'v2' of mode 'function' was not found], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Higher-Order Functions: fn — Negate
test_fn_Negate <- function() {
  r <- run_ratl("5 fn")
  if (grepl("Error:", r)) { cat("FAIL [fn] Negate: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: object 'v1' of mode 'function' was not found") {
    cat("FAIL [fn] Negate: expected [ERROR: object 'v1' of mode 'function' was not found], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: : — Sequence
test___Sequence <- function() {
  r <- run_ratl("3 5 :")
  if (grepl("Error:", r)) { cat("FAIL [:] Sequence: ", r, "\n"); return(FALSE) }
  if (r != "3 4 5") {
    cat("FAIL [:] Sequence: expected [3 4 5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: O — Sort
test_O_Sort <- function() {
  r <- run_ratl("5 O")
  if (grepl("Error:", r)) { cat("FAIL [O] Sort: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [O] Sort: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: R — Reverse
test_R_Reverse <- function() {
  r <- run_ratl("5 R")
  if (grepl("Error:", r)) { cat("FAIL [R] Reverse: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [R] Reverse: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: u — Unique
test_u_Unique <- function() {
  r <- run_ratl("5 u")
  if (grepl("Error:", r)) { cat("FAIL [u] Unique: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [u] Unique: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: l — Length
test_l_Length <- function() {
  r <- run_ratl("5 l")
  if (grepl("Error:", r)) { cat("FAIL [l] Length: ", r, "\n"); return(FALSE) }
  if (r != "1") {
    cat("FAIL [l] Length: expected [1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: es — Extract Subset [
test_es_Extract_Subset__ <- function() {
  r <- run_ratl("3 5 es")
  if (grepl("Error:", r)) { cat("FAIL [es] Extract Subset [: ", r, "\n"); return(FALSE) }
  if (r != "NA") {
    cat("FAIL [es] Extract Subset [: expected [NA], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: el — Extract Element [[
test_el_Extract_Element___ <- function() {
  r <- run_ratl("3 5 el")
  if (grepl("Error:", r)) { cat("FAIL [el] Extract Element [[: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: subscript out of bounds") {
    cat("FAIL [el] Extract Element [[: expected [ERROR: subscript out of bounds], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: en — Extract Name $
test_en_Extract_Name__ <- function() {
  r <- run_ratl("3 5 en")
  if (grepl("Error:", r)) { cat("FAIL [en] Extract Name $: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: subscript out of bounds") {
    cat("FAIL [en] Extract Name $: expected [ERROR: subscript out of bounds], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: fu — Flatten
test_fu_Flatten <- function() {
  r <- run_ratl("5 fu")
  if (grepl("Error:", r)) { cat("FAIL [fu] Flatten: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [fu] Flatten: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: zp — Zip
test_zp_Zip <- function() {
  r <- run_ratl("3 5 zp")
  if (grepl("Error:", r)) { cat("FAIL [zp] Zip: ", r, "\n"); return(FALSE) }
  if (r != "3 5") {
    cat("FAIL [zp] Zip: expected [3 5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: hd — HeadN
test_hd_HeadN <- function() {
  r <- run_ratl("3 5 hd")
  if (grepl("Error:", r)) { cat("FAIL [hd] HeadN: ", r, "\n"); return(FALSE) }
  if (r != "3") {
    cat("FAIL [hd] HeadN: expected [3], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: tl — TailN
test_tl_TailN <- function() {
  r <- run_ratl("3 5 tl")
  if (grepl("Error:", r)) { cat("FAIL [tl] TailN: ", r, "\n"); return(FALSE) }
  if (r != "3") {
    cat("FAIL [tl] TailN: expected [3], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: la — LastElem
test_la_LastElem <- function() {
  r <- run_ratl("5 la")
  if (grepl("Error:", r)) { cat("FAIL [la] LastElem: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [la] LastElem: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: fE — FirstElem
test_fE_FirstElem <- function() {
  r <- run_ratl("5 fE")
  if (grepl("Error:", r)) { cat("FAIL [fE] FirstElem: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [fE] FirstElem: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: SH — Head
test_SH_Head <- function() {
  r <- run_ratl("5 SH")
  if (grepl("Error:", r)) { cat("FAIL [SH] Head: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [SH] Head: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: ST — Tail
test_ST_Tail <- function() {
  r <- run_ratl("5 ST")
  if (grepl("Error:", r)) { cat("FAIL [ST] Tail: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [ST] Tail: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: SR — Rank
test_SR_Rank <- function() {
  r <- run_ratl("5 SR")
  if (grepl("Error:", r)) { cat("FAIL [SR] Rank: ", r, "\n"); return(FALSE) }
  if (r != "1") {
    cat("FAIL [SR] Rank: expected [1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: r1 — Range1toN
test_r1_Range1toN <- function() {
  r <- run_ratl("5 r1")
  if (grepl("Error:", r)) { cat("FAIL [r1] Range1toN: ", r, "\n"); return(FALSE) }
  if (r != "1 2 3 4 5") {
    cat("FAIL [r1] Range1toN: expected [1 2 3 4 5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: . — Range 1 to N
test___Range_1_to_N <- function() {
  r <- run_ratl("5 .")
  if (grepl("Error:", r)) { cat("FAIL [.] Range 1 to N: ", r, "\n"); return(FALSE) }
  if (r != "1 2 3 4 5") {
    cat("FAIL [.] Range 1 to N: expected [1 2 3 4 5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: vW — SeqLen
test_vW_SeqLen <- function() {
  r <- run_ratl("1 2 3 vW")
  if (grepl("Error:", r)) { cat("FAIL [vW] SeqLen: ", r, "\n"); return(FALSE) }
  if (r != "1 1.5 2") {
    cat("FAIL [vW] SeqLen: expected [1 1.5 2], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: r2 — Rep
test_r2_Rep <- function() {
  r <- run_ratl("3 5 r2")
  if (grepl("Error:", r)) { cat("FAIL [r2] Rep: ", r, "\n"); return(FALSE) }
  if (r != "3 3 3 3 3") {
    cat("FAIL [r2] Rep: expected [3 3 3 3 3], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: vT — RepMat
test_vT_RepMat <- function() {
  r <- run_ratl("1 2 3 vT")
  if (grepl("Error:", r)) { cat("FAIL [vT] RepMat: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: invalid 'nrow' value (too large or NA)") {
    cat("FAIL [vT] RepMat: expected [ERROR: invalid 'nrow' value (too large or NA)], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: vI — CumMin
test_vI_CumMin <- function() {
  r <- run_ratl("5 vI")
  if (grepl("Error:", r)) { cat("FAIL [vI] CumMin: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [vI] CumMin: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: vX — CumMax
test_vX_CumMax <- function() {
  r <- run_ratl("5 vX")
  if (grepl("Error:", r)) { cat("FAIL [vX] CumMax: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [vX] CumMax: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: vF — Diff
test_vF_Diff <- function() {
  r <- run_ratl("5 vF")
  if (grepl("Error:", r)) { cat("FAIL [vF] Diff: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# Array Operations: vG — PMax
test_vG_PMax <- function() {
  r <- run_ratl("3 5 vG")
  if (grepl("Error:", r)) { cat("FAIL [vG] PMax: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [vG] PMax: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: vB — PMin
test_vB_PMin <- function() {
  r <- run_ratl("3 5 vB")
  if (grepl("Error:", r)) { cat("FAIL [vB] PMin: ", r, "\n"); return(FALSE) }
  if (r != "3") {
    cat("FAIL [vB] PMin: expected [3], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: XC — CumSum
test_XC_CumSum <- function() {
  r <- run_ratl("5 XC")
  if (grepl("Error:", r)) { cat("FAIL [XC] CumSum: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [XC] CumSum: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: c1 — CumProd
test_c1_CumProd <- function() {
  r <- run_ratl("5 c1")
  if (grepl("Error:", r)) { cat("FAIL [c1] CumProd: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [c1] CumProd: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: wh — Which
test_wh_Which <- function() {
  r <- run_ratl("5 wh")
  if (grepl("Error:", r)) { cat("FAIL [wh] Which: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: argument to 'which' is not logical") {
    cat("FAIL [wh] Which: expected [ERROR: argument to 'which' is not logical], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: vH — WhichArr
test_vH_WhichArr <- function() {
  r <- run_ratl("5 vH")
  if (grepl("Error:", r)) { cat("FAIL [vH] WhichArr: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: argument to 'which' is not logical") {
    cat("FAIL [vH] WhichArr: expected [ERROR: argument to 'which' is not logical], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: tb — Tabulate
test_tb_Tabulate <- function() {
  r <- run_ratl("5 tb")
  if (grepl("Error:", r)) { cat("FAIL [tb] Tabulate: ", r, "\n"); return(FALSE) }
  if (r != "0 0 0 0 1") {
    cat("FAIL [tb] Tabulate: expected [0 0 0 0 1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: un — UniqueN
test_un_UniqueN <- function() {
  r <- run_ratl("5 un")
  if (grepl("Error:", r)) { cat("FAIL [un] UniqueN: ", r, "\n"); return(FALSE) }
  if (r != "1") {
    cat("FAIL [un] UniqueN: expected [1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: ix — IndexOf
test_ix_IndexOf <- function() {
  r <- run_ratl("3 5 ix")
  if (grepl("Error:", r)) { cat("FAIL [ix] IndexOf: ", r, "\n"); return(FALSE) }
  if (r != "NA") {
    cat("FAIL [ix] IndexOf: expected [NA], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: cn — IsIn
test_cn_IsIn <- function() {
  r <- run_ratl("3 5 cn")
  if (grepl("Error:", r)) { cat("FAIL [cn] IsIn: ", r, "\n"); return(FALSE) }
  if (r != "FALSE") {
    cat("FAIL [cn] IsIn: expected [FALSE], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: ns — NegSlice
test_ns_NegSlice <- function() {
  r <- run_ratl("3 5 ns")
  if (grepl("Error:", r)) { cat("FAIL [ns] NegSlice: ", r, "\n"); return(FALSE) }
  if (r != "3") {
    cat("FAIL [ns] NegSlice: expected [3], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: vD — Drop
test_vD_Drop <- function() {
  r <- run_ratl("5 vD")
  if (grepl("Error:", r)) { cat("FAIL [vD] Drop: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [vD] Drop: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: , — Concat Vectors
test___Concat_Vectors <- function() {
  r <- run_ratl("3 5 ,")
  if (grepl("Error:", r)) { cat("FAIL [,] Concat Vectors: ", r, "\n"); return(FALSE) }
  if (r != "3 5") {
    cat("FAIL [,] Concat Vectors: expected [3 5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: .. — Pair
test____Pair <- function() {
  r <- run_ratl("3 5 ..")
  if (grepl("Error:", r)) { cat("FAIL [..] Pair: ", r, "\n"); return(FALSE) }
  if (r != "3 5") {
    cat("FAIL [..] Pair: expected [3 5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: # — Filter
test___Filter <- function() {
  r <- run_ratl("3 5 #")
  if (grepl("Error:", r)) { cat("FAIL [#] Filter: ", r, "\n"); return(FALSE) }
  if (r != "3 5") {
    cat("FAIL [#] Filter: expected [3 5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: dS — Split
test_dS_Split <- function() {
  r <- run_ratl("3 5 dS")
  if (grepl("Error:", r)) { cat("FAIL [dS] Split: ", r, "\n"); return(FALSE) }
  if (r != "3") {
    cat("FAIL [dS] Split: expected [3], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: dU — Unsplit
test_dU_Unsplit <- function() {
  r <- run_ratl("3 5 dU")
  if (grepl("Error:", r)) { cat("FAIL [dU] Unsplit: ", r, "\n"); return(FALSE) }
  if (r != "3") {
    cat("FAIL [dU] Unsplit: expected [3], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: dO — Order
test_dO_Order <- function() {
  r <- run_ratl("5 dO")
  if (grepl("Error:", r)) { cat("FAIL [dO] Order: ", r, "\n"); return(FALSE) }
  if (r != "1") {
    cat("FAIL [dO] Order: expected [1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Array Operations: Xk — RLE
test_Xk_RLE <- function() {
  r <- run_ratl("5 Xk")
  if (grepl("Error:", r)) { cat("FAIL [Xk] RLE: ", r, "\n"); return(FALSE) }
  if (r != "5 1") {
    cat("FAIL [Xk] RLE: expected [5 1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: ! — Transpose
test___Transpose <- function() {
  r <- run_ratl("5 !")
  if (grepl("Error:", r)) { cat("FAIL [!] Transpose: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [!] Transpose: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: & — Outer Product
test___Outer_Product <- function() {
  r <- run_ratl("3 5 &")
  if (grepl("Error:", r)) { cat("FAIL [&] Outer Product: ", r, "\n"); return(FALSE) }
  if (r != "15") {
    cat("FAIL [&] Outer Product: expected [15], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: ym — Create Matrix
test_ym_Create_Matrix <- function() {
  r <- run_ratl("1 2 3 ym")
  if (grepl("Error:", r)) { cat("FAIL [ym] Create Matrix: ", r, "\n"); return(FALSE) }
  if (r != "1 1 1 1 1 1") {
    cat("FAIL [ym] Create Matrix: expected [1 1 1 1 1 1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: Y* — Matrix Mult
test_Y__Matrix_Mult <- function() {
  r <- run_ratl("3 5 Y*")
  if (grepl("Error:", r)) { cat("FAIL [Y*] Matrix Mult: ", r, "\n"); return(FALSE) }
  if (r != "15") {
    cat("FAIL [Y*] Matrix Mult: expected [15], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: yD — Identity Matrix
test_yD_Identity_Matrix <- function() {
  r <- run_ratl("5 yD")
  if (grepl("Error:", r)) { cat("FAIL [yD] Identity Matrix: ", r, "\n"); return(FALSE) }
  if (r != "1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1") {
    cat("FAIL [yD] Identity Matrix: expected [1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: y! — Diag
test_y__Diag <- function() {
  r <- run_ratl("5 y!")
  if (grepl("Error:", r)) { cat("FAIL [y!] Diag: ", r, "\n"); return(FALSE) }
  if (r != "1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1") {
    cat("FAIL [y!] Diag: expected [1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: yf — Full
test_yf_Full <- function() {
  r <- run_ratl("5 yf")
  if (grepl("Error:", r)) { cat("FAIL [yf] Full: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [yf] Full: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: yt — Trace
test_yt_Trace <- function() {
  r <- run_ratl("5 yt")
  if (grepl("Error:", r)) { cat("FAIL [yt] Trace: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [yt] Trace: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: yu — TriUpper
test_yu_TriUpper <- function() {
  r <- run_ratl("5 yu")
  if (grepl("Error:", r)) { cat("FAIL [yu] TriUpper: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [yu] TriUpper: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: yl — TriLower
test_yl_TriLower <- function() {
  r <- run_ratl("5 yl")
  if (grepl("Error:", r)) { cat("FAIL [yl] TriLower: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [yl] TriLower: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: yk — Kronecker
test_yk_Kronecker <- function() {
  r <- run_ratl("3 5 yk")
  if (grepl("Error:", r)) { cat("FAIL [yk] Kronecker: ", r, "\n"); return(FALSE) }
  if (r != "15") {
    cat("FAIL [yk] Kronecker: expected [15], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: yv — EigenValues
test_yv_EigenValues <- function() {
  r <- run_ratl("5 yv")
  if (grepl("Error:", r)) { cat("FAIL [yv] EigenValues: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [yv] EigenValues: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: yc — EigenVectors
test_yc_EigenVectors <- function() {
  r <- run_ratl("5 yc")
  if (grepl("Error:", r)) { cat("FAIL [yc] EigenVectors: ", r, "\n"); return(FALSE) }
  if (r != "1") {
    cat("FAIL [yc] EigenVectors: expected [1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: yd — Determinant
test_yd_Determinant <- function() {
  r <- run_ratl("5 yd")
  if (grepl("Error:", r)) { cat("FAIL [yd] Determinant: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# Matrix: R9 — Rot90
test_R9_Rot90 <- function() {
  r <- run_ratl("5 R9")
  if (grepl("Error:", r)) { cat("FAIL [R9] Rot90: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [R9] Rot90: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: vL — Solve
test_vL_Solve <- function() {
  r <- run_ratl("5 vL")
  if (grepl("Error:", r)) { cat("FAIL [vL] Solve: ", r, "\n"); return(FALSE) }
  if (r != "0.2") {
    cat("FAIL [vL] Solve: expected [0.2], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: v2 — Solve 2
test_v2_Solve_2 <- function() {
  r <- run_ratl("3 5 v2")
  if (grepl("Error:", r)) { cat("FAIL [v2] Solve 2: ", r, "\n"); return(FALSE) }
  if (r != "1.66666666666667") {
    cat("FAIL [v2] Solve 2: expected [1.66666666666667], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: vQ — QR Decomp
test_vQ_QR_Decomp <- function() {
  r <- run_ratl("5 vQ")
  if (grepl("Error:", r)) { cat("FAIL [vQ] QR Decomp: ", r, "\n"); return(FALSE) }
  if (r != "5 1 5 1") {
    cat("FAIL [vQ] QR Decomp: expected [5 1 5 1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: vV — SVD
test_vV_SVD <- function() {
  r <- run_ratl("5 vV")
  if (grepl("Error:", r)) { cat("FAIL [vV] SVD: ", r, "\n"); return(FALSE) }
  if (r != "5 1 1") {
    cat("FAIL [vV] SVD: expected [5 1 1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: YM — Matrix ByRow
test_YM_Matrix_ByRow <- function() {
  r <- run_ratl("1 2 3 YM")
  if (grepl("Error:", r)) { cat("FAIL [YM] Matrix ByRow: ", r, "\n"); return(FALSE) }
  if (r != "1 1 1 1 1 1") {
    cat("FAIL [YM] Matrix ByRow: expected [1 1 1 1 1 1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: Y! — Create Matrix
test_Y__Create_Matrix <- function() {
  r <- run_ratl("1 2 3 Y!")
  if (grepl("Error:", r)) { cat("FAIL [Y!] Create Matrix: ", r, "\n"); return(FALSE) }
  if (r != "1 1 1 1 1 1") {
    cat("FAIL [Y!] Create Matrix: expected [1 1 1 1 1 1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: BT — Bingo Twin
test_BT_Bingo_Twin <- function() {
  r <- run_ratl("5 BT")
  if (grepl("Error:", r)) { cat("FAIL [BT] Bingo Twin: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: incorrect number of dimensions") {
    cat("FAIL [BT] Bingo Twin: expected [ERROR: incorrect number of dimensions], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: vC — Col Indices
test_vC_Col_Indices <- function() {
  r <- run_ratl("5 vC")
  if (grepl("Error:", r)) { cat("FAIL [vC] Col Indices: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: a matrix-like object is required as argument to 'col'") {
    cat("FAIL [vC] Col Indices: expected [ERROR: a matrix-like object is required as argument to 'col'], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: vR — Row Indices
test_vR_Row_Indices <- function() {
  r <- run_ratl("5 vR")
  if (grepl("Error:", r)) { cat("FAIL [vR] Row Indices: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: a matrix-like object is required as argument to 'row'") {
    cat("FAIL [vR] Row Indices: expected [ERROR: a matrix-like object is required as argument to 'row'], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: vS — Col Sums
test_vS_Col_Sums <- function() {
  r <- run_ratl("5 vS")
  if (grepl("Error:", r)) { cat("FAIL [vS] Col Sums: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: 'x' must be an array of at least two dimensions") {
    cat("FAIL [vS] Col Sums: expected [ERROR: 'x' must be an array of at least two dimensions], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: vE — Row Sums
test_vE_Row_Sums <- function() {
  r <- run_ratl("5 vE")
  if (grepl("Error:", r)) { cat("FAIL [vE] Row Sums: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: 'x' must be an array of at least two dimensions") {
    cat("FAIL [vE] Row Sums: expected [ERROR: 'x' must be an array of at least two dimensions], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: vM — Col Means
test_vM_Col_Means <- function() {
  r <- run_ratl("5 vM")
  if (grepl("Error:", r)) { cat("FAIL [vM] Col Means: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: 'x' must be an array of at least two dimensions") {
    cat("FAIL [vM] Col Means: expected [ERROR: 'x' must be an array of at least two dimensions], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Matrix: vN — Row Means
test_vN_Row_Means <- function() {
  r <- run_ratl("5 vN")
  if (grepl("Error:", r)) { cat("FAIL [vN] Row Means: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: 'x' must be an array of at least two dimensions") {
    cat("FAIL [vN] Row Means: expected [ERROR: 'x' must be an array of at least two dimensions], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: s — Sum
test_s_Sum <- function() {
  r <- run_ratl("5 s")
  if (grepl("Error:", r)) { cat("FAIL [s] Sum: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [s] Sum: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: m — Mean
test_m_Mean <- function() {
  r <- run_ratl("5 m")
  if (grepl("Error:", r)) { cat("FAIL [m] Mean: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [m] Mean: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: P — Product
test_P_Product <- function() {
  r <- run_ratl("5 P")
  if (grepl("Error:", r)) { cat("FAIL [P] Product: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [P] Product: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: h — Median
test_h_Median <- function() {
  r <- run_ratl("5 h")
  if (grepl("Error:", r)) { cat("FAIL [h] Median: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [h] Median: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: Q — Quantile
test_Q_Quantile <- function() {
  r <- run_ratl("5 Q")
  if (grepl("Error:", r)) { cat("FAIL [Q] Quantile: ", r, "\n"); return(FALSE) }
  if (r != "5 5 5 5 5") {
    cat("FAIL [Q] Quantile: expected [5 5 5 5 5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: v — Variance
test_v_Variance <- function() {
  r <- run_ratl("5 v")
  if (grepl("Error:", r)) { cat("FAIL [v] Variance: ", r, "\n"); return(FALSE) }
  if (r != "NA") {
    cat("FAIL [v] Variance: expected [NA], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: V — Variance
test_V_Variance <- function() {
  r <- run_ratl("5 V")
  if (grepl("Error:", r)) { cat("FAIL [V] Variance: ", r, "\n"); return(FALSE) }
  if (r != "NA") {
    cat("FAIL [V] Variance: expected [NA], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: sd — Standard Deviation
test_sd_Standard_Deviation <- function() {
  r <- run_ratl("5 sd")
  if (grepl("Error:", r)) { cat("FAIL [sd] Standard Deviation: ", r, "\n"); return(FALSE) }
  if (r != "NA") {
    cat("FAIL [sd] Standard Deviation: expected [NA], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: sm — Summary
test_sm_Summary <- function() {
  r <- run_ratl("5 sm")
  if (grepl("Error:", r)) { cat("FAIL [sm] Summary: ", r, "\n"); return(FALSE) }
  if (r != "5 5 5 5 5 5") {
    cat("FAIL [sm] Summary: expected [5 5 5 5 5 5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: sc — Scale
test_sc_Scale <- function() {
  r <- run_ratl("5 sc")
  if (grepl("Error:", r)) { cat("FAIL [sc] Scale: ", r, "\n"); return(FALSE) }
  if (r != "NaN") {
    cat("FAIL [sc] Scale: expected [NaN], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: r — Random (n)
test_r_Random__n_ <- function() {
  set.seed(42)
  r <- run_ratl("5 r")
  if (grepl("Error:", r)) { cat("FAIL [r] Random (n): ", r, "\n"); return(FALSE) }
  if (r != "0.914806043496355 0.937075413297862 0.286139534786344 0.830447626067325 0.641745518893003") {
    cat("FAIL [r] Random (n): expected [0.914806043496355 0.937075413297862 0.286139534786344 0.830447626067325 0.641745518893003], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: vA — All
test_vA_All <- function() {
  r <- run_ratl("5 vA")
  if (grepl("Error:", r)) { cat("FAIL [vA] All: ", r, "\n"); return(FALSE) }
  if (r != "TRUE") {
    cat("FAIL [vA] All: expected [TRUE], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: lA — Any
test_lA_Any <- function() {
  r <- run_ratl("5 lA")
  if (grepl("Error:", r)) { cat("FAIL [lA] Any: ", r, "\n"); return(FALSE) }
  if (r != "TRUE") {
    cat("FAIL [lA] Any: expected [TRUE], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: lZ — NNZ
test_lZ_NNZ <- function() {
  r <- run_ratl("5 lZ")
  if (grepl("Error:", r)) { cat("FAIL [lZ] NNZ: ", r, "\n"); return(FALSE) }
  if (r != "1") {
    cat("FAIL [lZ] NNZ: expected [1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: Xo — Mode
test_Xo_Mode <- function() {
  r <- run_ratl("5 Xo")
  if (grepl("Error:", r)) { cat("FAIL [Xo] Mode: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [Xo] Mode: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: Xr — RMS
test_Xr_RMS <- function() {
  r <- run_ratl("5 Xr")
  if (grepl("Error:", r)) { cat("FAIL [Xr] RMS: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [Xr] RMS: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: Xs — Std Dev
test_Xs_Std_Dev <- function() {
  r <- run_ratl("5 Xs")
  if (grepl("Error:", r)) { cat("FAIL [Xs] Std Dev: ", r, "\n"); return(FALSE) }
  if (r != "NA") {
    cat("FAIL [Xs] Std Dev: expected [NA], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: rm — RMS
test_rm_RMS <- function() {
  r <- run_ratl("5 rm")
  if (grepl("Error:", r)) { cat("FAIL [rm] RMS: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [rm] RMS: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: Bs — Standard Deviation
test_Bs_Standard_Deviation <- function() {
  r <- run_ratl("5 Bs")
  if (grepl("Error:", r)) { cat("FAIL [Bs] Standard Deviation: ", r, "\n"); return(FALSE) }
  if (r != "NA") {
    cat("FAIL [Bs] Standard Deviation: expected [NA], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: Ba — MAD
test_Ba_MAD <- function() {
  r <- run_ratl("5 Ba")
  if (grepl("Error:", r)) { cat("FAIL [Ba] MAD: ", r, "\n"); return(FALSE) }
  if (r != "0") {
    cat("FAIL [Ba] MAD: expected [0], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: Bn — Min
test_Bn_Min <- function() {
  r <- run_ratl("5 Bn")
  if (grepl("Error:", r)) { cat("FAIL [Bn] Min: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [Bn] Min: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: Bx — Max
test_Bx_Max <- function() {
  r <- run_ratl("5 Bx")
  if (grepl("Error:", r)) { cat("FAIL [Bx] Max: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [Bx] Max: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: Br — Range
test_Br_Range <- function() {
  r <- run_ratl("5 Br")
  if (grepl("Error:", r)) { cat("FAIL [Br] Range: ", r, "\n"); return(FALSE) }
  if (r != "5 5") {
    cat("FAIL [Br] Range: expected [5 5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: Bi — IQR
test_Bi_IQR <- function() {
  r <- run_ratl("5 Bi")
  if (grepl("Error:", r)) { cat("FAIL [Bi] IQR: ", r, "\n"); return(FALSE) }
  if (r != "0") {
    cat("FAIL [Bi] IQR: expected [0], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: BS — Summary
test_BS_Summary <- function() {
  r <- run_ratl("5 BS")
  if (grepl("Error:", r)) { cat("FAIL [BS] Summary: ", r, "\n"); return(FALSE) }
  if (r != "5 5 5 5 5 5") {
    cat("FAIL [BS] Summary: expected [5 5 5 5 5 5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: B5 — FiveNum
test_B5_FiveNum <- function() {
  r <- run_ratl("5 B5")
  if (grepl("Error:", r)) { cat("FAIL [B5] FiveNum: ", r, "\n"); return(FALSE) }
  if (r != "5 5 5 5 5") {
    cat("FAIL [B5] FiveNum: expected [5 5 5 5 5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: Bc — Correlation
test_Bc_Correlation <- function() {
  r <- run_ratl("3 5 Bc")
  if (grepl("Error:", r)) { cat("FAIL [Bc] Correlation: ", r, "\n"); return(FALSE) }
  if (r != "NA") {
    cat("FAIL [Bc] Correlation: expected [NA], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: BC — Covariance
test_BC_Covariance <- function() {
  r <- run_ratl("3 5 BC")
  if (grepl("Error:", r)) { cat("FAIL [BC] Covariance: ", r, "\n"); return(FALSE) }
  if (r != "NA") {
    cat("FAIL [BC] Covariance: expected [NA], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: Bz — Scale
test_Bz_Scale <- function() {
  r <- run_ratl("5 Bz")
  if (grepl("Error:", r)) { cat("FAIL [Bz] Scale: ", r, "\n"); return(FALSE) }
  if (r != "NaN") {
    cat("FAIL [Bz] Scale: expected [NaN], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: cr — Correlation
test_cr_Correlation <- function() {
  r <- run_ratl("3 5 cr")
  if (grepl("Error:", r)) { cat("FAIL [cr] Correlation: ", r, "\n"); return(FALSE) }
  if (r != "NA") {
    cat("FAIL [cr] Correlation: expected [NA], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: cv — Covariance
test_cv_Covariance <- function() {
  r <- run_ratl("3 5 cv")
  if (grepl("Error:", r)) { cat("FAIL [cv] Covariance: ", r, "\n"); return(FALSE) }
  if (r != "NA") {
    cat("FAIL [cv] Covariance: expected [NA], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: mn — Min2
test_mn_Min2 <- function() {
  r <- run_ratl("3 5 mn")
  if (grepl("Error:", r)) { cat("FAIL [mn] Min2: ", r, "\n"); return(FALSE) }
  if (r != "3") {
    cat("FAIL [mn] Min2: expected [3], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: mx — Max2
test_mx_Max2 <- function() {
  r <- run_ratl("3 5 mx")
  if (grepl("Error:", r)) { cat("FAIL [mx] Max2: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [mx] Max2: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: Sk — Skewness
test_Sk_Skewness <- function() {
  r <- run_ratl("5 Sk")
  if (grepl("Error:", r)) { cat("FAIL [Sk] Skewness: ", r, "\n"); return(FALSE) }
  if (r != "NA") {
    cat("FAIL [Sk] Skewness: expected [NA], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: Ku — Kurtosis
test_Ku_Kurtosis <- function() {
  r <- run_ratl("5 Ku")
  if (grepl("Error:", r)) { cat("FAIL [Ku] Kurtosis: ", r, "\n"); return(FALSE) }
  if (r != "NA") {
    cat("FAIL [Ku] Kurtosis: expected [NA], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: Sw — WeightedMean
test_Sw_WeightedMean <- function() {
  r <- run_ratl("3 5 Sw")
  if (grepl("Error:", r)) { cat("FAIL [Sw] WeightedMean: ", r, "\n"); return(FALSE) }
  if (r != "3") {
    cat("FAIL [Sw] WeightedMean: expected [3], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: Sm — MeanNA
test_Sm_MeanNA <- function() {
  r <- run_ratl("5 Sm")
  if (grepl("Error:", r)) { cat("FAIL [Sm] MeanNA: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [Sm] MeanNA: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: Sn — SumNA
test_Sn_SumNA <- function() {
  r <- run_ratl("5 Sn")
  if (grepl("Error:", r)) { cat("FAIL [Sn] SumNA: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [Sn] SumNA: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: Sd — CumSD
test_Sd_CumSD <- function() {
  r <- run_ratl("5 Sd")
  if (grepl("Error:", r)) { cat("FAIL [Sd] CumSD: ", r, "\n"); return(FALSE) }
  if (r != "NA") {
    cat("FAIL [Sd] CumSD: expected [NA], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: mQ — Quantile
test_mQ_Quantile <- function() {
  r <- run_ratl("3 5 mQ")
  if (grepl("Error:", r)) { cat("FAIL [mQ] Quantile: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: 'probs' outside [0,1]") {
    cat("FAIL [mQ] Quantile: expected [ERROR: 'probs' outside [0,1]], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: vd — Density
test_vd_Density <- function() {
  r <- run_ratl("5 vd")
  if (grepl("Error:", r)) { cat("FAIL [vd] Density: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: need at least 2 points to select a bandwidth automatically") {
    cat("FAIL [vd] Density: expected [ERROR: need at least 2 points to select a bandwidth automatically], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: dT — Table
test_dT_Table <- function() {
  r <- run_ratl("5 dT")
  if (grepl("Error:", r)) { cat("FAIL [dT] Table: ", r, "\n"); return(FALSE) }
  if (r != "1") {
    cat("FAIL [dT] Table: expected [1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistics: dX — XTabs
test_dX_XTabs <- function() {
  r <- run_ratl("3 5 dX")
  if (grepl("Error:", r)) { cat("FAIL [dX] XTabs: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: invalid formula") {
    cat("FAIL [dX] XTabs: expected [ERROR: invalid formula], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: lm — Linear Model
test_lm_Linear_Model <- function() {
  r <- run_ratl("5 lm")
  if (grepl("Error:", r)) { cat("FAIL [lm] Linear Model: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: invalid formula") {
    cat("FAIL [lm] Linear Model: expected [ERROR: invalid formula], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: kl — Linear Model
test_kl_Linear_Model <- function() {
  r <- run_ratl("5 kl")
  if (grepl("Error:", r)) { cat("FAIL [kl] Linear Model: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: invalid formula") {
    cat("FAIL [kl] Linear Model: expected [ERROR: invalid formula], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: mL — LM Simple
test_mL_LM_Simple <- function() {
  r <- run_ratl("3 5 mL")
  if (grepl("Error:", r)) { cat("FAIL [mL] LM Simple: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# Statistical Modeling: kg — GLM
test_kg_GLM <- function() {
  r <- run_ratl("5 kg")
  if (grepl("Error:", r)) { cat("FAIL [kg] GLM: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: invalid formula") {
    cat("FAIL [kg] GLM: expected [ERROR: invalid formula], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: av — Anova
test_av_Anova <- function() {
  r <- run_ratl("5 av")
  if (grepl("Error:", r)) { cat("FAIL [av] Anova: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: no applicable method for 'anova' applied to an object of class \"c('double', 'numeric')\"") {
    cat("FAIL [av] Anova: expected [ERROR: no applicable method for 'anova' applied to an object of class \"c('double', 'numeric')\"], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: ka — Anova
test_ka_Anova <- function() {
  r <- run_ratl("5 ka")
  if (grepl("Error:", r)) { cat("FAIL [ka] Anova: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: no applicable method for 'anova' applied to an object of class \"c('double', 'numeric')\"") {
    cat("FAIL [ka] Anova: expected [ERROR: no applicable method for 'anova' applied to an object of class \"c('double', 'numeric')\"], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: KA — AOV
test_KA_AOV <- function() {
  r <- run_ratl("5 KA")
  if (grepl("Error:", r)) { cat("FAIL [KA] AOV: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: $ operator is invalid for atomic vectors") {
    cat("FAIL [KA] AOV: expected [ERROR: $ operator is invalid for atomic vectors], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: ko — Loess
test_ko_Loess <- function() {
  r <- run_ratl("5 ko")
  if (grepl("Error:", r)) { cat("FAIL [ko] Loess: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: invalid formula") {
    cat("FAIL [ko] Loess: expected [ERROR: invalid formula], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: kn — NLS
test_kn_NLS <- function() {
  r <- run_ratl("5 kn")
  if (grepl("Error:", r)) { cat("FAIL [kn] NLS: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: invalid formula") {
    cat("FAIL [kn] NLS: expected [ERROR: invalid formula], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: ke — Predict
test_ke_Predict <- function() {
  r <- run_ratl("3 5 ke")
  if (grepl("Error:", r)) { cat("FAIL [ke] Predict: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: no applicable method for 'predict' applied to an object of class \"c('double', 'numeric')\"") {
    cat("FAIL [ke] Predict: expected [ERROR: no applicable method for 'predict' applied to an object of class \"c('double', 'numeric')\"], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: mP — Predict
test_mP_Predict <- function() {
  r <- run_ratl("5 mP")
  if (grepl("Error:", r)) { cat("FAIL [mP] Predict: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: no applicable method for 'predict' applied to an object of class \"c('double', 'numeric')\"") {
    cat("FAIL [mP] Predict: expected [ERROR: no applicable method for 'predict' applied to an object of class \"c('double', 'numeric')\"], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: KE — Residuals
test_KE_Residuals <- function() {
  r <- run_ratl("5 KE")
  if (grepl("Error:", r)) { cat("FAIL [KE] Residuals: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: $ operator is invalid for atomic vectors") {
    cat("FAIL [KE] Residuals: expected [ERROR: $ operator is invalid for atomic vectors], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: K! — Coef
test_K__Coef <- function() {
  r <- run_ratl("5 K!")
  if (grepl("Error:", r)) { cat("FAIL [K!] Coef: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: $ operator is invalid for atomic vectors") {
    cat("FAIL [K!] Coef: expected [ERROR: $ operator is invalid for atomic vectors], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: KF — Fitted
test_KF_Fitted <- function() {
  r <- run_ratl("5 KF")
  if (grepl("Error:", r)) { cat("FAIL [KF] Fitted: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: $ operator is invalid for atomic vectors") {
    cat("FAIL [KF] Fitted: expected [ERROR: $ operator is invalid for atomic vectors], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: ki — AIC
test_ki_AIC <- function() {
  r <- run_ratl("5 ki")
  if (grepl("Error:", r)) { cat("FAIL [ki] AIC: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: no applicable method for 'logLik' applied to an object of class \"c('double', 'numeric')\"") {
    cat("FAIL [ki] AIC: expected [ERROR: no applicable method for 'logLik' applied to an object of class \"c('double', 'numeric')\"], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: KB — BIC
test_KB_BIC <- function() {
  r <- run_ratl("5 KB")
  if (grepl("Error:", r)) { cat("FAIL [KB] BIC: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: no applicable method for 'logLik' applied to an object of class \"c('double', 'numeric')\"") {
    cat("FAIL [KB] BIC: expected [ERROR: no applicable method for 'logLik' applied to an object of class \"c('double', 'numeric')\"], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: KL — LogLik
test_KL_LogLik <- function() {
  r <- run_ratl("5 KL")
  if (grepl("Error:", r)) { cat("FAIL [KL] LogLik: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: no applicable method for 'logLik' applied to an object of class \"c('double', 'numeric')\"") {
    cat("FAIL [KL] LogLik: expected [ERROR: no applicable method for 'logLik' applied to an object of class \"c('double', 'numeric')\"], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: KV — VCov
test_KV_VCov <- function() {
  r <- run_ratl("5 KV")
  if (grepl("Error:", r)) { cat("FAIL [KV] VCov: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: no applicable method for 'vcov' applied to an object of class \"c('double', 'numeric')\"") {
    cat("FAIL [KV] VCov: expected [ERROR: no applicable method for 'vcov' applied to an object of class \"c('double', 'numeric')\"], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: vp — PCA
test_vp_PCA <- function() {
  r <- run_ratl("5 vp")
  if (grepl("Error:", r)) { cat("FAIL [vp] PCA: ", r, "\n"); return(FALSE) }
  if (r != "0 1 5 FALSE 0") {
    cat("FAIL [vp] PCA: expected [0 1 5 FALSE 0], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: mC — Conf Int
test_mC_Conf_Int <- function() {
  r <- run_ratl("5 mC")
  if (grepl("Error:", r)) { cat("FAIL [mC] Conf Int: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: $ operator is invalid for atomic vectors") {
    cat("FAIL [mC] Conf Int: expected [ERROR: $ operator is invalid for atomic vectors], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: mU — Update
test_mU_Update <- function() {
  r <- run_ratl("3 5 mU")
  if (grepl("Error:", r)) { cat("FAIL [mU] Update: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: subscript out of bounds") {
    cat("FAIL [mU] Update: expected [ERROR: subscript out of bounds], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: mO — Offset
test_mO_Offset <- function() {
  r <- run_ratl("5 mO")
  if (grepl("Error:", r)) { cat("FAIL [mO] Offset: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [mO] Offset: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: mW — Formula
test_mW_Formula <- function() {
  r <- run_ratl("5 mW")
  if (grepl("Error:", r)) { cat("FAIL [mW] Formula: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: invalid formula") {
    cat("FAIL [mW] Formula: expected [ERROR: invalid formula], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: mT — Terms
test_mT_Terms <- function() {
  r <- run_ratl("5 mT")
  if (grepl("Error:", r)) { cat("FAIL [mT] Terms: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: $ operator is invalid for atomic vectors") {
    cat("FAIL [mT] Terms: expected [ERROR: $ operator is invalid for atomic vectors], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: mR — Model Frame
test_mR_Model_Frame <- function() {
  r <- run_ratl("5 mR")
  if (grepl("Error:", r)) { cat("FAIL [mR] Model Frame: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: invalid formula") {
    cat("FAIL [mR] Model Frame: expected [ERROR: invalid formula], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: mM — Model Matrix
test_mM_Model_Matrix <- function() {
  r <- run_ratl("5 mM")
  if (grepl("Error:", r)) { cat("FAIL [mM] Model Matrix: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: $ operator is invalid for atomic vectors") {
    cat("FAIL [mM] Model Matrix: expected [ERROR: $ operator is invalid for atomic vectors], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: dY — By
test_dY_By <- function() {
  r <- run_ratl("1 2 3 dY")
  if (grepl("Error:", r)) { cat("FAIL [dY] By: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: could not find function \"FUN\"") {
    cat("FAIL [dY] By: expected [ERROR: could not find function \"FUN\"], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: dA — Aggregate
test_dA_Aggregate <- function() {
  r <- run_ratl("1 2 3 dA")
  if (grepl("Error:", r)) { cat("FAIL [dA] Aggregate: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: object 'v1' of mode 'function' was not found") {
    cat("FAIL [dA] Aggregate: expected [ERROR: object 'v1' of mode 'function' was not found], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Statistical Modeling: dE — Cut
test_dE_Cut <- function() {
  r <- run_ratl("3 5 dE")
  if (grepl("Error:", r)) { cat("FAIL [dE] Cut: ", r, "\n"); return(FALSE) }
  if (r != "(2.999,3.001]") {
    cat("FAIL [dE] Cut: expected [(2.999,3.001]], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: tt — T-Test
test_tt_T_Test <- function() {
  r <- run_ratl("3 5 tt")
  if (grepl("Error:", r)) { cat("FAIL [tt] T-Test: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: not enough 'x' observations") {
    cat("FAIL [tt] T-Test: expected [ERROR: not enough 'x' observations], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: kt — T-Test
test_kt_T_Test <- function() {
  r <- run_ratl("3 5 kt")
  if (grepl("Error:", r)) { cat("FAIL [kt] T-Test: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: not enough 'x' observations") {
    cat("FAIL [kt] T-Test: expected [ERROR: not enough 'x' observations], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: kc — Chi-Square Test
test_kc_Chi_Square_Test <- function() {
  r <- run_ratl("5 kc")
  if (grepl("Error:", r)) { cat("FAIL [kc] Chi-Square Test: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: 'x' must at least have 2 elements") {
    cat("FAIL [kc] Chi-Square Test: expected [ERROR: 'x' must at least have 2 elements], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: kw — Wilcoxon Test
test_kw_Wilcoxon_Test <- function() {
  r <- run_ratl("3 5 kw")
  if (grepl("Error:", r)) { cat("FAIL [kw] Wilcoxon Test: ", r, "\n"); return(FALSE) }
  if (r != "c(W = 0) NULL 1 c(`location shift` = 0) two.sided Wilcoxon rank sum exact test v2 and v1") {
    cat("FAIL [kw] Wilcoxon Test: expected [c(W = 0) NULL 1 c(`location shift` = 0) two.sided Wilcoxon rank sum exact test v2 and v1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: kp — Prop Test
test_kp_Prop_Test <- function() {
  r <- run_ratl("3 5 kp")
  if (grepl("Error:", r)) { cat("FAIL [kp] Prop Test: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# Distributions & Tests: KC — Cor Test
test_KC_Cor_Test <- function() {
  r <- run_ratl("3 5 KC")
  if (grepl("Error:", r)) { cat("FAIL [KC] Cor Test: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: not enough finite observations") {
    cat("FAIL [KC] Cor Test: expected [ERROR: not enough finite observations], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: kf — Fisher Test
test_kf_Fisher_Test <- function() {
  r <- run_ratl("5 kf")
  if (grepl("Error:", r)) { cat("FAIL [kf] Fisher Test: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: if 'x' is not a matrix, 'y' must be given") {
    cat("FAIL [kf] Fisher Test: expected [ERROR: if 'x' is not a matrix, 'y' must be given], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: ks — Shapiro-Wilk
test_ks_Shapiro_Wilk <- function() {
  r <- run_ratl("5 ks")
  if (grepl("Error:", r)) { cat("FAIL [ks] Shapiro-Wilk: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: sample size must be between 3 and 5000") {
    cat("FAIL [ks] Shapiro-Wilk: expected [ERROR: sample size must be between 3 and 5000], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: kk — KS Test
test_kk_KS_Test <- function() {
  r <- run_ratl("3 5 kk")
  if (grepl("Error:", r)) { cat("FAIL [kk] KS Test: ", r, "\n"); return(FALSE) }
  if (r != "c(D = 1) 1 two-sided Exact two-sample Kolmogorov-Smirnov test v2 and v1 TRUE") {
    cat("FAIL [kk] KS Test: expected [c(D = 1) 1 two-sided Exact two-sample Kolmogorov-Smirnov test v2 and v1 TRUE], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: kv — F-Test Var
test_kv_F_Test_Var <- function() {
  r <- run_ratl("3 5 kv")
  if (grepl("Error:", r)) { cat("FAIL [kv] F-Test Var: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: not enough 'x' observations") {
    cat("FAIL [kv] F-Test Var: expected [ERROR: not enough 'x' observations], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: KK — Kruskal-Wallis
test_KK_Kruskal_Wallis <- function() {
  r <- run_ratl("5 KK")
  if (grepl("Error:", r)) { cat("FAIL [KK] Kruskal-Wallis: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: argument \"g\" is missing, with no default") {
    cat("FAIL [KK] Kruskal-Wallis: expected [ERROR: argument \"g\" is missing, with no default], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: kb — Bartlett Test
test_kb_Bartlett_Test <- function() {
  r <- run_ratl("5 kb")
  if (grepl("Error:", r)) { cat("FAIL [kb] Bartlett Test: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: argument \"g\" is missing, with no default") {
    cat("FAIL [kb] Bartlett Test: expected [ERROR: argument \"g\" is missing, with no default], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: N — Random Normal
test_N_Random_Normal <- function() {
  set.seed(42)
  r <- run_ratl("5 N")
  if (grepl("Error:", r)) { cat("FAIL [N] Random Normal: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# Distributions & Tests: dn — Density Normal
test_dn_Density_Normal <- function() {
  r <- run_ratl("5 dn")
  if (grepl("Error:", r)) { cat("FAIL [dn] Density Normal: ", r, "\n"); return(FALSE) }
  if (r != "1.4867195147343e-06") {
    cat("FAIL [dn] Density Normal: expected [1.4867195147343e-06], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: pn — Prob Normal
test_pn_Prob_Normal <- function() {
  r <- run_ratl("5 pn")
  if (grepl("Error:", r)) { cat("FAIL [pn] Prob Normal: ", r, "\n"); return(FALSE) }
  if (r != "0.999999713348428") {
    cat("FAIL [pn] Prob Normal: expected [0.999999713348428], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: qn — Quantile Normal
test_qn_Quantile_Normal <- function() {
  r <- run_ratl("5 qn")
  if (grepl("Error:", r)) { cat("FAIL [qn] Quantile Normal: ", r, "\n"); return(FALSE) }
  if (r != "NaN") {
    cat("FAIL [qn] Quantile Normal: expected [NaN], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: rb — Random Binomial
test_rb_Random_Binomial <- function() {
  set.seed(42)
  r <- run_ratl("5 rb")
  if (grepl("Error:", r)) { cat("FAIL [rb] Random Binomial: ", r, "\n"); return(FALSE) }
  if (r != "1 1 0 1 1") {
    cat("FAIL [rb] Random Binomial: expected [1 1 0 1 1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: rp — Random Poisson
test_rp_Random_Poisson <- function() {
  set.seed(42)
  r <- run_ratl("5 rp")
  if (grepl("Error:", r)) { cat("FAIL [rp] Random Poisson: ", r, "\n"); return(FALSE) }
  if (r != "2 3 0 2 1") {
    cat("FAIL [rp] Random Poisson: expected [2 3 0 2 1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: re — Random Exp
test_re_Random_Exp <- function() {
  set.seed(42)
  r <- run_ratl("5 re")
  if (grepl("Error:", r)) { cat("FAIL [re] Random Exp: ", r, "\n"); return(FALSE) }
  if (r != "0.198336811783888 0.660895252134651 0.283491037786007 0.0381918982602656 0.473176629282534") {
    cat("FAIL [re] Random Exp: expected [0.198336811783888 0.660895252134651 0.283491037786007 0.0381918982602656 0.473176629282534], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: db — Density Beta
test_db_Density_Beta <- function() {
  r <- run_ratl("1 2 3 db")
  if (grepl("Error:", r)) { cat("FAIL [db] Density Beta: ", r, "\n"); return(FALSE) }
  if (r != "0") {
    cat("FAIL [db] Density Beta: expected [0], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: pb — Prob Beta
test_pb_Prob_Beta <- function() {
  r <- run_ratl("1 2 3 pb")
  if (grepl("Error:", r)) { cat("FAIL [pb] Prob Beta: ", r, "\n"); return(FALSE) }
  if (r != "1") {
    cat("FAIL [pb] Prob Beta: expected [1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: qb — Quantile Beta
test_qb_Quantile_Beta <- function() {
  r <- run_ratl("1 2 3 qb")
  if (grepl("Error:", r)) { cat("FAIL [qb] Quantile Beta: ", r, "\n"); return(FALSE) }
  if (r != "1") {
    cat("FAIL [qb] Quantile Beta: expected [1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: RB — Random Beta
test_RB_Random_Beta <- function() {
  set.seed(42)
  r <- run_ratl("1 2 3 RB")
  if (grepl("Error:", r)) { cat("FAIL [RB] Random Beta: ", r, "\n"); return(FALSE) }
  if (r != "0.268164592533162") {
    cat("FAIL [RB] Random Beta: expected [0.268164592533162], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: dB — Density Binomial
test_dB_Density_Binomial <- function() {
  r <- run_ratl("1 2 3 dB")
  if (grepl("Error:", r)) { cat("FAIL [dB] Density Binomial: ", r, "\n"); return(FALSE) }
  if (r != "NaN") {
    cat("FAIL [dB] Density Binomial: expected [NaN], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: pB — Prob Binomial
test_pB_Prob_Binomial <- function() {
  r <- run_ratl("1 2 3 pB")
  if (grepl("Error:", r)) { cat("FAIL [pB] Prob Binomial: ", r, "\n"); return(FALSE) }
  if (r != "NaN") {
    cat("FAIL [pB] Prob Binomial: expected [NaN], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: qB — Quantile Binomial
test_qB_Quantile_Binomial <- function() {
  r <- run_ratl("1 2 3 qB")
  if (grepl("Error:", r)) { cat("FAIL [qB] Quantile Binomial: ", r, "\n"); return(FALSE) }
  if (r != "NaN") {
    cat("FAIL [qB] Quantile Binomial: expected [NaN], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: rB — Random Binomial
test_rB_Random_Binomial <- function() {
  set.seed(42)
  r <- run_ratl("1 2 3 rB")
  if (grepl("Error:", r)) { cat("FAIL [rB] Random Binomial: ", r, "\n"); return(FALSE) }
  if (r != "NA") {
    cat("FAIL [rB] Random Binomial: expected [NA], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: dc — Density Cauchy
test_dc_Density_Cauchy <- function() {
  r <- run_ratl("1 2 3 dc")
  if (grepl("Error:", r)) { cat("FAIL [dc] Density Cauchy: ", r, "\n"); return(FALSE) }
  if (r != "0.0954929658551372") {
    cat("FAIL [dc] Density Cauchy: expected [0.0954929658551372], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: pc — Prob Cauchy
test_pc_Prob_Cauchy <- function() {
  r <- run_ratl("1 2 3 pc")
  if (grepl("Error:", r)) { cat("FAIL [pc] Prob Cauchy: ", r, "\n"); return(FALSE) }
  if (r != "0.397583617650433") {
    cat("FAIL [pc] Prob Cauchy: expected [0.397583617650433], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: qc — Quantile Cauchy
test_qc_Quantile_Cauchy <- function() {
  r <- run_ratl("1 2 3 qc")
  if (grepl("Error:", r)) { cat("FAIL [qc] Quantile Cauchy: ", r, "\n"); return(FALSE) }
  if (r != "Inf") {
    cat("FAIL [qc] Quantile Cauchy: expected [Inf], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: rc — Random Cauchy
test_rc_Random_Cauchy <- function() {
  set.seed(42)
  r <- run_ratl("1 2 3 rc")
  if (grepl("Error:", r)) { cat("FAIL [rc] Random Cauchy: ", r, "\n"); return(FALSE) }
  if (r != "1.17732773861949") {
    cat("FAIL [rc] Random Cauchy: expected [1.17732773861949], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: dC — Density Chi-Square
test_dC_Density_Chi_Square <- function() {
  r <- run_ratl("3 5 dC")
  if (grepl("Error:", r)) { cat("FAIL [dC] Density Chi-Square: ", r, "\n"); return(FALSE) }
  if (r != "0.154180329803769") {
    cat("FAIL [dC] Density Chi-Square: expected [0.154180329803769], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: pC — Prob Chi-Square
test_pC_Prob_Chi_Square <- function() {
  r <- run_ratl("3 5 pC")
  if (grepl("Error:", r)) { cat("FAIL [pC] Prob Chi-Square: ", r, "\n"); return(FALSE) }
  if (r != "0.300014164121372") {
    cat("FAIL [pC] Prob Chi-Square: expected [0.300014164121372], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: qC — Quantile Chi-Square
test_qC_Quantile_Chi_Square <- function() {
  r <- run_ratl("3 5 qC")
  if (grepl("Error:", r)) { cat("FAIL [qC] Quantile Chi-Square: ", r, "\n"); return(FALSE) }
  if (r != "NaN") {
    cat("FAIL [qC] Quantile Chi-Square: expected [NaN], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: rC — Random Chi-Square
test_rC_Random_Chi_Square <- function() {
  set.seed(42)
  r <- run_ratl("3 5 rC")
  if (grepl("Error:", r)) { cat("FAIL [rC] Random Chi-Square: ", r, "\n"); return(FALSE) }
  if (r != "8.81741959071096 2.56223438711777 4.1365849604057") {
    cat("FAIL [rC] Random Chi-Square: expected [8.81741959071096 2.56223438711777 4.1365849604057], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: de — Density Exponential
test_de_Density_Exponential <- function() {
  r <- run_ratl("3 5 de")
  if (grepl("Error:", r)) { cat("FAIL [de] Density Exponential: ", r, "\n"); return(FALSE) }
  if (r != "1.52951160250913e-06") {
    cat("FAIL [de] Density Exponential: expected [1.52951160250913e-06], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: pe — Prob Exponential
test_pe_Prob_Exponential <- function() {
  r <- run_ratl("3 5 pe")
  if (grepl("Error:", r)) { cat("FAIL [pe] Prob Exponential: ", r, "\n"); return(FALSE) }
  if (r != "0.99999969409768") {
    cat("FAIL [pe] Prob Exponential: expected [0.99999969409768], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: qe — Quantile Exponential
test_qe_Quantile_Exponential <- function() {
  r <- run_ratl("3 5 qe")
  if (grepl("Error:", r)) { cat("FAIL [qe] Quantile Exponential: ", r, "\n"); return(FALSE) }
  if (r != "NaN") {
    cat("FAIL [qe] Quantile Exponential: expected [NaN], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: RE — Random Exponential
test_RE_Random_Exponential <- function() {
  set.seed(42)
  r <- run_ratl("3 5 RE")
  if (grepl("Error:", r)) { cat("FAIL [RE] Random Exponential: ", r, "\n"); return(FALSE) }
  if (r != "0.0396673623567777 0.13217905042693 0.0566982075572014") {
    cat("FAIL [RE] Random Exponential: expected [0.0396673623567777 0.13217905042693 0.0566982075572014], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: df — Density F
test_df_Density_F <- function() {
  r <- run_ratl("1 2 3 df")
  if (grepl("Error:", r)) { cat("FAIL [df] Density F: ", r, "\n"); return(FALSE) }
  if (r != "0.278854800926934") {
    cat("FAIL [df] Density F: expected [0.278854800926934], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: pf — Prob F
test_pf_Prob_F <- function() {
  r <- run_ratl("1 2 3 pf")
  if (grepl("Error:", r)) { cat("FAIL [pf] Prob F: ", r, "\n"); return(FALSE) }
  if (r != "0.53524199845511") {
    cat("FAIL [pf] Prob F: expected [0.53524199845511], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: qf — Quantile F
test_qf_Quantile_F <- function() {
  r <- run_ratl("1 2 3 qf")
  if (grepl("Error:", r)) { cat("FAIL [qf] Quantile F: ", r, "\n"); return(FALSE) }
  if (r != "Inf") {
    cat("FAIL [qf] Quantile F: expected [Inf], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: rf — Random F
test_rf_Random_F <- function() {
  set.seed(42)
  r <- run_ratl("1 2 3 rf")
  if (grepl("Error:", r)) { cat("FAIL [rf] Random F: ", r, "\n"); return(FALSE) }
  if (r != "5.64818387541617") {
    cat("FAIL [rf] Random F: expected [5.64818387541617], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: dg — Density Gamma
test_dg_Density_Gamma <- function() {
  r <- run_ratl("1 2 3 dg")
  if (grepl("Error:", r)) { cat("FAIL [dg] Density Gamma: ", r, "\n"); return(FALSE) }
  if (r != "0.448083615310776") {
    cat("FAIL [dg] Density Gamma: expected [0.448083615310776], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: pg — Prob Gamma
test_pg_Prob_Gamma <- function() {
  r <- run_ratl("1 2 3 pg")
  if (grepl("Error:", r)) { cat("FAIL [pg] Prob Gamma: ", r, "\n"); return(FALSE) }
  if (r != "0.800851726528544") {
    cat("FAIL [pg] Prob Gamma: expected [0.800851726528544], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: qg — Quantile Gamma
test_qg_Quantile_Gamma <- function() {
  r <- run_ratl("1 2 3 qg")
  if (grepl("Error:", r)) { cat("FAIL [qg] Quantile Gamma: ", r, "\n"); return(FALSE) }
  if (r != "Inf") {
    cat("FAIL [qg] Quantile Gamma: expected [Inf], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: rg — Random Gamma
test_rg_Random_Gamma <- function() {
  r <- run_ratl("1 2 3 rg")
  if (grepl("Error:", r)) { cat("FAIL [rg] Random Gamma: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# Distributions & Tests: dG — Density Geometric
test_dG_Density_Geometric <- function() {
  r <- run_ratl("3 5 dG")
  if (grepl("Error:", r)) { cat("FAIL [dG] Density Geometric: ", r, "\n"); return(FALSE) }
  if (r != "NaN") {
    cat("FAIL [dG] Density Geometric: expected [NaN], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: pG — Prob Geometric
test_pG_Prob_Geometric <- function() {
  r <- run_ratl("3 5 pG")
  if (grepl("Error:", r)) { cat("FAIL [pG] Prob Geometric: ", r, "\n"); return(FALSE) }
  if (r != "NaN") {
    cat("FAIL [pG] Prob Geometric: expected [NaN], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: qG — Quantile Geometric
test_qG_Quantile_Geometric <- function() {
  r <- run_ratl("3 5 qG")
  if (grepl("Error:", r)) { cat("FAIL [qG] Quantile Geometric: ", r, "\n"); return(FALSE) }
  if (r != "NaN") {
    cat("FAIL [qG] Quantile Geometric: expected [NaN], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: rG — Random Geometric
test_rG_Random_Geometric <- function() {
  set.seed(42)
  r <- run_ratl("3 5 rG")
  if (grepl("Error:", r)) { cat("FAIL [rG] Random Geometric: ", r, "\n"); return(FALSE) }
  if (r != "NA NA NA") {
    cat("FAIL [rG] Random Geometric: expected [NA NA NA], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: dh — Density Hypergeometric
test_dh_Density_Hypergeometric <- function() {
  r <- run_ratl("1 2 3 4 dh")
  if (grepl("Error:", r)) { cat("FAIL [dh] Density Hypergeometric: ", r, "\n"); return(FALSE) }
  if (r != "0.4") {
    cat("FAIL [dh] Density Hypergeometric: expected [0.4], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: ph — Prob Hypergeometric
test_ph_Prob_Hypergeometric <- function() {
  r <- run_ratl("1 2 3 4 ph")
  if (grepl("Error:", r)) { cat("FAIL [ph] Prob Hypergeometric: ", r, "\n"); return(FALSE) }
  if (r != "0.4") {
    cat("FAIL [ph] Prob Hypergeometric: expected [0.4], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: qh — Quantile Hypergeometric
test_qh_Quantile_Hypergeometric <- function() {
  r <- run_ratl("1 2 3 4 qh")
  if (grepl("Error:", r)) { cat("FAIL [qh] Quantile Hypergeometric: ", r, "\n"); return(FALSE) }
  if (r != "2") {
    cat("FAIL [qh] Quantile Hypergeometric: expected [2], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: rh — Random Hypergeometric
test_rh_Random_Hypergeometric <- function() {
  set.seed(42)
  r <- run_ratl("1 2 3 4 rh")
  if (grepl("Error:", r)) { cat("FAIL [rh] Random Hypergeometric: ", r, "\n"); return(FALSE) }
  if (r != "1") {
    cat("FAIL [rh] Random Hypergeometric: expected [1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: dl — Density Log-Normal
test_dl_Density_Log_Normal <- function() {
  r <- run_ratl("1 2 3 dl")
  if (grepl("Error:", r)) { cat("FAIL [dl] Density Log-Normal: ", r, "\n"); return(FALSE) }
  if (r != "0.106482668507451") {
    cat("FAIL [dl] Density Log-Normal: expected [0.106482668507451], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: pl — Prob Log-Normal
test_pl_Prob_Log_Normal <- function() {
  r <- run_ratl("1 2 3 pl")
  if (grepl("Error:", r)) { cat("FAIL [pl] Prob Log-Normal: ", r, "\n"); return(FALSE) }
  if (r != "0.252492537546923") {
    cat("FAIL [pl] Prob Log-Normal: expected [0.252492537546923], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: ql — Quantile Log-Normal
test_ql_Quantile_Log_Normal <- function() {
  r <- run_ratl("1 2 3 ql")
  if (grepl("Error:", r)) { cat("FAIL [ql] Quantile Log-Normal: ", r, "\n"); return(FALSE) }
  if (r != "Inf") {
    cat("FAIL [ql] Quantile Log-Normal: expected [Inf], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: rl — Random Log-Normal
test_rl_Random_Log_Normal <- function() {
  set.seed(42)
  r <- run_ratl("1 2 3 rl")
  if (grepl("Error:", r)) { cat("FAIL [rl] Random Log-Normal: ", r, "\n"); return(FALSE) }
  if (r != "451.635456130485") {
    cat("FAIL [rl] Random Log-Normal: expected [451.635456130485], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: dL — Density Logistic
test_dL_Density_Logistic <- function() {
  r <- run_ratl("1 2 3 dL")
  if (grepl("Error:", r)) { cat("FAIL [dL] Density Logistic: ", r, "\n"); return(FALSE) }
  if (r != "0.0810607203349236") {
    cat("FAIL [dL] Density Logistic: expected [0.0810607203349236], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: pL — Prob Logistic
test_pL_Prob_Logistic <- function() {
  r <- run_ratl("1 2 3 pL")
  if (grepl("Error:", r)) { cat("FAIL [pL] Prob Logistic: ", r, "\n"); return(FALSE) }
  if (r != "0.417429793537685") {
    cat("FAIL [pL] Prob Logistic: expected [0.417429793537685], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: qL — Quantile Logistic
test_qL_Quantile_Logistic <- function() {
  r <- run_ratl("1 2 3 qL")
  if (grepl("Error:", r)) { cat("FAIL [qL] Quantile Logistic: ", r, "\n"); return(FALSE) }
  if (r != "Inf") {
    cat("FAIL [qL] Quantile Logistic: expected [Inf], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: rL — Random Logistic
test_rL_Random_Logistic <- function() {
  set.seed(42)
  r <- run_ratl("1 2 3 rL")
  if (grepl("Error:", r)) { cat("FAIL [rL] Random Logistic: ", r, "\n"); return(FALSE) }
  if (r != "9.12134471066384") {
    cat("FAIL [rL] Random Logistic: expected [9.12134471066384], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: dN — Density Neg-Binomial
test_dN_Density_Neg_Binomial <- function() {
  r <- run_ratl("1 2 3 dN")
  if (grepl("Error:", r)) { cat("FAIL [dN] Density Neg-Binomial: ", r, "\n"); return(FALSE) }
  if (r != "NaN") {
    cat("FAIL [dN] Density Neg-Binomial: expected [NaN], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: pN — Prob Neg-Binomial
test_pN_Prob_Neg_Binomial <- function() {
  r <- run_ratl("1 2 3 pN")
  if (grepl("Error:", r)) { cat("FAIL [pN] Prob Neg-Binomial: ", r, "\n"); return(FALSE) }
  if (r != "NaN") {
    cat("FAIL [pN] Prob Neg-Binomial: expected [NaN], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: qN — Quantile Neg-Binomial
test_qN_Quantile_Neg_Binomial <- function() {
  r <- run_ratl("1 2 3 qN")
  if (grepl("Error:", r)) { cat("FAIL [qN] Quantile Neg-Binomial: ", r, "\n"); return(FALSE) }
  if (r != "NaN") {
    cat("FAIL [qN] Quantile Neg-Binomial: expected [NaN], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: rN — Random Neg-Binomial
test_rN_Random_Neg_Binomial <- function() {
  set.seed(42)
  r <- run_ratl("1 2 3 rN")
  if (grepl("Error:", r)) { cat("FAIL [rN] Random Neg-Binomial: ", r, "\n"); return(FALSE) }
  if (r != "NA") {
    cat("FAIL [rN] Random Neg-Binomial: expected [NA], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: DN — Density Normal
test_DN_Density_Normal <- function() {
  r <- run_ratl("1 2 3 DN")
  if (grepl("Error:", r)) { cat("FAIL [DN] Density Normal: ", r, "\n"); return(FALSE) }
  if (r != "0.125794409230998") {
    cat("FAIL [DN] Density Normal: expected [0.125794409230998], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: PN — Prob Normal
test_PN_Prob_Normal <- function() {
  r <- run_ratl("1 2 3 PN")
  if (grepl("Error:", r)) { cat("FAIL [PN] Prob Normal: ", r, "\n"); return(FALSE) }
  if (r != "0.369441340181764") {
    cat("FAIL [PN] Prob Normal: expected [0.369441340181764], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: QN — Quantile Normal
test_QN_Quantile_Normal <- function() {
  r <- run_ratl("1 2 3 QN")
  if (grepl("Error:", r)) { cat("FAIL [QN] Quantile Normal: ", r, "\n"); return(FALSE) }
  if (r != "Inf") {
    cat("FAIL [QN] Quantile Normal: expected [Inf], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: RN — Random Normal
test_RN_Random_Normal <- function() {
  set.seed(42)
  r <- run_ratl("1 2 3 RN")
  if (grepl("Error:", r)) { cat("FAIL [RN] Random Normal: ", r, "\n"); return(FALSE) }
  if (r != "6.11287534144001") {
    cat("FAIL [RN] Random Normal: expected [6.11287534144001], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: dP — Density Poisson
test_dP_Density_Poisson <- function() {
  r <- run_ratl("3 5 dP")
  if (grepl("Error:", r)) { cat("FAIL [dP] Density Poisson: ", r, "\n"); return(FALSE) }
  if (r != "0.140373895814281") {
    cat("FAIL [dP] Density Poisson: expected [0.140373895814281], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: pP — Prob Poisson
test_pP_Prob_Poisson <- function() {
  r <- run_ratl("3 5 pP")
  if (grepl("Error:", r)) { cat("FAIL [pP] Prob Poisson: ", r, "\n"); return(FALSE) }
  if (r != "0.265025915297362") {
    cat("FAIL [pP] Prob Poisson: expected [0.265025915297362], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: qP — Quantile Poisson
test_qP_Quantile_Poisson <- function() {
  r <- run_ratl("3 5 qP")
  if (grepl("Error:", r)) { cat("FAIL [qP] Quantile Poisson: ", r, "\n"); return(FALSE) }
  if (r != "NaN") {
    cat("FAIL [qP] Quantile Poisson: expected [NaN], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: rP — Random Poisson
test_rP_Random_Poisson <- function() {
  set.seed(42)
  r <- run_ratl("3 5 rP")
  if (grepl("Error:", r)) { cat("FAIL [rP] Random Poisson: ", r, "\n"); return(FALSE) }
  if (r != "8 9 4") {
    cat("FAIL [rP] Random Poisson: expected [8 9 4], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: dt — Density Student-t
test_dt_Density_Student_t <- function() {
  r <- run_ratl("3 5 dt")
  if (grepl("Error:", r)) { cat("FAIL [dt] Density Student-t: ", r, "\n"); return(FALSE) }
  if (r != "0.017292578800223") {
    cat("FAIL [dt] Density Student-t: expected [0.017292578800223], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: pt — Prob Student-t
test_pt_Prob_Student_t <- function() {
  r <- run_ratl("3 5 pt")
  if (grepl("Error:", r)) { cat("FAIL [pt] Prob Student-t: ", r, "\n"); return(FALSE) }
  if (r != "0.984950376051269") {
    cat("FAIL [pt] Prob Student-t: expected [0.984950376051269], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: qt — Quantile Student-t
test_qt_Quantile_Student_t <- function() {
  r <- run_ratl("3 5 qt")
  if (grepl("Error:", r)) { cat("FAIL [qt] Quantile Student-t: ", r, "\n"); return(FALSE) }
  if (r != "NaN") {
    cat("FAIL [qt] Quantile Student-t: expected [NaN], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: rt — Random Student-t
test_rt_Random_Student_t <- function() {
  set.seed(42)
  r <- run_ratl("3 5 rt")
  if (grepl("Error:", r)) { cat("FAIL [rt] Random Student-t: ", r, "\n"); return(FALSE) }
  if (r != "1.91513708565468 0.0878422087160105 -0.0773269863272752") {
    cat("FAIL [rt] Random Student-t: expected [1.91513708565468 0.0878422087160105 -0.0773269863272752], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: du — Density Uniform
test_du_Density_Uniform <- function() {
  r <- run_ratl("1 2 3 du")
  if (grepl("Error:", r)) { cat("FAIL [du] Density Uniform: ", r, "\n"); return(FALSE) }
  if (r != "0") {
    cat("FAIL [du] Density Uniform: expected [0], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: pu — Prob Uniform
test_pu_Prob_Uniform <- function() {
  r <- run_ratl("1 2 3 pu")
  if (grepl("Error:", r)) { cat("FAIL [pu] Prob Uniform: ", r, "\n"); return(FALSE) }
  if (r != "0") {
    cat("FAIL [pu] Prob Uniform: expected [0], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: qu — Quantile Uniform
test_qu_Quantile_Uniform <- function() {
  r <- run_ratl("1 2 3 qu")
  if (grepl("Error:", r)) { cat("FAIL [qu] Quantile Uniform: ", r, "\n"); return(FALSE) }
  if (r != "3") {
    cat("FAIL [qu] Quantile Uniform: expected [3], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: RU — Random Uniform
test_RU_Random_Uniform <- function() {
  set.seed(42)
  r <- run_ratl("1 2 3 RU")
  if (grepl("Error:", r)) { cat("FAIL [RU] Random Uniform: ", r, "\n"); return(FALSE) }
  if (r != "2.91480604349636") {
    cat("FAIL [RU] Random Uniform: expected [2.91480604349636], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: dw — Density Weibull
test_dw_Density_Weibull <- function() {
  r <- run_ratl("1 2 3 dw")
  if (grepl("Error:", r)) { cat("FAIL [dw] Density Weibull: ", r, "\n"); return(FALSE) }
  if (r != "0.198853181514304") {
    cat("FAIL [dw] Density Weibull: expected [0.198853181514304], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: pw — Prob Weibull
test_pw_Prob_Weibull <- function() {
  r <- run_ratl("1 2 3 pw")
  if (grepl("Error:", r)) { cat("FAIL [pw] Prob Weibull: ", r, "\n"); return(FALSE) }
  if (r != "0.10516068318563") {
    cat("FAIL [pw] Prob Weibull: expected [0.10516068318563], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: qw — Quantile Weibull
test_qw_Quantile_Weibull <- function() {
  r <- run_ratl("1 2 3 qw")
  if (grepl("Error:", r)) { cat("FAIL [qw] Quantile Weibull: ", r, "\n"); return(FALSE) }
  if (r != "Inf") {
    cat("FAIL [qw] Quantile Weibull: expected [Inf], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Distributions & Tests: rw — Random Weibull
test_rw_Random_Weibull <- function() {
  set.seed(42)
  r <- run_ratl("1 2 3 rw")
  if (grepl("Error:", r)) { cat("FAIL [rw] Random Weibull: ", r, "\n"); return(FALSE) }
  if (r != "0.895203269919986") {
    cat("FAIL [rw] Random Weibull: expected [0.895203269919986], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: ms — Sin
test_ms_Sin <- function() {
  r <- run_ratl("5 ms")
  if (grepl("Error:", r)) { cat("FAIL [ms] Sin: ", r, "\n"); return(FALSE) }
  if (r != "-0.958924274663138") {
    cat("FAIL [ms] Sin: expected [-0.958924274663138], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: mc — Cos
test_mc_Cos <- function() {
  r <- run_ratl("5 mc")
  if (grepl("Error:", r)) { cat("FAIL [mc] Cos: ", r, "\n"); return(FALSE) }
  if (r != "0.283662185463226") {
    cat("FAIL [mc] Cos: expected [0.283662185463226], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: mt — Tan
test_mt_Tan <- function() {
  r <- run_ratl("5 mt")
  if (grepl("Error:", r)) { cat("FAIL [mt] Tan: ", r, "\n"); return(FALSE) }
  if (r != "-3.38051500624659") {
    cat("FAIL [mt] Tan: expected [-3.38051500624659], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: aS — ArcSin
test_aS_ArcSin <- function() {
  r <- run_ratl("5 aS")
  if (grepl("Error:", r)) { cat("FAIL [aS] ArcSin: ", r, "\n"); return(FALSE) }
  if (r != "NaN") {
    cat("FAIL [aS] ArcSin: expected [NaN], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: aC — ArcCos
test_aC_ArcCos <- function() {
  r <- run_ratl("5 aC")
  if (grepl("Error:", r)) { cat("FAIL [aC] ArcCos: ", r, "\n"); return(FALSE) }
  if (r != "NaN") {
    cat("FAIL [aC] ArcCos: expected [NaN], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: aT — ArcTan
test_aT_ArcTan <- function() {
  r <- run_ratl("5 aT")
  if (grepl("Error:", r)) { cat("FAIL [aT] ArcTan: ", r, "\n"); return(FALSE) }
  if (r != "1.37340076694502") {
    cat("FAIL [aT] ArcTan: expected [1.37340076694502], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: a2 — ArcTan2
test_a2_ArcTan2 <- function() {
  r <- run_ratl("3 5 a2")
  if (grepl("Error:", r)) { cat("FAIL [a2] ArcTan2: ", r, "\n"); return(FALSE) }
  if (r != "0.540419500270584") {
    cat("FAIL [a2] ArcTan2: expected [0.540419500270584], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: sh — Sinh
test_sh_Sinh <- function() {
  r <- run_ratl("5 sh")
  if (grepl("Error:", r)) { cat("FAIL [sh] Sinh: ", r, "\n"); return(FALSE) }
  if (r != "74.2032105777888") {
    cat("FAIL [sh] Sinh: expected [74.2032105777888], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: ch — Cosh
test_ch_Cosh <- function() {
  r <- run_ratl("5 ch")
  if (grepl("Error:", r)) { cat("FAIL [ch] Cosh: ", r, "\n"); return(FALSE) }
  if (r != "74.2099485247878") {
    cat("FAIL [ch] Cosh: expected [74.2099485247878], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: th — Tanh
test_th_Tanh <- function() {
  r <- run_ratl("5 th")
  if (grepl("Error:", r)) { cat("FAIL [th] Tanh: ", r, "\n"); return(FALSE) }
  if (r != "0.999909204262595") {
    cat("FAIL [th] Tanh: expected [0.999909204262595], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: as — ArcSinh
test_as_ArcSinh <- function() {
  r <- run_ratl("5 as")
  if (grepl("Error:", r)) { cat("FAIL [as] ArcSinh: ", r, "\n"); return(FALSE) }
  if (r != "2.31243834127275") {
    cat("FAIL [as] ArcSinh: expected [2.31243834127275], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: ac — ArcCosh
test_ac_ArcCosh <- function() {
  r <- run_ratl("5 ac")
  if (grepl("Error:", r)) { cat("FAIL [ac] ArcCosh: ", r, "\n"); return(FALSE) }
  if (r != "2.29243166956118") {
    cat("FAIL [ac] ArcCosh: expected [2.29243166956118], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: at — ArcTanh
test_at_ArcTanh <- function() {
  r <- run_ratl("5 at")
  if (grepl("Error:", r)) { cat("FAIL [at] ArcTanh: ", r, "\n"); return(FALSE) }
  if (r != "NaN") {
    cat("FAIL [at] ArcTanh: expected [NaN], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: ex — Exp
test_ex_Exp <- function() {
  r <- run_ratl("5 ex")
  if (grepl("Error:", r)) { cat("FAIL [ex] Exp: ", r, "\n"); return(FALSE) }
  if (r != "148.413159102577") {
    cat("FAIL [ex] Exp: expected [148.413159102577], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: lg — Log Natural
test_lg_Log_Natural <- function() {
  r <- run_ratl("5 lg")
  if (grepl("Error:", r)) { cat("FAIL [lg] Log Natural: ", r, "\n"); return(FALSE) }
  if (r != "1.6094379124341") {
    cat("FAIL [lg] Log Natural: expected [1.6094379124341], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: l1 — Log 10
test_l1_Log_10 <- function() {
  r <- run_ratl("5 l1")
  if (grepl("Error:", r)) { cat("FAIL [l1] Log 10: ", r, "\n"); return(FALSE) }
  if (r != "0.698970004336019") {
    cat("FAIL [l1] Log 10: expected [0.698970004336019], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: l2 — Log 2
test_l2_Log_2 <- function() {
  r <- run_ratl("5 l2")
  if (grepl("Error:", r)) { cat("FAIL [l2] Log 2: ", r, "\n"); return(FALSE) }
  if (r != "2.32192809488736") {
    cat("FAIL [l2] Log 2: expected [2.32192809488736], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: sq — Sqrt
test_sq_Sqrt <- function() {
  r <- run_ratl("5 sq")
  if (grepl("Error:", r)) { cat("FAIL [sq] Sqrt: ", r, "\n"); return(FALSE) }
  if (r != "2.23606797749979") {
    cat("FAIL [sq] Sqrt: expected [2.23606797749979], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: fl — Floor
test_fl_Floor <- function() {
  r <- run_ratl("5 fl")
  if (grepl("Error:", r)) { cat("FAIL [fl] Floor: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [fl] Floor: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: cl — Ceiling
test_cl_Ceiling <- function() {
  r <- run_ratl("5 cl")
  if (grepl("Error:", r)) { cat("FAIL [cl] Ceiling: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [cl] Ceiling: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: tr — Trunc
test_tr_Trunc <- function() {
  r <- run_ratl("5 tr")
  if (grepl("Error:", r)) { cat("FAIL [tr] Trunc: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [tr] Trunc: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: ro — Round
test_ro_Round <- function() {
  r <- run_ratl("5 ro")
  if (grepl("Error:", r)) { cat("FAIL [ro] Round: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [ro] Round: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: sg — Sign
test_sg_Sign <- function() {
  r <- run_ratl("5 sg")
  if (grepl("Error:", r)) { cat("FAIL [sg] Sign: ", r, "\n"); return(FALSE) }
  if (r != "1") {
    cat("FAIL [sg] Sign: expected [1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: ab — Abs
test_ab_Abs <- function() {
  r <- run_ratl("5 ab")
  if (grepl("Error:", r)) { cat("FAIL [ab] Abs: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [ab] Abs: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: l+ — Log(1+x)
test_l__Log_1_x_ <- function() {
  r <- run_ratl("5 l+")
  if (grepl("Error:", r)) { cat("FAIL [l+] Log(1+x): ", r, "\n"); return(FALSE) }
  if (r != "1.79175946922805") {
    cat("FAIL [l+] Log(1+x): expected [1.79175946922805], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: e- — Exp(x)-1
test_e__Exp_x__1 <- function() {
  r <- run_ratl("5 e-")
  if (grepl("Error:", r)) { cat("FAIL [e-] Exp(x)-1: ", r, "\n"); return(FALSE) }
  if (r != "147.413159102577") {
    cat("FAIL [e-] Exp(x)-1: expected [147.413159102577], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: cp — Cos(pi*x)
test_cp_Cos_pi_x_ <- function() {
  r <- run_ratl("5 cp")
  if (grepl("Error:", r)) { cat("FAIL [cp] Cos(pi*x): ", r, "\n"); return(FALSE) }
  if (r != "-1") {
    cat("FAIL [cp] Cos(pi*x): expected [-1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: SP — Sin(pi*x)
test_SP_Sin_pi_x_ <- function() {
  r <- run_ratl("5 SP")
  if (grepl("Error:", r)) { cat("FAIL [SP] Sin(pi*x): ", r, "\n"); return(FALSE) }
  if (r != "0") {
    cat("FAIL [SP] Sin(pi*x): expected [0], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Math Functions: tp — Tan(pi*x)
test_tp_Tan_pi_x_ <- function() {
  r <- run_ratl("5 tp")
  if (grepl("Error:", r)) { cat("FAIL [tp] Tan(pi*x): ", r, "\n"); return(FALSE) }
  if (r != "0") {
    cat("FAIL [tp] Tan(pi*x): expected [0], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Combinatorics & Special: g — GCD
test_g_GCD <- function() {
  r <- run_ratl("3 5 g")
  if (grepl("Error:", r)) { cat("FAIL [g] GCD: ", r, "\n"); return(FALSE) }
  if (r != "1") {
    cat("FAIL [g] GCD: expected [1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Combinatorics & Special: lc — LCM
test_lc_LCM <- function() {
  r <- run_ratl("3 5 lc")
  if (grepl("Error:", r)) { cat("FAIL [lc] LCM: ", r, "\n"); return(FALSE) }
  if (r != "15") {
    cat("FAIL [lc] LCM: expected [15], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Combinatorics & Special: ml — LCM
test_ml_LCM <- function() {
  r <- run_ratl("3 5 ml")
  if (grepl("Error:", r)) { cat("FAIL [ml] LCM: ", r, "\n"); return(FALSE) }
  if (r != "15") {
    cat("FAIL [ml] LCM: expected [15], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Combinatorics & Special: Xq — Is Prime
test_Xq_Is_Prime <- function() {
  r <- run_ratl("5 Xq")
  if (grepl("Error:", r)) { cat("FAIL [Xq] Is Prime: ", r, "\n"); return(FALSE) }
  if (r != "TRUE") {
    cat("FAIL [Xq] Is Prime: expected [TRUE], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Combinatorics & Special: mp — Is Prime
test_mp_Is_Prime <- function() {
  r <- run_ratl("5 mp")
  if (grepl("Error:", r)) { cat("FAIL [mp] Is Prime: ", r, "\n"); return(FALSE) }
  if (r != "TRUE") {
    cat("FAIL [mp] Is Prime: expected [TRUE], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Combinatorics & Special: fa — Factors
test_fa_Factors <- function() {
  r <- run_ratl("5 fa")
  if (grepl("Error:", r)) { cat("FAIL [fa] Factors: ", r, "\n"); return(FALSE) }
  if (r != "1 5") {
    cat("FAIL [fa] Factors: expected [1 5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Combinatorics & Special: mf — Prime Factors
test_mf_Prime_Factors <- function() {
  r <- run_ratl("5 mf")
  if (grepl("Error:", r)) { cat("FAIL [mf] Prime Factors: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [mf] Prime Factors: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Combinatorics & Special: XP — Prime Factors
test_XP_Prime_Factors <- function() {
  r <- run_ratl("5 XP")
  if (grepl("Error:", r)) { cat("FAIL [XP] Prime Factors: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [XP] Prime Factors: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Combinatorics & Special: fp — Factorial
test_fp_Factorial <- function() {
  r <- run_ratl("5 fp")
  if (grepl("Error:", r)) { cat("FAIL [fp] Factorial: ", r, "\n"); return(FALSE) }
  if (r != "120") {
    cat("FAIL [fp] Factorial: expected [120], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Combinatorics & Special: MC — Choose
test_MC_Choose <- function() {
  r <- run_ratl("3 5 MC")
  if (grepl("Error:", r)) { cat("FAIL [MC] Choose: ", r, "\n"); return(FALSE) }
  if (r != "0") {
    cat("FAIL [MC] Choose: expected [0], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Combinatorics & Special: Xn — Choose (nCr)
test_Xn_Choose__nCr_ <- function() {
  r <- run_ratl("3 5 Xn")
  if (grepl("Error:", r)) { cat("FAIL [Xn] Choose (nCr): ", r, "\n"); return(FALSE) }
  if (r != "0") {
    cat("FAIL [Xn] Choose (nCr): expected [0], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Combinatorics & Special: mG — Gamma
test_mG_Gamma <- function() {
  r <- run_ratl("5 mG")
  if (grepl("Error:", r)) { cat("FAIL [mG] Gamma: ", r, "\n"); return(FALSE) }
  if (r != "24") {
    cat("FAIL [mG] Gamma: expected [24], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Combinatorics & Special: mB — Beta
test_mB_Beta <- function() {
  r <- run_ratl("3 5 mB")
  if (grepl("Error:", r)) { cat("FAIL [mB] Beta: ", r, "\n"); return(FALSE) }
  if (r != "0.00952380952380952") {
    cat("FAIL [mB] Beta: expected [0.00952380952380952], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Combinatorics & Special: lb — Log Beta
test_lb_Log_Beta <- function() {
  r <- run_ratl("3 5 lb")
  if (grepl("Error:", r)) { cat("FAIL [lb] Log Beta: ", r, "\n"); return(FALSE) }
  if (r != "-4.65396035015752") {
    cat("FAIL [lb] Log Beta: expected [-4.65396035015752], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Combinatorics & Special: LG — Log Gamma
test_LG_Log_Gamma <- function() {
  r <- run_ratl("5 LG")
  if (grepl("Error:", r)) { cat("FAIL [LG] Log Gamma: ", r, "\n"); return(FALSE) }
  if (r != "3.17805383034795") {
    cat("FAIL [LG] Log Gamma: expected [3.17805383034795], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Combinatorics & Special: di — Digamma
test_di_Digamma <- function() {
  r <- run_ratl("5 di")
  if (grepl("Error:", r)) { cat("FAIL [di] Digamma: ", r, "\n"); return(FALSE) }
  if (r != "1.5061176684318") {
    cat("FAIL [di] Digamma: expected [1.5061176684318], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Combinatorics & Special: tg — Trigamma
test_tg_Trigamma <- function() {
  r <- run_ratl("5 tg")
  if (grepl("Error:", r)) { cat("FAIL [tg] Trigamma: ", r, "\n"); return(FALSE) }
  if (r != "0.221322955737115") {
    cat("FAIL [tg] Trigamma: expected [0.221322955737115], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Combinatorics & Special: ps — Psigamma
test_ps_Psigamma <- function() {
  r <- run_ratl("3 5 ps")
  if (grepl("Error:", r)) { cat("FAIL [ps] Psigamma: ", r, "\n"); return(FALSE) }
  if (r != "0.206167438133897") {
    cat("FAIL [ps] Psigamma: expected [0.206167438133897], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Complex Numbers: cR — Real Part
test_cR_Real_Part <- function() {
  r <- run_ratl("5 cR")
  if (grepl("Error:", r)) { cat("FAIL [cR] Real Part: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [cR] Real Part: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Complex Numbers: cI — Imag Part
test_cI_Imag_Part <- function() {
  r <- run_ratl("5 cI")
  if (grepl("Error:", r)) { cat("FAIL [cI] Imag Part: ", r, "\n"); return(FALSE) }
  if (r != "0") {
    cat("FAIL [cI] Imag Part: expected [0], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Complex Numbers: cJ — Conjugate
test_cJ_Conjugate <- function() {
  r <- run_ratl("5 cJ")
  if (grepl("Error:", r)) { cat("FAIL [cJ] Conjugate: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [cJ] Conjugate: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Complex Numbers: cA — Arg
test_cA_Arg <- function() {
  r <- run_ratl("5 cA")
  if (grepl("Error:", r)) { cat("FAIL [cA] Arg: ", r, "\n"); return(FALSE) }
  if (r != "0") {
    cat("FAIL [cA] Arg: expected [0], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Complex Numbers: cM — Modulus
test_cM_Modulus <- function() {
  r <- run_ratl("5 cM")
  if (grepl("Error:", r)) { cat("FAIL [cM] Modulus: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [cM] Modulus: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# String Operations: C — Concat
test_C_Concat <- function() {
  r <- run_ratl("3 5 C")
  if (grepl("Error:", r)) { cat("FAIL [C] Concat: ", r, "\n"); return(FALSE) }
  if (r != "35") {
    cat("FAIL [C] Concat: expected [35], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# String Operations: j — Join
test_j_Join <- function() {
  r <- run_ratl("3 5 j")
  if (grepl("Error:", r)) { cat("FAIL [j] Join: ", r, "\n"); return(FALSE) }
  if (r != "3 5") {
    cat("FAIL [j] Join: expected [3 5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# String Operations: J — Join List
test_J_Join_List <- function() {
  r <- run_ratl("3 5 J")
  if (grepl("Error:", r)) { cat("FAIL [J] Join List: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: invalid 'collapse' argument") {
    cat("FAIL [J] Join List: expected [ERROR: invalid 'collapse' argument], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# String Operations: S — Split String
test_S_Split_String <- function() {
  r <- run_ratl("3 5 S")
  if (grepl("Error:", r)) { cat("FAIL [S] Split String: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: non-character argument") {
    cat("FAIL [S] Split String: expected [ERROR: non-character argument], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# String Operations: Xc — Char Translate
test_Xc_Char_Translate <- function() {
  r <- run_ratl("1 2 3 Xc")
  if (grepl("Error:", r)) { cat("FAIL [Xc] Char Translate: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: invalid 'old' argument") {
    cat("FAIL [Xc] Char Translate: expected [ERROR: invalid 'old' argument], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# String Operations: S! — Translate
test_S__Translate <- function() {
  r <- run_ratl("1 2 3 S!")
  if (grepl("Error:", r)) { cat("FAIL [S!] Translate: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: invalid 'old' argument") {
    cat("FAIL [S!] Translate: expected [ERROR: invalid 'old' argument], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# String Operations: SG — GSub
test_SG_GSub <- function() {
  r <- run_ratl("1 2 3 SG")
  if (grepl("Error:", r)) { cat("FAIL [SG] GSub: ", r, "\n"); return(FALSE) }
  if (r != "1") {
    cat("FAIL [SG] GSub: expected [1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# String Operations: Xt — ToLower
test_Xt_ToLower <- function() {
  r <- run_ratl("5 Xt")
  if (grepl("Error:", r)) { cat("FAIL [Xt] ToLower: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [Xt] ToLower: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# String Operations: sU — ToUpper
test_sU_ToUpper <- function() {
  r <- run_ratl("5 sU")
  if (grepl("Error:", r)) { cat("FAIL [sU] ToUpper: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [sU] ToUpper: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# String Operations: sL — ToLower
test_sL_ToLower <- function() {
  r <- run_ratl("5 sL")
  if (grepl("Error:", r)) { cat("FAIL [sL] ToLower: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [sL] ToLower: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# String Operations: sn — NChar
test_sn_NChar <- function() {
  r <- run_ratl("5 sn")
  if (grepl("Error:", r)) { cat("FAIL [sn] NChar: ", r, "\n"); return(FALSE) }
  if (r != "1") {
    cat("FAIL [sn] NChar: expected [1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# String Operations: ss — Substr
test_ss_Substr <- function() {
  r <- run_ratl("1 2 3 ss")
  if (grepl("Error:", r)) { cat("FAIL [ss] Substr: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# String Operations: sr — Sub
test_sr_Sub <- function() {
  r <- run_ratl("1 2 3 sr")
  if (grepl("Error:", r)) { cat("FAIL [sr] Sub: ", r, "\n"); return(FALSE) }
  if (r != "1") {
    cat("FAIL [sr] Sub: expected [1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# String Operations: sf — Sprintf
test_sf_Sprintf <- function() {
  r <- run_ratl("3 5 sf")
  if (grepl("Error:", r)) { cat("FAIL [sf] Sprintf: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: 'fmt' is not a character vector") {
    cat("FAIL [sf] Sprintf: expected [ERROR: 'fmt' is not a character vector], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# String Operations: st — TrimWS
test_st_TrimWS <- function() {
  r <- run_ratl("5 st")
  if (grepl("Error:", r)) { cat("FAIL [st] TrimWS: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [st] TrimWS: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# String Operations: sG — Grep
test_sG_Grep <- function() {
  r <- run_ratl("3 5 sG")
  if (grepl("Error:", r)) { cat("FAIL [sG] Grep: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# String Operations: sB — Grepl
test_sB_Grepl <- function() {
  r <- run_ratl("3 5 sB")
  if (grepl("Error:", r)) { cat("FAIL [sB] Grepl: ", r, "\n"); return(FALSE) }
  if (r != "FALSE") {
    cat("FAIL [sB] Grepl: expected [FALSE], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# String Operations: sR — Regexpr
test_sR_Regexpr <- function() {
  r <- run_ratl("3 5 sR")
  if (grepl("Error:", r)) { cat("FAIL [sR] Regexpr: ", r, "\n"); return(FALSE) }
  if (r != "-1") {
    cat("FAIL [sR] Regexpr: expected [-1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# String Operations: sX — Gregexpr
test_sX_Gregexpr <- function() {
  r <- run_ratl("3 5 sX")
  if (grepl("Error:", r)) { cat("FAIL [sX] Gregexpr: ", r, "\n"); return(FALSE) }
  if (r != "-1") {
    cat("FAIL [sX] Gregexpr: expected [-1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# String Operations: rv — Reverse String
test_rv_Reverse_String <- function() {
  r <- run_ratl("5 rv")
  if (grepl("Error:", r)) { cat("FAIL [rv] Reverse String: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [rv] Reverse String: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Set Operations: sI — Intersect
test_sI_Intersect <- function() {
  r <- run_ratl("3 5 sI")
  if (grepl("Error:", r)) { cat("FAIL [sI] Intersect: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# Set Operations: sN — Union
test_sN_Union <- function() {
  r <- run_ratl("3 5 sN")
  if (grepl("Error:", r)) { cat("FAIL [sN] Union: ", r, "\n"); return(FALSE) }
  if (r != "3 5") {
    cat("FAIL [sN] Union: expected [3 5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Set Operations: sD — SetDiff
test_sD_SetDiff <- function() {
  r <- run_ratl("3 5 sD")
  if (grepl("Error:", r)) { cat("FAIL [sD] SetDiff: ", r, "\n"); return(FALSE) }
  if (r != "3") {
    cat("FAIL [sD] SetDiff: expected [3], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Bitwise Operations: bA — BitAnd
test_bA_BitAnd <- function() {
  r <- run_ratl("3 5 bA")
  if (grepl("Error:", r)) { cat("FAIL [bA] BitAnd: ", r, "\n"); return(FALSE) }
  if (r != "1") {
    cat("FAIL [bA] BitAnd: expected [1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Bitwise Operations: bO — BitOr
test_bO_BitOr <- function() {
  r <- run_ratl("3 5 bO")
  if (grepl("Error:", r)) { cat("FAIL [bO] BitOr: ", r, "\n"); return(FALSE) }
  if (r != "7") {
    cat("FAIL [bO] BitOr: expected [7], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Bitwise Operations: bX — BitXor
test_bX_BitXor <- function() {
  r <- run_ratl("3 5 bX")
  if (grepl("Error:", r)) { cat("FAIL [bX] BitXor: ", r, "\n"); return(FALSE) }
  if (r != "6") {
    cat("FAIL [bX] BitXor: expected [6], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Bitwise Operations: bN — BitNot
test_bN_BitNot <- function() {
  r <- run_ratl("5 bN")
  if (grepl("Error:", r)) { cat("FAIL [bN] BitNot: ", r, "\n"); return(FALSE) }
  if (r != "-6") {
    cat("FAIL [bN] BitNot: expected [-6], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Bitwise Operations: bL — BitShiftL
test_bL_BitShiftL <- function() {
  r <- run_ratl("3 5 bL")
  if (grepl("Error:", r)) { cat("FAIL [bL] BitShiftL: ", r, "\n"); return(FALSE) }
  if (r != "96") {
    cat("FAIL [bL] BitShiftL: expected [96], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Bitwise Operations: bR — BitShiftR
test_bR_BitShiftR <- function() {
  r <- run_ratl("3 5 bR")
  if (grepl("Error:", r)) { cat("FAIL [bR] BitShiftR: ", r, "\n"); return(FALSE) }
  if (r != "0") {
    cat("FAIL [bR] BitShiftR: expected [0], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Type & Introspection: n — To Number
test_n_To_Number <- function() {
  r <- run_ratl("5 n")
  if (grepl("Error:", r)) { cat("FAIL [n] To Number: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [n] To Number: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Type & Introspection: a — To String
test_a_To_String <- function() {
  r <- run_ratl("5 a")
  if (grepl("Error:", r)) { cat("FAIL [a] To String: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [a] To String: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Type & Introspection: A — To ASCII
test_A_To_ASCII <- function() {
  r <- run_ratl("5 A")
  if (grepl("Error:", r)) { cat("FAIL [A] To ASCII: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: argument must be a character vector of length 1") {
    cat("FAIL [A] To ASCII: expected [ERROR: argument must be a character vector of length 1], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Type & Introspection: c — To Char
test_c_To_Char <- function() {
  r <- run_ratl("5 c")
  if (grepl("Error:", r)) { cat("FAIL [c] To Char: ", r, "\n"); return(FALSE) }
  if (r != "") {
    cat("FAIL [c] To Char: expected [], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Type & Introspection: Xb — To Binary
test_Xb_To_Binary <- function() {
  r <- run_ratl("5 Xb")
  if (grepl("Error:", r)) { cat("FAIL [Xb] To Binary: ", r, "\n"); return(FALSE) }
  if (r != "101") {
    cat("FAIL [Xb] To Binary: expected [101], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Type & Introspection: Xd — To Date
test_Xd_To_Date <- function() {
  r <- run_ratl("5 Xd")
  if (grepl("Error:", r)) { cat("FAIL [Xd] To Date: ", r, "\n"); return(FALSE) }
  if (r != "1970-01-06") {
    cat("FAIL [Xd] To Date: expected [1970-01-06], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Type & Introspection: zd — To Date
test_zd_To_Date <- function() {
  r <- run_ratl("5 zd")
  if (grepl("Error:", r)) { cat("FAIL [zd] To Date: ", r, "\n"); return(FALSE) }
  if (r != "1970-01-06") {
    cat("FAIL [zd] To Date: expected [1970-01-06], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Type & Introspection: mF — Factor
test_mF_Factor <- function() {
  r <- run_ratl("5 mF")
  if (grepl("Error:", r)) { cat("FAIL [mF] Factor: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [mF] Factor: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Type & Introspection: AS — As Type
test_AS_As_Type <- function() {
  r <- run_ratl("3 5 AS")
  if (grepl("Error:", r)) { cat("FAIL [AS] As Type: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: no applicable method for `@` applied to an object of class \"numeric\"") {
    cat("FAIL [AS] As Type: expected [ERROR: no applicable method for `@` applied to an object of class \"numeric\"], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Type & Introspection: is — Is Type
test_is_Is_Type <- function() {
  r <- run_ratl("3 5 is")
  if (grepl("Error:", r)) { cat("FAIL [is] Is Type: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: no applicable method for `@` applied to an object of class \"numeric\"") {
    cat("FAIL [is] Is Type: expected [ERROR: no applicable method for `@` applied to an object of class \"numeric\"], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Type & Introspection: ot — Typeof
test_ot_Typeof <- function() {
  r <- run_ratl("5 ot")
  if (grepl("Error:", r)) { cat("FAIL [ot] Typeof: ", r, "\n"); return(FALSE) }
  if (r != "double") {
    cat("FAIL [ot] Typeof: expected [double], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Type & Introspection: oc — Class
test_oc_Class <- function() {
  r <- run_ratl("5 oc")
  if (grepl("Error:", r)) { cat("FAIL [oc] Class: ", r, "\n"); return(FALSE) }
  if (r != "numeric") {
    cat("FAIL [oc] Class: expected [numeric], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Type & Introspection: oa — Attributes
test_oa_Attributes <- function() {
  r <- run_ratl("5 oa")
  if (grepl("Error:", r)) { cat("FAIL [oa] Attributes: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# Type & Introspection: oA — Attr
test_oA_Attr <- function() {
  r <- run_ratl("3 5 oA")
  if (grepl("Error:", r)) { cat("FAIL [oA] Attr: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: 'which' must be of mode character") {
    cat("FAIL [oA] Attr: expected [ERROR: 'which' must be of mode character], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# Type & Introspection: on — Names
test_on_Names <- function() {
  r <- run_ratl("5 on")
  if (grepl("Error:", r)) { cat("FAIL [on] Names: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# Type & Introspection: or — Rownames
test_or_Rownames <- function() {
  r <- run_ratl("5 or")
  if (grepl("Error:", r)) { cat("FAIL [or] Rownames: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# Type & Introspection: oC — Colnames
test_oC_Colnames <- function() {
  r <- run_ratl("5 oC")
  if (grepl("Error:", r)) { cat("FAIL [oC] Colnames: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# Type & Introspection: od — Dim
test_od_Dim <- function() {
  r <- run_ratl("5 od")
  if (grepl("Error:", r)) { cat("FAIL [od] Dim: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# Type & Introspection: ou — Unlist
test_ou_Unlist <- function() {
  r <- run_ratl("5 ou")
  if (grepl("Error:", r)) { cat("FAIL [ou] Unlist: ", r, "\n"); return(FALSE) }
  if (r != "5") {
    cat("FAIL [ou] Unlist: expected [5], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# SKIP F (Read File) — no test_input defined
skipped <- skipped + 1

# SKIP W (Write File) — no test_input defined
skipped <- skipped + 1

# SKIP FW (Write File) — no test_input defined
skipped <- skipped + 1

# SKIP fr (Read Table) — no test_input defined
skipped <- skipped + 1

# SKIP fc (Read CSV) — no test_input defined
skipped <- skipped + 1

# SKIP fw (Write Table) — no test_input defined
skipped <- skipped + 1

# SKIP fC (Write CSV) — no test_input defined
skipped <- skipped + 1

# File I/O: fi — File Info
test_fi_File_Info <- function() {
  r <- run_ratl("5 fi")
  if (grepl("Error:", r)) { cat("FAIL [fi] File Info: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: invalid filename argument") {
    cat("FAIL [fi] File Info: expected [ERROR: invalid filename argument], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# File I/O: fe — File Exists
test_fe_File_Exists <- function() {
  r <- run_ratl("5 fe")
  if (grepl("Error:", r)) { cat("FAIL [fe] File Exists: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: invalid 'file' argument") {
    cat("FAIL [fe] File Exists: expected [ERROR: invalid 'file' argument], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# SKIP fm (File Remove) — no test_input defined
skipped <- skipped + 1

# SKIP fN (File Create) — no test_input defined
skipped <- skipped + 1

# SKIP fd (Dir Create) — no test_input defined
skipped <- skipped + 1

# File I/O: fX — Dir Exists
test_fX_Dir_Exists <- function() {
  r <- run_ratl("5 fX")
  if (grepl("Error:", r)) { cat("FAIL [fX] Dir Exists: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: invalid filename argument") {
    cat("FAIL [fX] Dir Exists: expected [ERROR: invalid filename argument], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# File I/O: FL — List Files
test_FL_List_Files <- function() {
  r <- run_ratl("5 FL")
  if (grepl("Error:", r)) { cat("FAIL [FL] List Files: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: invalid 'path' argument") {
    cat("FAIL [FL] List Files: expected [ERROR: invalid 'path' argument], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# File I/O: fD — List Dirs
test_fD_List_Dirs <- function() {
  r <- run_ratl("5 fD")
  if (grepl("Error:", r)) { cat("FAIL [fD] List Dirs: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: invalid 'directory' argument") {
    cat("FAIL [fD] List Dirs: expected [ERROR: invalid 'directory' argument], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# File I/O: fb — Basename
test_fb_Basename <- function() {
  r <- run_ratl("5 fb")
  if (grepl("Error:", r)) { cat("FAIL [fb] Basename: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: a character vector argument expected") {
    cat("FAIL [fb] Basename: expected [ERROR: a character vector argument expected], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# File I/O: fA — Dirname
test_fA_Dirname <- function() {
  r <- run_ratl("5 fA")
  if (grepl("Error:", r)) { cat("FAIL [fA] Dirname: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: a character vector argument expected") {
    cat("FAIL [fA] Dirname: expected [ERROR: a character vector argument expected], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# File I/O: fP — Abs Path
test_fP_Abs_Path <- function() {
  r <- run_ratl("5 fP")
  if (grepl("Error:", r)) { cat("FAIL [fP] Abs Path: ", r, "\n"); return(FALSE) }
  if (r != "ERROR: invalid 'path' argument") {
    cat("FAIL [fP] Abs Path: expected [ERROR: invalid 'path' argument], got [", r, "]\n")
    return(FALSE)
  }
  return(TRUE)
}

# File I/O: ft — Temp Dir
test_ft_Temp_Dir <- function() {
  set.seed(42)
  r <- run_ratl("ft")
  if (grepl("Error:", r)) { cat("FAIL [ft] Temp Dir: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# File I/O: fT — Temp File
test_fT_Temp_File <- function() {
  set.seed(42)
  r <- run_ratl("fT")
  if (grepl("Error:", r)) { cat("FAIL [fT] Temp File: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# System: T — Time Epoch
test_T_Time_Epoch <- function() {
  set.seed(42)
  r <- run_ratl("T")
  if (grepl("Error:", r)) { cat("FAIL [T] Time Epoch: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# System: sT — Tic
test_sT_Tic <- function() {
  set.seed(42)
  r <- run_ratl("sT")
  if (grepl("Error:", r)) { cat("FAIL [sT] Tic: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# System: sK — Toc
test_sK_Toc <- function() {
  r <- run_ratl("5 sK")
  if (grepl("Error:", r)) { cat("FAIL [sK] Toc: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# System: sP — Sleep
test_sP_Sleep <- function() {
  r <- run_ratl("5 sP")
  if (grepl("Error:", r)) { cat("FAIL [sP] Sleep: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# System: sE — Date
test_sE_Date <- function() {
  set.seed(42)
  r <- run_ratl("sE")
  if (grepl("Error:", r)) { cat("FAIL [sE] Date: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# System: sH — GetWD
test_sH_GetWD <- function() {
  set.seed(42)
  r <- run_ratl("sH")
  if (grepl("Error:", r)) { cat("FAIL [sH] GetWD: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# SKIP sJ (SetWD) — no test_input defined
skipped <- skipped + 1

# System: zt — SysTime
test_zt_SysTime <- function() {
  set.seed(42)
  r <- run_ratl("zt")
  if (grepl("Error:", r)) { cat("FAIL [zt] SysTime: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# System: sV — RVersion
test_sV_RVersion <- function() {
  set.seed(42)
  r <- run_ratl("sV")
  if (grepl("Error:", r)) { cat("FAIL [sV] RVersion: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# SKIP sF (SetPrompt) — no test_input defined
skipped <- skipped + 1

# SKIP sY (SetScipen) — no test_input defined
skipped <- skipped + 1

# System: ZT — Timezone
test_ZT_Timezone <- function() {
  set.seed(42)
  r <- run_ratl("ZT")
  if (grepl("Error:", r)) { cat("FAIL [ZT] Timezone: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# System: zl — Locale
test_zl_Locale <- function() {
  set.seed(42)
  r <- run_ratl("zl")
  if (grepl("Error:", r)) { cat("FAIL [zl] Locale: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# System: zo — Options
test_zo_Options <- function() {
  set.seed(42)
  r <- run_ratl("zo")
  if (grepl("Error:", r)) { cat("FAIL [zo] Options: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# System: zg — GC
test_zg_GC <- function() {
  set.seed(42)
  r <- run_ratl("zg")
  if (grepl("Error:", r)) { cat("FAIL [zg] GC: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# System: zv — Version
test_zv_Version <- function() {
  set.seed(42)
  r <- run_ratl("zv")
  if (grepl("Error:", r)) { cat("FAIL [zv] Version: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# System: ge — Getenv
test_ge_Getenv <- function() {
  r <- run_ratl("5 ge")
  if (grepl("Error:", r)) { cat("FAIL [ge] Getenv: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# SKIP se (Setenv) — no test_input defined
skipped <- skipped + 1

# SKIP um (Umask) — no test_input defined
skipped <- skipped + 1

# System: pi — GetPID
test_pi_GetPID <- function() {
  set.seed(42)
  r <- run_ratl("pi")
  if (grepl("Error:", r)) { cat("FAIL [pi] GetPID: ", r, "\n"); return(FALSE) }
  return(TRUE)
}

# SKIP ev (Eval) — no test_input defined
skipped <- skipped + 1

all_tests <- list(
  list(name = "+ Add", fn = test___Add)
,
  list(name = "- Subtract", fn = test___Subtract)
,
  list(name = "* Multiply", fn = test___Multiply)
,
  list(name = "/ Divide", fn = test___Divide)
,
  list(name = "% Modulo", fn = test___Modulo)
,
  list(name = "^ Power", fn = test___Power)
,
  list(name = "= Equal", fn = test___Equal)
,
  list(name = "< Less", fn = test___Less)
,
  list(name = "> Greater", fn = test___Greater)
,
  list(name = "<= LessEqual", fn = test____LessEqual)
,
  list(name = ">= GreatEqual", fn = test____GreatEqual)
,
  list(name = "~ Not", fn = test___Not)
,
  list(name = "| Or", fn = test___Or)
,
  list(name = "lX Xor", fn = test_lX_Xor)
,
  list(name = "mI IntDiv", fn = test_mI_IntDiv)
,
  list(name = "D Duplicate", fn = test_D_Duplicate)
,
  list(name = "w Swap", fn = test_w_Swap)
,
  list(name = "x Delete", fn = test_x_Delete)
,
  list(name = "U Unpack", fn = test_U_Unpack)
,
  list(name = "Ls Stack Length", fn = test_Ls_Stack_Length)
,
  list(name = "Pi Pi", fn = test_Pi_Pi)
,
  list(name = "Na NA", fn = test_Na_NA)
,
  list(name = "In Inf", fn = test_In_Inf)
,
  list(name = "sZ EmptyNum", fn = test_sZ_EmptyNum)
,
  list(name = "sQ EmptyChar", fn = test_sQ_EmptyChar)
,
  list(name = "s4 EmptyLog", fn = test_s4_EmptyLog)
,
  list(name = "q Map (evaluator)", fn = test_q_Map__evaluator_)
,
  list(name = "e Filter (evaluator)", fn = test_e_Filter__evaluator_)
,
  list(name = "y Reduce (evaluator)", fn = test_y_Reduce__evaluator_)
,
  list(name = "z Repeat (evaluator)", fn = test_z_Repeat__evaluator_)
,
  list(name = "Fq Map (evaluator)", fn = test_Fq_Map__evaluator_)
,
  list(name = "Ft Filter (evaluator)", fn = test_Ft_Filter__evaluator_)
,
  list(name = "Fx Repeat (evaluator)", fn = test_Fx_Repeat__evaluator_)
,
  list(name = "Fr Reduce", fn = test_Fr_Reduce)
,
  list(name = "Fa Apply", fn = test_Fa_Apply)
,
  list(name = "Fl Lapply", fn = test_Fl_Lapply)
,
  list(name = "Fs Sapply", fn = test_Fs_Sapply)
,
  list(name = "Fv Vapply", fn = test_Fv_Vapply)
,
  list(name = "Fm Mapply", fn = test_Fm_Mapply)
,
  list(name = "Ff Filter (Func)", fn = test_Ff_Filter__Func_)
,
  list(name = "Fn Find (Func)", fn = test_Fn_Find__Func_)
,
  list(name = "Fp Position", fn = test_Fp_Position)
,
  list(name = "fn Negate", fn = test_fn_Negate)
,
  list(name = ": Sequence", fn = test___Sequence)
,
  list(name = "O Sort", fn = test_O_Sort)
,
  list(name = "R Reverse", fn = test_R_Reverse)
,
  list(name = "u Unique", fn = test_u_Unique)
,
  list(name = "l Length", fn = test_l_Length)
,
  list(name = "es Extract Subset [", fn = test_es_Extract_Subset__)
,
  list(name = "el Extract Element [[", fn = test_el_Extract_Element___)
,
  list(name = "en Extract Name $", fn = test_en_Extract_Name__)
,
  list(name = "fu Flatten", fn = test_fu_Flatten)
,
  list(name = "zp Zip", fn = test_zp_Zip)
,
  list(name = "hd HeadN", fn = test_hd_HeadN)
,
  list(name = "tl TailN", fn = test_tl_TailN)
,
  list(name = "la LastElem", fn = test_la_LastElem)
,
  list(name = "fE FirstElem", fn = test_fE_FirstElem)
,
  list(name = "SH Head", fn = test_SH_Head)
,
  list(name = "ST Tail", fn = test_ST_Tail)
,
  list(name = "SR Rank", fn = test_SR_Rank)
,
  list(name = "r1 Range1toN", fn = test_r1_Range1toN)
,
  list(name = ". Range 1 to N", fn = test___Range_1_to_N)
,
  list(name = "vW SeqLen", fn = test_vW_SeqLen)
,
  list(name = "r2 Rep", fn = test_r2_Rep)
,
  list(name = "vT RepMat", fn = test_vT_RepMat)
,
  list(name = "vI CumMin", fn = test_vI_CumMin)
,
  list(name = "vX CumMax", fn = test_vX_CumMax)
,
  list(name = "vF Diff", fn = test_vF_Diff)
,
  list(name = "vG PMax", fn = test_vG_PMax)
,
  list(name = "vB PMin", fn = test_vB_PMin)
,
  list(name = "XC CumSum", fn = test_XC_CumSum)
,
  list(name = "c1 CumProd", fn = test_c1_CumProd)
,
  list(name = "wh Which", fn = test_wh_Which)
,
  list(name = "vH WhichArr", fn = test_vH_WhichArr)
,
  list(name = "tb Tabulate", fn = test_tb_Tabulate)
,
  list(name = "un UniqueN", fn = test_un_UniqueN)
,
  list(name = "ix IndexOf", fn = test_ix_IndexOf)
,
  list(name = "cn IsIn", fn = test_cn_IsIn)
,
  list(name = "ns NegSlice", fn = test_ns_NegSlice)
,
  list(name = "vD Drop", fn = test_vD_Drop)
,
  list(name = ", Concat Vectors", fn = test___Concat_Vectors)
,
  list(name = ".. Pair", fn = test____Pair)
,
  list(name = "# Filter", fn = test___Filter)
,
  list(name = "dS Split", fn = test_dS_Split)
,
  list(name = "dU Unsplit", fn = test_dU_Unsplit)
,
  list(name = "dO Order", fn = test_dO_Order)
,
  list(name = "Xk RLE", fn = test_Xk_RLE)
,
  list(name = "! Transpose", fn = test___Transpose)
,
  list(name = "& Outer Product", fn = test___Outer_Product)
,
  list(name = "ym Create Matrix", fn = test_ym_Create_Matrix)
,
  list(name = "Y* Matrix Mult", fn = test_Y__Matrix_Mult)
,
  list(name = "yD Identity Matrix", fn = test_yD_Identity_Matrix)
,
  list(name = "y! Diag", fn = test_y__Diag)
,
  list(name = "yf Full", fn = test_yf_Full)
,
  list(name = "yt Trace", fn = test_yt_Trace)
,
  list(name = "yu TriUpper", fn = test_yu_TriUpper)
,
  list(name = "yl TriLower", fn = test_yl_TriLower)
,
  list(name = "yk Kronecker", fn = test_yk_Kronecker)
,
  list(name = "yv EigenValues", fn = test_yv_EigenValues)
,
  list(name = "yc EigenVectors", fn = test_yc_EigenVectors)
,
  list(name = "yd Determinant", fn = test_yd_Determinant)
,
  list(name = "R9 Rot90", fn = test_R9_Rot90)
,
  list(name = "vL Solve", fn = test_vL_Solve)
,
  list(name = "v2 Solve 2", fn = test_v2_Solve_2)
,
  list(name = "vQ QR Decomp", fn = test_vQ_QR_Decomp)
,
  list(name = "vV SVD", fn = test_vV_SVD)
,
  list(name = "YM Matrix ByRow", fn = test_YM_Matrix_ByRow)
,
  list(name = "Y! Create Matrix", fn = test_Y__Create_Matrix)
,
  list(name = "BT Bingo Twin", fn = test_BT_Bingo_Twin)
,
  list(name = "vC Col Indices", fn = test_vC_Col_Indices)
,
  list(name = "vR Row Indices", fn = test_vR_Row_Indices)
,
  list(name = "vS Col Sums", fn = test_vS_Col_Sums)
,
  list(name = "vE Row Sums", fn = test_vE_Row_Sums)
,
  list(name = "vM Col Means", fn = test_vM_Col_Means)
,
  list(name = "vN Row Means", fn = test_vN_Row_Means)
,
  list(name = "s Sum", fn = test_s_Sum)
,
  list(name = "m Mean", fn = test_m_Mean)
,
  list(name = "P Product", fn = test_P_Product)
,
  list(name = "h Median", fn = test_h_Median)
,
  list(name = "Q Quantile", fn = test_Q_Quantile)
,
  list(name = "v Variance", fn = test_v_Variance)
,
  list(name = "V Variance", fn = test_V_Variance)
,
  list(name = "sd Standard Deviation", fn = test_sd_Standard_Deviation)
,
  list(name = "sm Summary", fn = test_sm_Summary)
,
  list(name = "sc Scale", fn = test_sc_Scale)
,
  list(name = "r Random (n)", fn = test_r_Random__n_)
,
  list(name = "vA All", fn = test_vA_All)
,
  list(name = "lA Any", fn = test_lA_Any)
,
  list(name = "lZ NNZ", fn = test_lZ_NNZ)
,
  list(name = "Xo Mode", fn = test_Xo_Mode)
,
  list(name = "Xr RMS", fn = test_Xr_RMS)
,
  list(name = "Xs Std Dev", fn = test_Xs_Std_Dev)
,
  list(name = "rm RMS", fn = test_rm_RMS)
,
  list(name = "Bs Standard Deviation", fn = test_Bs_Standard_Deviation)
,
  list(name = "Ba MAD", fn = test_Ba_MAD)
,
  list(name = "Bn Min", fn = test_Bn_Min)
,
  list(name = "Bx Max", fn = test_Bx_Max)
,
  list(name = "Br Range", fn = test_Br_Range)
,
  list(name = "Bi IQR", fn = test_Bi_IQR)
,
  list(name = "BS Summary", fn = test_BS_Summary)
,
  list(name = "B5 FiveNum", fn = test_B5_FiveNum)
,
  list(name = "Bc Correlation", fn = test_Bc_Correlation)
,
  list(name = "BC Covariance", fn = test_BC_Covariance)
,
  list(name = "Bz Scale", fn = test_Bz_Scale)
,
  list(name = "cr Correlation", fn = test_cr_Correlation)
,
  list(name = "cv Covariance", fn = test_cv_Covariance)
,
  list(name = "mn Min2", fn = test_mn_Min2)
,
  list(name = "mx Max2", fn = test_mx_Max2)
,
  list(name = "Sk Skewness", fn = test_Sk_Skewness)
,
  list(name = "Ku Kurtosis", fn = test_Ku_Kurtosis)
,
  list(name = "Sw WeightedMean", fn = test_Sw_WeightedMean)
,
  list(name = "Sm MeanNA", fn = test_Sm_MeanNA)
,
  list(name = "Sn SumNA", fn = test_Sn_SumNA)
,
  list(name = "Sd CumSD", fn = test_Sd_CumSD)
,
  list(name = "mQ Quantile", fn = test_mQ_Quantile)
,
  list(name = "vd Density", fn = test_vd_Density)
,
  list(name = "dT Table", fn = test_dT_Table)
,
  list(name = "dX XTabs", fn = test_dX_XTabs)
,
  list(name = "lm Linear Model", fn = test_lm_Linear_Model)
,
  list(name = "kl Linear Model", fn = test_kl_Linear_Model)
,
  list(name = "mL LM Simple", fn = test_mL_LM_Simple)
,
  list(name = "kg GLM", fn = test_kg_GLM)
,
  list(name = "av Anova", fn = test_av_Anova)
,
  list(name = "ka Anova", fn = test_ka_Anova)
,
  list(name = "KA AOV", fn = test_KA_AOV)
,
  list(name = "ko Loess", fn = test_ko_Loess)
,
  list(name = "kn NLS", fn = test_kn_NLS)
,
  list(name = "ke Predict", fn = test_ke_Predict)
,
  list(name = "mP Predict", fn = test_mP_Predict)
,
  list(name = "KE Residuals", fn = test_KE_Residuals)
,
  list(name = "K! Coef", fn = test_K__Coef)
,
  list(name = "KF Fitted", fn = test_KF_Fitted)
,
  list(name = "ki AIC", fn = test_ki_AIC)
,
  list(name = "KB BIC", fn = test_KB_BIC)
,
  list(name = "KL LogLik", fn = test_KL_LogLik)
,
  list(name = "KV VCov", fn = test_KV_VCov)
,
  list(name = "vp PCA", fn = test_vp_PCA)
,
  list(name = "mC Conf Int", fn = test_mC_Conf_Int)
,
  list(name = "mU Update", fn = test_mU_Update)
,
  list(name = "mO Offset", fn = test_mO_Offset)
,
  list(name = "mW Formula", fn = test_mW_Formula)
,
  list(name = "mT Terms", fn = test_mT_Terms)
,
  list(name = "mR Model Frame", fn = test_mR_Model_Frame)
,
  list(name = "mM Model Matrix", fn = test_mM_Model_Matrix)
,
  list(name = "dY By", fn = test_dY_By)
,
  list(name = "dA Aggregate", fn = test_dA_Aggregate)
,
  list(name = "dE Cut", fn = test_dE_Cut)
,
  list(name = "tt T-Test", fn = test_tt_T_Test)
,
  list(name = "kt T-Test", fn = test_kt_T_Test)
,
  list(name = "kc Chi-Square Test", fn = test_kc_Chi_Square_Test)
,
  list(name = "kw Wilcoxon Test", fn = test_kw_Wilcoxon_Test)
,
  list(name = "kp Prop Test", fn = test_kp_Prop_Test)
,
  list(name = "KC Cor Test", fn = test_KC_Cor_Test)
,
  list(name = "kf Fisher Test", fn = test_kf_Fisher_Test)
,
  list(name = "ks Shapiro-Wilk", fn = test_ks_Shapiro_Wilk)
,
  list(name = "kk KS Test", fn = test_kk_KS_Test)
,
  list(name = "kv F-Test Var", fn = test_kv_F_Test_Var)
,
  list(name = "KK Kruskal-Wallis", fn = test_KK_Kruskal_Wallis)
,
  list(name = "kb Bartlett Test", fn = test_kb_Bartlett_Test)
,
  list(name = "N Random Normal", fn = test_N_Random_Normal)
,
  list(name = "dn Density Normal", fn = test_dn_Density_Normal)
,
  list(name = "pn Prob Normal", fn = test_pn_Prob_Normal)
,
  list(name = "qn Quantile Normal", fn = test_qn_Quantile_Normal)
,
  list(name = "rb Random Binomial", fn = test_rb_Random_Binomial)
,
  list(name = "rp Random Poisson", fn = test_rp_Random_Poisson)
,
  list(name = "re Random Exp", fn = test_re_Random_Exp)
,
  list(name = "db Density Beta", fn = test_db_Density_Beta)
,
  list(name = "pb Prob Beta", fn = test_pb_Prob_Beta)
,
  list(name = "qb Quantile Beta", fn = test_qb_Quantile_Beta)
,
  list(name = "RB Random Beta", fn = test_RB_Random_Beta)
,
  list(name = "dB Density Binomial", fn = test_dB_Density_Binomial)
,
  list(name = "pB Prob Binomial", fn = test_pB_Prob_Binomial)
,
  list(name = "qB Quantile Binomial", fn = test_qB_Quantile_Binomial)
,
  list(name = "rB Random Binomial", fn = test_rB_Random_Binomial)
,
  list(name = "dc Density Cauchy", fn = test_dc_Density_Cauchy)
,
  list(name = "pc Prob Cauchy", fn = test_pc_Prob_Cauchy)
,
  list(name = "qc Quantile Cauchy", fn = test_qc_Quantile_Cauchy)
,
  list(name = "rc Random Cauchy", fn = test_rc_Random_Cauchy)
,
  list(name = "dC Density Chi-Square", fn = test_dC_Density_Chi_Square)
,
  list(name = "pC Prob Chi-Square", fn = test_pC_Prob_Chi_Square)
,
  list(name = "qC Quantile Chi-Square", fn = test_qC_Quantile_Chi_Square)
,
  list(name = "rC Random Chi-Square", fn = test_rC_Random_Chi_Square)
,
  list(name = "de Density Exponential", fn = test_de_Density_Exponential)
,
  list(name = "pe Prob Exponential", fn = test_pe_Prob_Exponential)
,
  list(name = "qe Quantile Exponential", fn = test_qe_Quantile_Exponential)
,
  list(name = "RE Random Exponential", fn = test_RE_Random_Exponential)
,
  list(name = "df Density F", fn = test_df_Density_F)
,
  list(name = "pf Prob F", fn = test_pf_Prob_F)
,
  list(name = "qf Quantile F", fn = test_qf_Quantile_F)
,
  list(name = "rf Random F", fn = test_rf_Random_F)
,
  list(name = "dg Density Gamma", fn = test_dg_Density_Gamma)
,
  list(name = "pg Prob Gamma", fn = test_pg_Prob_Gamma)
,
  list(name = "qg Quantile Gamma", fn = test_qg_Quantile_Gamma)
,
  list(name = "rg Random Gamma", fn = test_rg_Random_Gamma)
,
  list(name = "dG Density Geometric", fn = test_dG_Density_Geometric)
,
  list(name = "pG Prob Geometric", fn = test_pG_Prob_Geometric)
,
  list(name = "qG Quantile Geometric", fn = test_qG_Quantile_Geometric)
,
  list(name = "rG Random Geometric", fn = test_rG_Random_Geometric)
,
  list(name = "dh Density Hypergeometric", fn = test_dh_Density_Hypergeometric)
,
  list(name = "ph Prob Hypergeometric", fn = test_ph_Prob_Hypergeometric)
,
  list(name = "qh Quantile Hypergeometric", fn = test_qh_Quantile_Hypergeometric)
,
  list(name = "rh Random Hypergeometric", fn = test_rh_Random_Hypergeometric)
,
  list(name = "dl Density Log-Normal", fn = test_dl_Density_Log_Normal)
,
  list(name = "pl Prob Log-Normal", fn = test_pl_Prob_Log_Normal)
,
  list(name = "ql Quantile Log-Normal", fn = test_ql_Quantile_Log_Normal)
,
  list(name = "rl Random Log-Normal", fn = test_rl_Random_Log_Normal)
,
  list(name = "dL Density Logistic", fn = test_dL_Density_Logistic)
,
  list(name = "pL Prob Logistic", fn = test_pL_Prob_Logistic)
,
  list(name = "qL Quantile Logistic", fn = test_qL_Quantile_Logistic)
,
  list(name = "rL Random Logistic", fn = test_rL_Random_Logistic)
,
  list(name = "dN Density Neg-Binomial", fn = test_dN_Density_Neg_Binomial)
,
  list(name = "pN Prob Neg-Binomial", fn = test_pN_Prob_Neg_Binomial)
,
  list(name = "qN Quantile Neg-Binomial", fn = test_qN_Quantile_Neg_Binomial)
,
  list(name = "rN Random Neg-Binomial", fn = test_rN_Random_Neg_Binomial)
,
  list(name = "DN Density Normal", fn = test_DN_Density_Normal)
,
  list(name = "PN Prob Normal", fn = test_PN_Prob_Normal)
,
  list(name = "QN Quantile Normal", fn = test_QN_Quantile_Normal)
,
  list(name = "RN Random Normal", fn = test_RN_Random_Normal)
,
  list(name = "dP Density Poisson", fn = test_dP_Density_Poisson)
,
  list(name = "pP Prob Poisson", fn = test_pP_Prob_Poisson)
,
  list(name = "qP Quantile Poisson", fn = test_qP_Quantile_Poisson)
,
  list(name = "rP Random Poisson", fn = test_rP_Random_Poisson)
,
  list(name = "dt Density Student-t", fn = test_dt_Density_Student_t)
,
  list(name = "pt Prob Student-t", fn = test_pt_Prob_Student_t)
,
  list(name = "qt Quantile Student-t", fn = test_qt_Quantile_Student_t)
,
  list(name = "rt Random Student-t", fn = test_rt_Random_Student_t)
,
  list(name = "du Density Uniform", fn = test_du_Density_Uniform)
,
  list(name = "pu Prob Uniform", fn = test_pu_Prob_Uniform)
,
  list(name = "qu Quantile Uniform", fn = test_qu_Quantile_Uniform)
,
  list(name = "RU Random Uniform", fn = test_RU_Random_Uniform)
,
  list(name = "dw Density Weibull", fn = test_dw_Density_Weibull)
,
  list(name = "pw Prob Weibull", fn = test_pw_Prob_Weibull)
,
  list(name = "qw Quantile Weibull", fn = test_qw_Quantile_Weibull)
,
  list(name = "rw Random Weibull", fn = test_rw_Random_Weibull)
,
  list(name = "ms Sin", fn = test_ms_Sin)
,
  list(name = "mc Cos", fn = test_mc_Cos)
,
  list(name = "mt Tan", fn = test_mt_Tan)
,
  list(name = "aS ArcSin", fn = test_aS_ArcSin)
,
  list(name = "aC ArcCos", fn = test_aC_ArcCos)
,
  list(name = "aT ArcTan", fn = test_aT_ArcTan)
,
  list(name = "a2 ArcTan2", fn = test_a2_ArcTan2)
,
  list(name = "sh Sinh", fn = test_sh_Sinh)
,
  list(name = "ch Cosh", fn = test_ch_Cosh)
,
  list(name = "th Tanh", fn = test_th_Tanh)
,
  list(name = "as ArcSinh", fn = test_as_ArcSinh)
,
  list(name = "ac ArcCosh", fn = test_ac_ArcCosh)
,
  list(name = "at ArcTanh", fn = test_at_ArcTanh)
,
  list(name = "ex Exp", fn = test_ex_Exp)
,
  list(name = "lg Log Natural", fn = test_lg_Log_Natural)
,
  list(name = "l1 Log 10", fn = test_l1_Log_10)
,
  list(name = "l2 Log 2", fn = test_l2_Log_2)
,
  list(name = "sq Sqrt", fn = test_sq_Sqrt)
,
  list(name = "fl Floor", fn = test_fl_Floor)
,
  list(name = "cl Ceiling", fn = test_cl_Ceiling)
,
  list(name = "tr Trunc", fn = test_tr_Trunc)
,
  list(name = "ro Round", fn = test_ro_Round)
,
  list(name = "sg Sign", fn = test_sg_Sign)
,
  list(name = "ab Abs", fn = test_ab_Abs)
,
  list(name = "l+ Log(1+x)", fn = test_l__Log_1_x_)
,
  list(name = "e- Exp(x)-1", fn = test_e__Exp_x__1)
,
  list(name = "cp Cos(pi*x)", fn = test_cp_Cos_pi_x_)
,
  list(name = "SP Sin(pi*x)", fn = test_SP_Sin_pi_x_)
,
  list(name = "tp Tan(pi*x)", fn = test_tp_Tan_pi_x_)
,
  list(name = "g GCD", fn = test_g_GCD)
,
  list(name = "lc LCM", fn = test_lc_LCM)
,
  list(name = "ml LCM", fn = test_ml_LCM)
,
  list(name = "Xq Is Prime", fn = test_Xq_Is_Prime)
,
  list(name = "mp Is Prime", fn = test_mp_Is_Prime)
,
  list(name = "fa Factors", fn = test_fa_Factors)
,
  list(name = "mf Prime Factors", fn = test_mf_Prime_Factors)
,
  list(name = "XP Prime Factors", fn = test_XP_Prime_Factors)
,
  list(name = "fp Factorial", fn = test_fp_Factorial)
,
  list(name = "MC Choose", fn = test_MC_Choose)
,
  list(name = "Xn Choose (nCr)", fn = test_Xn_Choose__nCr_)
,
  list(name = "mG Gamma", fn = test_mG_Gamma)
,
  list(name = "mB Beta", fn = test_mB_Beta)
,
  list(name = "lb Log Beta", fn = test_lb_Log_Beta)
,
  list(name = "LG Log Gamma", fn = test_LG_Log_Gamma)
,
  list(name = "di Digamma", fn = test_di_Digamma)
,
  list(name = "tg Trigamma", fn = test_tg_Trigamma)
,
  list(name = "ps Psigamma", fn = test_ps_Psigamma)
,
  list(name = "cR Real Part", fn = test_cR_Real_Part)
,
  list(name = "cI Imag Part", fn = test_cI_Imag_Part)
,
  list(name = "cJ Conjugate", fn = test_cJ_Conjugate)
,
  list(name = "cA Arg", fn = test_cA_Arg)
,
  list(name = "cM Modulus", fn = test_cM_Modulus)
,
  list(name = "C Concat", fn = test_C_Concat)
,
  list(name = "j Join", fn = test_j_Join)
,
  list(name = "J Join List", fn = test_J_Join_List)
,
  list(name = "S Split String", fn = test_S_Split_String)
,
  list(name = "Xc Char Translate", fn = test_Xc_Char_Translate)
,
  list(name = "S! Translate", fn = test_S__Translate)
,
  list(name = "SG GSub", fn = test_SG_GSub)
,
  list(name = "Xt ToLower", fn = test_Xt_ToLower)
,
  list(name = "sU ToUpper", fn = test_sU_ToUpper)
,
  list(name = "sL ToLower", fn = test_sL_ToLower)
,
  list(name = "sn NChar", fn = test_sn_NChar)
,
  list(name = "ss Substr", fn = test_ss_Substr)
,
  list(name = "sr Sub", fn = test_sr_Sub)
,
  list(name = "sf Sprintf", fn = test_sf_Sprintf)
,
  list(name = "st TrimWS", fn = test_st_TrimWS)
,
  list(name = "sG Grep", fn = test_sG_Grep)
,
  list(name = "sB Grepl", fn = test_sB_Grepl)
,
  list(name = "sR Regexpr", fn = test_sR_Regexpr)
,
  list(name = "sX Gregexpr", fn = test_sX_Gregexpr)
,
  list(name = "rv Reverse String", fn = test_rv_Reverse_String)
,
  list(name = "sI Intersect", fn = test_sI_Intersect)
,
  list(name = "sN Union", fn = test_sN_Union)
,
  list(name = "sD SetDiff", fn = test_sD_SetDiff)
,
  list(name = "bA BitAnd", fn = test_bA_BitAnd)
,
  list(name = "bO BitOr", fn = test_bO_BitOr)
,
  list(name = "bX BitXor", fn = test_bX_BitXor)
,
  list(name = "bN BitNot", fn = test_bN_BitNot)
,
  list(name = "bL BitShiftL", fn = test_bL_BitShiftL)
,
  list(name = "bR BitShiftR", fn = test_bR_BitShiftR)
,
  list(name = "n To Number", fn = test_n_To_Number)
,
  list(name = "a To String", fn = test_a_To_String)
,
  list(name = "A To ASCII", fn = test_A_To_ASCII)
,
  list(name = "c To Char", fn = test_c_To_Char)
,
  list(name = "Xb To Binary", fn = test_Xb_To_Binary)
,
  list(name = "Xd To Date", fn = test_Xd_To_Date)
,
  list(name = "zd To Date", fn = test_zd_To_Date)
,
  list(name = "mF Factor", fn = test_mF_Factor)
,
  list(name = "AS As Type", fn = test_AS_As_Type)
,
  list(name = "is Is Type", fn = test_is_Is_Type)
,
  list(name = "ot Typeof", fn = test_ot_Typeof)
,
  list(name = "oc Class", fn = test_oc_Class)
,
  list(name = "oa Attributes", fn = test_oa_Attributes)
,
  list(name = "oA Attr", fn = test_oA_Attr)
,
  list(name = "on Names", fn = test_on_Names)
,
  list(name = "or Rownames", fn = test_or_Rownames)
,
  list(name = "oC Colnames", fn = test_oC_Colnames)
,
  list(name = "od Dim", fn = test_od_Dim)
,
  list(name = "ou Unlist", fn = test_ou_Unlist)
,
  list(name = "fi File Info", fn = test_fi_File_Info)
,
  list(name = "fe File Exists", fn = test_fe_File_Exists)
,
  list(name = "fX Dir Exists", fn = test_fX_Dir_Exists)
,
  list(name = "FL List Files", fn = test_FL_List_Files)
,
  list(name = "fD List Dirs", fn = test_fD_List_Dirs)
,
  list(name = "fb Basename", fn = test_fb_Basename)
,
  list(name = "fA Dirname", fn = test_fA_Dirname)
,
  list(name = "fP Abs Path", fn = test_fP_Abs_Path)
,
  list(name = "ft Temp Dir", fn = test_ft_Temp_Dir)
,
  list(name = "fT Temp File", fn = test_fT_Temp_File)
,
  list(name = "T Time Epoch", fn = test_T_Time_Epoch)
,
  list(name = "sT Tic", fn = test_sT_Tic)
,
  list(name = "sK Toc", fn = test_sK_Toc)
,
  list(name = "sP Sleep", fn = test_sP_Sleep)
,
  list(name = "sE Date", fn = test_sE_Date)
,
  list(name = "sH GetWD", fn = test_sH_GetWD)
,
  list(name = "zt SysTime", fn = test_zt_SysTime)
,
  list(name = "sV RVersion", fn = test_sV_RVersion)
,
  list(name = "ZT Timezone", fn = test_ZT_Timezone)
,
  list(name = "zl Locale", fn = test_zl_Locale)
,
  list(name = "zo Options", fn = test_zo_Options)
,
  list(name = "zg GC", fn = test_zg_GC)
,
  list(name = "zv Version", fn = test_zv_Version)
,
  list(name = "ge Getenv", fn = test_ge_Getenv)
,
  list(name = "pi GetPID", fn = test_pi_GetPID)
)

for (t in all_tests) {
  cat(sprintf("%-30s ... ", t$name))
  if (t$fn()) { cat("PASS\n"); passed <- passed + 1 }
  else { failed <- failed + 1; failures <- c(failures, t$name) }
}

cat("============================\n")
cat(sprintf("Tests run: %d | Passed: %d | Failed: %d | Skipped: %d\n",
            passed + failed, passed, failed, skipped))
if (failed > 0) {
  cat("\nFailed tests:\n")
  for (f in failures) cat(sprintf("  - %s\n", f))
  quit(status = 1)
}