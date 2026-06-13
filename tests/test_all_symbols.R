#!/usr/bin/env Rscript
# Auto-generated: smoke test for every symbol (internal API)

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

passed <- 0
failed <- 0

cat(sprintf("Testing 393 symbols (internal API)...\n", 393))
cat("============================\n")

cat("Add ... ") 
r <- run_ratl("3 5 +")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Subtract ... ") 
r <- run_ratl("3 5 -")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Multiply ... ") 
r <- run_ratl("3 5 *")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Divide ... ") 
r <- run_ratl("3 5 /")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Transpose ... ") 
r <- run_ratl("5 !")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Duplicate ... ") 
r <- run_ratl("5 D")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Sum ... ") 
r <- run_ratl("5 s")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Product ... ") 
r <- run_ratl("5 P")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random n ... ") 
r <- run_ratl("5 r")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Sequence ... ") 
r <- run_ratl("3 5 :")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Equal ... ") 
r <- run_ratl("3 5 =")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Less ... ") 
r <- run_ratl("3 5 <")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Greater ... ") 
r <- run_ratl("3 5 >")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Not ... ") 
r <- run_ratl("5 ~")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Variance ... ") 
r <- run_ratl("5 v")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("All ... ") 
r <- run_ratl("5 vA")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Outer Product ... ") 
r <- run_ratl("3 5 &")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Or ... ") 
r <- run_ratl("3 5 |")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Filter ... ") 
r <- run_ratl("[1 2 3] 2 #")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Mean ... ") 
r <- run_ratl("5 m")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Standard Deviation ... ") 
r <- run_ratl("5 sd")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Variance ... ") 
r <- run_ratl("5 V")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Median ... ") 
r <- run_ratl("5 h")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Quantile ... ") 
r <- run_ratl("5 Q")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("TTest ... ") 
r <- run_ratl("3 5 tt")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random Normal ... ") 
r <- run_ratl("5 N")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Summary ... ") 
r <- run_ratl("5 sm")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Linear Model ... ") 
r <- run_ratl("5 lm")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Anova ... ") 
r <- run_ratl("5 av")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Correlation ... ") 
r <- run_ratl("3 5 cr")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Covariance ... ") 
r <- run_ratl("3 5 cv")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Scale ... ") 
r <- run_ratl("5 sc")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Swap ... ") 
r <- run_ratl("3 5 w")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Mean ... ") 
r <- run_ratl("5 Xp")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Median ... ") 
r <- run_ratl("5 Xm")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Mode ... ") 
r <- run_ratl("5 Xo")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("RMS ... ") 
r <- run_ratl("5 Xr")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Std Dev ... ") 
r <- run_ratl("5 Xs")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Modulo ... ") 
r <- run_ratl("3 5 %")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Power ... ") 
r <- run_ratl("3 5 ^")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Length ... ") 
r <- run_ratl("5 l")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Stack Length ... ") 
r <- run_ratl("1 2 Ls")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Sort ... ") 
r <- run_ratl("5 O")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Reverse ... ") 
r <- run_ratl("5 R")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Concat ... ") 
r <- run_ratl("3 5 C")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Join ... ") 
r <- run_ratl("3 5 j")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Join List ... ") 
r <- run_ratl("3 5 J")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("To Number ... ") 
r <- run_ratl("5 n")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("To String ... ") 
r <- run_ratl("5 a")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Char Translate ... ") 
r <- run_ratl("1 2 3 Xc")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("To Binary ... ") 
r <- run_ratl("5 Xb")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("RLE ... ") 
r <- run_ratl("5 Xk")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("GCD ... ") 
r <- run_ratl("3 5 g")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("LCM ... ") 
r <- run_ratl("3 5 lc")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Is Prime ... ") 
r <- run_ratl("5 Xq")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Factors ... ") 
r <- run_ratl("5 fa")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Split String ... ") 
r <- run_ratl("3 5 S")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Unique ... ") 
r <- run_ratl("5 u")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("To ASCII ... ") 
r <- run_ratl("5 A")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("To Char ... ") 
r <- run_ratl("5 c")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Create Matrix ... ") 
r <- run_ratl("1 2 3 ym")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Matrix Mult ... ") 
r <- run_ratl("3 5 Y*")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Identity Matrix ... ") 
r <- run_ratl("5 yD")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("To Date ... ") 
r <- run_ratl("5 Xd")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Choose nCr ... ") 
r <- run_ratl("3 5 Xn")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("CumSum ... ") 
r <- run_ratl("5 XC")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("ToLower ... ") 
r <- run_ratl("5 Xt")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Prime Factors ... ") 
r <- run_ratl("5 XP")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("CumSD ... ") 
r <- run_ratl("5 XSD")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Concat Vectors ... ") 
r <- run_ratl("3 5 ,")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Mean ... ") 
r <- run_ratl("5 Bm")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Median ... ") 
r <- run_ratl("5 Bd")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Standard Deviation ... ") 
r <- run_ratl("5 Bs")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Variance ... ") 
r <- run_ratl("5 Bv")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("MAD ... ") 
r <- run_ratl("5 Ba")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Min ... ") 
r <- run_ratl("5 Bn")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Max ... ") 
r <- run_ratl("5 Bx")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Range ... ") 
r <- run_ratl("5 Br")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Quantile ... ") 
r <- run_ratl("5 Bq")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("IQR ... ") 
r <- run_ratl("5 Bi")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Summary ... ") 
r <- run_ratl("5 BS")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("FiveNum ... ") 
r <- run_ratl("5 B5")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Correlation ... ") 
r <- run_ratl("3 5 Bc")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Covariance ... ") 
r <- run_ratl("3 5 BC")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Scale ... ") 
r <- run_ratl("5 Bz")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random Normal ... ") 
r <- run_ratl("5 rn")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Density Normal ... ") 
r <- run_ratl("5 dn")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Prob Normal ... ") 
r <- run_ratl("5 pn")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Quantile Normal ... ") 
r <- run_ratl("5 qn")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random Uniform ... ") 
r <- run_ratl("5 ru")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random Binomial ... ") 
r <- run_ratl("5 rb")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random Poisson ... ") 
r <- run_ratl("5 rp")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random Exp ... ") 
r <- run_ratl("5 re")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("TTest ... ") 
r <- run_ratl("3 5 kt")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("ChiSquare Test ... ") 
r <- run_ratl("5 kc")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Wilcoxon Test ... ") 
r <- run_ratl("3 5 kw")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Prop Test ... ") 
r <- run_ratl("3 5 kp")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Cor Test ... ") 
r <- run_ratl("3 5 KC")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Fisher Test ... ") 
r <- run_ratl("5 kf")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("ShapiroWilk ... ") 
r <- run_ratl("5 ks")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("KS Test ... ") 
r <- run_ratl("3 5 kk")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("FTest Var ... ") 
r <- run_ratl("3 5 kv")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Anova ... ") 
r <- run_ratl("5 ka")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("KruskalWallis ... ") 
r <- run_ratl("5 KK")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Bartlett Test ... ") 
r <- run_ratl("5 kb")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Linear Model ... ") 
r <- run_ratl("5 kl")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("GLM ... ") 
r <- run_ratl("5 kg")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("AOV ... ") 
r <- run_ratl("5 KA")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Loess ... ") 
r <- run_ratl("5 ko")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("NLS ... ") 
r <- run_ratl("5 kn")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Predict ... ") 
r <- run_ratl("3 5 ke")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Residuals ... ") 
r <- run_ratl("5 KE")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Coef ... ") 
r <- run_ratl("5 K!")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Fitted ... ") 
r <- run_ratl("5 KF")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("AIC ... ") 
r <- run_ratl("5 ki")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("BIC ... ") 
r <- run_ratl("5 KB")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("LogLik ... ") 
r <- run_ratl("5 KL")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("VCov ... ") 
r <- run_ratl("5 KV")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("PCA ... ") 
r <- run_ratl("5 vp")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Density ... ") 
r <- run_ratl("5 vd")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Sin ... ") 
r <- run_ratl("5 ms")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Cos ... ") 
r <- run_ratl("5 mc")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Tan ... ") 
r <- run_ratl("5 mt")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("ArcSin ... ") 
r <- run_ratl("5 aS")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("ArcCos ... ") 
r <- run_ratl("5 aC")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("ArcTan ... ") 
r <- run_ratl("5 aT")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("ArcTan2 ... ") 
r <- run_ratl("3 5 a2")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Sinh ... ") 
r <- run_ratl("5 sh")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Cosh ... ") 
r <- run_ratl("5 ch")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Tanh ... ") 
r <- run_ratl("5 th")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("ArcSinh ... ") 
r <- run_ratl("5 as")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("ArcCosh ... ") 
r <- run_ratl("5 ac")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("ArcTanh ... ") 
r <- run_ratl("5 at")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Floor ... ") 
r <- run_ratl("5 fl")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Ceiling ... ") 
r <- run_ratl("5 cl")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Trunc ... ") 
r <- run_ratl("5 tr")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Round ... ") 
r <- run_ratl("5 ro")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Sign ... ") 
r <- run_ratl("5 sg")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Abs ... ") 
r <- run_ratl("5 ab")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Real Part ... ") 
r <- run_ratl("5 c.re")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Imag Part ... ") 
r <- run_ratl("5 c.im")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Conjugate ... ") 
r <- run_ratl("5 c.conj")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Arg ... ") 
r <- run_ratl("5 c.arg")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Modulus ... ") 
r <- run_ratl("5 c.mod")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Exp ... ") 
r <- run_ratl("5 ex")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Log Natural ... ") 
r <- run_ratl("5 lg")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Log 10 ... ") 
r <- run_ratl("5 l1")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Log 2 ... ") 
r <- run_ratl("5 l2")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Determinant ... ") 
r <- run_ratl("5 yd")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Rot90 ... ") 
r <- run_ratl("5 R9")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Full ... ") 
r <- run_ratl("5 yf")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Trace ... ") 
r <- run_ratl("5 yt")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Diag ... ") 
r <- run_ratl("5 y!")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("TriUpper ... ") 
r <- run_ratl("5 yu")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("TriLower ... ") 
r <- run_ratl("5 yl")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Kronecker ... ") 
r <- run_ratl("3 5 yk")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("EigenValues ... ") 
r <- run_ratl("5 yv")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("EigenVectors ... ") 
r <- run_ratl("5 yc")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Intersect ... ") 
r <- run_ratl("3 5 set.is")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Union ... ") 
r <- run_ratl("3 5 set.un")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("SetDiff ... ") 
r <- run_ratl("3 5 set.sw")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("IsElement ... ") 
r <- run_ratl("3 5 set.ie")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Any ... ") 
r <- run_ratl("5 l.any")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("All ... ") 
r <- run_ratl("5 l.all")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Xor ... ") 
r <- run_ratl("3 5 l.xor")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("NNZ ... ") 
r <- run_ratl("5 l.nz")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("ToUpper ... ") 
r <- run_ratl("5 sU")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("ToLower ... ") 
r <- run_ratl("5 sL")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("NChar ... ") 
r <- run_ratl("5 sn")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Substr ... ") 
r <- run_ratl("1 2 3 ss")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Sub ... ") 
r <- run_ratl("1 2 3 sr")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("GSub ... ") 
r <- run_ratl("1 2 3 SG")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Paste ... ") 
r <- run_ratl("3 5 sp")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Paste0 ... ") 
r <- run_ratl("3 5 s0")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Sprintf ... ") 
r <- run_ratl("3 5 sf")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("TrimWS ... ") 
r <- run_ratl("5 st")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("BitAnd ... ") 
r <- run_ratl("3 5 b.and")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("BitOr ... ") 
r <- run_ratl("3 5 b.or")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("BitXor ... ") 
r <- run_ratl("3 5 b.xor")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("BitNot ... ") 
r <- run_ratl("5 b.not")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("BitShiftL ... ") 
r <- run_ratl("3 5 b.shiftl")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("BitShiftR ... ") 
r <- run_ratl("3 5 b.shiftr")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("CumMin ... ") 
r <- run_ratl("5 v.cmin")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("CumMax ... ") 
r <- run_ratl("5 v.cmax")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("CumProd ... ") 
r <- run_ratl("5 v.cprod")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Diff ... ") 
r <- run_ratl("5 v.diff")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("PMax ... ") 
r <- run_ratl("3 5 v.max")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("PMin ... ") 
r <- run_ratl("3 5 v.min")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Which ... ") 
r <- run_ratl("5 wh")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("WhichArr ... ") 
r <- run_ratl("5 v.whicha")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Seq ... ") 
r <- run_ratl("3 5 v.seq")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("SeqLen ... ") 
r <- run_ratl("1 2 3 v.seqlen")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Rep ... ") 
r <- run_ratl("3 5 r2")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("RepMat ... ") 
r <- run_ratl("1 2 3 v.repmat")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Drop ... ") 
r <- run_ratl("5 v.drop")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Choose ... ") 
r <- run_ratl("3 5 MC")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Factor ... ") 
r <- run_ratl("5 m.factor")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Gamma ... ") 
r <- run_ratl("5 m.gamma")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Beta ... ") 
r <- run_ratl("3 5 m.beta")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Factorial ... ") 
r <- run_ratl("5 fp")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("IntDiv ... ") 
r <- run_ratl("3 5 m.idiv")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("LM Simple ... ") 
r <- run_ratl("3 5 m.lm")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Quantile ... ") 
r <- run_ratl("3 5 m.quantile")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Skewness ... ") 
r <- run_ratl("5 Sk")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Kurtosis ... ") 
r <- run_ratl("5 Ku")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("WeightedMean ... ") 
r <- run_ratl("3 5 Sw")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("MeanNA ... ") 
r <- run_ratl("5 Sm")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("SumNA ... ") 
r <- run_ratl("5 Sn")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Pi ... ") 
r <- run_ratl("Pi")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Head ... ") 
r <- run_ratl("5 SH")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Tail ... ") 
r <- run_ratl("5 ST")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Rank ... ") 
r <- run_ratl("5 SR")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Sort ... ") 
r <- run_ratl("5 SS")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Density Beta ... ") 
r <- run_ratl("1 2 3 db")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Prob Beta ... ") 
r <- run_ratl("1 2 3 pb")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Quantile Beta ... ") 
r <- run_ratl("1 2 3 qb")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random Beta ... ") 
r <- run_ratl("1 2 3 RB")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Density Binomial ... ") 
r <- run_ratl("1 2 3 dB")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Prob Binomial ... ") 
r <- run_ratl("1 2 3 pB")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Quantile Binomial ... ") 
r <- run_ratl("1 2 3 qB")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random Binomial ... ") 
r <- run_ratl("1 2 3 rB")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Density Cauchy ... ") 
r <- run_ratl("1 2 3 dc")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Prob Cauchy ... ") 
r <- run_ratl("1 2 3 pc")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Quantile Cauchy ... ") 
r <- run_ratl("1 2 3 qc")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random Cauchy ... ") 
r <- run_ratl("1 2 3 rc")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Density ChiSquare ... ") 
r <- run_ratl("3 5 dC")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Prob ChiSquare ... ") 
r <- run_ratl("3 5 pC")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Quantile ChiSquare ... ") 
r <- run_ratl("3 5 qC")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random ChiSquare ... ") 
r <- run_ratl("3 5 rC")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Density Exponential ... ") 
r <- run_ratl("3 5 de")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Prob Exponential ... ") 
r <- run_ratl("3 5 pe")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Quantile Exponential ... ") 
r <- run_ratl("3 5 qe")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random Exponential ... ") 
r <- run_ratl("3 5 RE")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Density F ... ") 
r <- run_ratl("1 2 3 df")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Prob F ... ") 
r <- run_ratl("1 2 3 pf")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Quantile F ... ") 
r <- run_ratl("1 2 3 qf")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random F ... ") 
r <- run_ratl("1 2 3 rf")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Density Gamma ... ") 
r <- run_ratl("1 2 3 dg")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Prob Gamma ... ") 
r <- run_ratl("1 2 3 pg")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Quantile Gamma ... ") 
r <- run_ratl("1 2 3 qg")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random Gamma ... ") 
r <- run_ratl("1 2 3 rg")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Density Geometric ... ") 
r <- run_ratl("3 5 dG")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Prob Geometric ... ") 
r <- run_ratl("3 5 pG")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Quantile Geometric ... ") 
r <- run_ratl("3 5 qG")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random Geometric ... ") 
r <- run_ratl("3 5 rG")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Density Hypergeometric ... ") 
r <- run_ratl("1 2 3 4 dh")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Prob Hypergeometric ... ") 
r <- run_ratl("1 2 3 4 ph")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Quantile Hypergeometric ... ") 
r <- run_ratl("1 2 3 4 qh")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random Hypergeometric ... ") 
r <- run_ratl("1 2 3 4 rh")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Density LogNormal ... ") 
r <- run_ratl("1 2 3 dl")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Prob LogNormal ... ") 
r <- run_ratl("1 2 3 pl")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Quantile LogNormal ... ") 
r <- run_ratl("1 2 3 ql")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random LogNormal ... ") 
r <- run_ratl("1 2 3 rl")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Density Logistic ... ") 
r <- run_ratl("1 2 3 dL")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Prob Logistic ... ") 
r <- run_ratl("1 2 3 pL")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Quantile Logistic ... ") 
r <- run_ratl("1 2 3 qL")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random Logistic ... ") 
r <- run_ratl("1 2 3 rL")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Density NegBinomial ... ") 
r <- run_ratl("1 2 3 dN")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Prob NegBinomial ... ") 
r <- run_ratl("1 2 3 pN")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Quantile NegBinomial ... ") 
r <- run_ratl("1 2 3 qN")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random NegBinomial ... ") 
r <- run_ratl("1 2 3 rN")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Density Normal ... ") 
r <- run_ratl("1 2 3 DN")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Prob Normal ... ") 
r <- run_ratl("1 2 3 PN")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Quantile Normal ... ") 
r <- run_ratl("1 2 3 QN")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random Normal ... ") 
r <- run_ratl("1 2 3 RN")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Density Poisson ... ") 
r <- run_ratl("3 5 dP")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Prob Poisson ... ") 
r <- run_ratl("3 5 pP")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Quantile Poisson ... ") 
r <- run_ratl("3 5 qP")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random Poisson ... ") 
r <- run_ratl("3 5 rP")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Density Studentt ... ") 
r <- run_ratl("3 5 dt")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Prob Studentt ... ") 
r <- run_ratl("3 5 pt")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Quantile Studentt ... ") 
r <- run_ratl("3 5 qt")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random Studentt ... ") 
r <- run_ratl("3 5 rt")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Density Uniform ... ") 
r <- run_ratl("1 2 3 du")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Prob Uniform ... ") 
r <- run_ratl("1 2 3 pu")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Quantile Uniform ... ") 
r <- run_ratl("1 2 3 qu")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random Uniform ... ") 
r <- run_ratl("1 2 3 RU")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Density Weibull ... ") 
r <- run_ratl("1 2 3 dw")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Prob Weibull ... ") 
r <- run_ratl("1 2 3 pw")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Quantile Weibull ... ") 
r <- run_ratl("1 2 3 qw")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random Weibull ... ") 
r <- run_ratl("1 2 3 rw")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Log1x ... ") 
r <- run_ratl("5 l+")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Expx1 ... ") 
r <- run_ratl("5 e-")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Cospix ... ") 
r <- run_ratl("5 cp")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Sinpix ... ") 
r <- run_ratl("5 SP")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Tanpix ... ") 
r <- run_ratl("5 tp")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Log Beta ... ") 
r <- run_ratl("3 5 lb")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Log Gamma ... ") 
r <- run_ratl("5 LG")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Digamma ... ") 
r <- run_ratl("5 di")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Trigamma ... ") 
r <- run_ratl("5 tg")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Psigamma ... ") 
r <- run_ratl("3 5 ps")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Col Indices ... ") 
r <- run_ratl("5 v.col")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Row Indices ... ") 
r <- run_ratl("5 v.row")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Col Sums ... ") 
r <- run_ratl("5 v.cs")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Row Sums ... ") 
r <- run_ratl("5 v.rs")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Col Means ... ") 
r <- run_ratl("5 v.cm")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Row Means ... ") 
r <- run_ratl("5 v.rm")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Solve ... ") 
r <- run_ratl("5 v.slv")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Solve 2 ... ") 
r <- run_ratl("3 5 v.sl2")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("QR Decomp ... ") 
r <- run_ratl("5 v.qr")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("SVD ... ") 
r <- run_ratl("5 v.svd")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Grep ... ") 
r <- run_ratl("3 5 s.gre")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Grepl ... ") 
r <- run_ratl("3 5 s.grl")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Regexpr ... ") 
r <- run_ratl("3 5 s.rex")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Gregexpr ... ") 
r <- run_ratl("3 5 s.grx")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Sprintf ... ") 
r <- run_ratl("3 5 s.spr")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("As Type ... ") 
r <- run_ratl("3 5 AS")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Is Type ... ") 
r <- run_ratl("3 5 is")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Typeof ... ") 
r <- run_ratl("5 ot")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Class ... ") 
r <- run_ratl("5 oc")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Attributes ... ") 
r <- run_ratl("5 oa")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Attr ... ") 
r <- run_ratl("3 5 oA")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Names ... ") 
r <- run_ratl("5 on")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Rownames ... ") 
r <- run_ratl("5 or")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Colnames ... ") 
r <- run_ratl("5 oC")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Dim ... ") 
r <- run_ratl("5 od")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Length ... ") 
r <- run_ratl("5 oL")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Unlist ... ") 
r <- run_ratl("5 ou")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Apply ... ") 
r <- run_ratl("1 2 3 Fa")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Lapply ... ") 
r <- run_ratl("3 5 Fl")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Sapply ... ") 
r <- run_ratl("3 5 Fs")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Vapply ... ") 
r <- run_ratl("1 2 3 Fv")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Mapply ... ") 
r <- run_ratl("5 Fm")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Reduce ... ") 
r <- run_ratl("3 5 Fr")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Filter Func ... ") 
r <- run_ratl("3 5 Ff")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Find Func ... ") 
r <- run_ratl("3 5 Fn")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Negate ... ") 
r <- run_ratl("5 fn")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Position ... ") 
r <- run_ratl("3 5 Fp")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("By ... ") 
r <- run_ratl("1 2 3 d.by")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Aggregate ... ") 
r <- run_ratl("1 2 3 d.agg")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Split ... ") 
r <- run_ratl("3 5 d.spl")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Unsplit ... ") 
r <- run_ratl("3 5 d.uns")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Order ... ") 
r <- run_ratl("5 d.ord")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Rank Full ... ") 
r <- run_ratl("5 d.ran")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Match ... ") 
r <- run_ratl("3 5 d.mat")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Cut ... ") 
r <- run_ratl("3 5 d.cut")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Table ... ") 
r <- run_ratl("5 d.tab")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("XTabs ... ") 
r <- run_ratl("3 5 d.xta")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Conf Int ... ") 
r <- run_ratl("5 m.ci")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("VCov ... ") 
r <- run_ratl("5 m.vc")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Anova Full ... ") 
r <- run_ratl("5 m.an")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("AIC ... ") 
r <- run_ratl("5 m.ai")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("BIC ... ") 
r <- run_ratl("5 m.bi")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Coef ... ") 
r <- run_ratl("5 m.co")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Residuals ... ") 
r <- run_ratl("5 m.res")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Fitted ... ") 
r <- run_ratl("5 m.fit")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Predict ... ") 
r <- run_ratl("5 m.pre")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Update ... ") 
r <- run_ratl("3 5 m.upd")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Offset ... ") 
r <- run_ratl("5 m.off")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Formula ... ") 
r <- run_ratl("5 m.for")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Terms ... ") 
r <- run_ratl("5 m.ter")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Model Frame ... ") 
r <- run_ratl("5 m.mfr")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Model Matrix ... ") 
r <- run_ratl("5 m.mmt")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Getenv ... ") 
r <- run_ratl("5 ge")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Bingo Twin ... ") 
r <- run_ratl("5 BT")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Matrix ByRow ... ") 
r <- run_ratl("1 2 3 YM")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Pair ... ") 
r <- run_ratl("3 5 ..")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Reverse ... ") 
r <- run_ratl("5 vr")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Sum ... ") 
r <- run_ratl("5 vs")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Product ... ") 
r <- run_ratl("5 p1")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Random ... ") 
r <- run_ratl("5 v.rand")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("RMS ... ") 
r <- run_ratl("5 rm")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("GCD ... ") 
r <- run_ratl("3 5 mg")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("LCM ... ") 
r <- run_ratl("3 5 ml")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Create Matrix ... ") 
r <- run_ratl("1 2 3 Y!")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Is Prime ... ") 
r <- run_ratl("5 mp")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Unique ... ") 
r <- run_ratl("5 uq")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("RLE ... ") 
r <- run_ratl("5 v.rle")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("To ASCII ... ") 
r <- run_ratl("5 sa")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("To Date ... ") 
r <- run_ratl("5 zd")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Prime Factors ... ") 
r <- run_ratl("5 mf")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("CumSD ... ") 
r <- run_ratl("5 Sd")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Translate ... ") 
r <- run_ratl("1 2 3 S!")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Flatten ... ") 
r <- run_ratl("5 fu")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Zip ... ") 
r <- run_ratl("3 5 zp")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Min2 ... ") 
r <- run_ratl("3 5 mn")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Max2 ... ") 
r <- run_ratl("3 5 mx")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Reverse String ... ") 
r <- run_ratl("5 rv")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("CumProd ... ") 
r <- run_ratl("5 c1")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Tabulate ... ") 
r <- run_ratl("5 tb")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("UniqueN ... ") 
r <- run_ratl("5 un")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("IndexOf ... ") 
r <- run_ratl("3 5 ix")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("IsIn ... ") 
r <- run_ratl("3 5 cn")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("HeadN ... ") 
r <- run_ratl("3 5 hd")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("TailN ... ") 
r <- run_ratl("3 5 tl")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("LastElem ... ") 
r <- run_ratl("5 la")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("FirstElem ... ") 
r <- run_ratl("5 fe1")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Slice ... ") 
r <- run_ratl("3 5 sl")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("NegSlice ... ") 
r <- run_ratl("3 5 ns")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Range1toN ... ") 
r <- run_ratl("5 r1")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("LessEqual ... ") 
r <- run_ratl("3 5 <=")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("GreatEqual ... ") 
r <- run_ratl("3 5 >=")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }
cat("Sqrt ... ") 
r <- run_ratl("5 sq")
if (!grepl("Error:", r)) { cat("PASS\n"); passed <- passed+1 } else { cat("FAIL: ", r, "\n"); failed <- failed+1 }

cat("============================\n")
cat(sprintf("Passed: %d | Failed: %d\n", passed, failed))
if (failed > 0) quit(status = 1)
