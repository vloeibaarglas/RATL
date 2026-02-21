#!/usr/bin/env Rscript

# Custom Test Runner for RATL
# Verifies examples against expected output from Rosetta Code or known correct answers.

run_ratl <- function(code, input_str = "") {
  res <- system2("./src/RATL.R", args = c(shQuote(code)), 
                 input = input_str, stdout = TRUE, stderr = TRUE)
  paste(trimws(res), collapse = "\n")
}

test_cases <- list(
  list(name = "A plus B", file = "examples/01_aplusb.ratl", input = "5\n10", expected = "15"),
  list(name = "Array Concat", file = "examples/02_array_concat.ratl", expected = "1 2 3 4 5 6"),
  list(name = "Array Length", file = "examples/03_array_length.ratl", expected = "5"),
  list(name = "Arithmetic Mean", file = "examples/04_arithmetic_mean.ratl", expected = "2.5"),
  list(name = "Median", file = "examples/05_median.ratl", expected = "3"),
  list(name = "Copy String", file = "examples/06_copy_string.ratl", expected = "Hello"),
  list(name = "Factorial", file = "examples/13_factorial.ratl", expected = "120"),
  list(name = "Modulo", file = "examples/15_modulo.ratl", expected = "1"),
  list(name = "Sequence Sum", file = "examples/16_sequence_sum.ratl", expected = "5050"),
  list(name = "FizzBuzz", file = "examples/17_fizzbuzz.ratl", expected = "1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n11\nFizz\n13\n14\nFizzBuzz\n16\n17\nFizz\n19\nBuzz"),
  list(name = "Fibonacci", file = "examples/23_fibonacci.ratl", expected = "1\n1\n2\n3\n5\n8\n13\n21\n34\n55"),
  list(name = "GCD", file = "examples/21_gcd.ratl", expected = "21"),
  list(name = "LCM", file = "examples/22_lcm.ratl", expected = "36"),
  list(name = "Leap Year", file = "examples/24_leap_year.ratl", expected = "Leap"),
  list(name = "Palindrome", file = "examples/25_palindrome.ratl", expected = "Palindrome"),
  list(name = "Sum of Squares", file = "examples/27_sum_squares.ratl", expected = "385"),
  list(name = "Dot Product", file = "examples/28_dot_product.ratl", expected = "32"),
  list(name = "Identity Matrix", file = "examples/29_identity.ratl", expected = "1 0 0 0 1 0 0 0 1"),
  list(name = "100 Doors", file = "examples/44_100_doors.ratl", expected = "1 4 9 16 25 36 49 64 81 100"),
  list(name = "Amicable Pairs", file = "examples/45_amicable_pairs.ratl", expected = "220 284"),
  list(name = "Prime Factors", file = "examples/48_prime_factors.ratl", expected = "2 3 3 47 14593")
)

passed <- 0
failed <- 0

cat("Starting RATL Unit Tests...\n")
cat("===========================\n")

for (tc in test_cases) {
  cat(sprintf("Testing %-20s ... ", tc$name))
  
  code <- paste(readLines(tc$file, warn=FALSE), collapse = "\n")
  input_str <- if (is.null(tc$input)) "" else tc$input
  
  actual <- tryCatch({
    run_ratl(code, input_str)
  }, error = function(e) paste("ERROR:", e$message))
  
  actual <- trimws(actual)
  
  if (actual == tc$expected) {
    cat("PASS\n")
    passed <- passed + 1
  } else {
    cat("FAIL\n")
    cat(sprintf("  Expected: [%s]\n", gsub("\n", "\\n", tc$expected, fixed=TRUE)))
    cat(sprintf("  Actual:   [%s]\n", gsub("\n", "\\n", actual, fixed=TRUE)))
    failed <- failed + 1
  }
}

cat("===========================\n")
cat(sprintf("Tests run: %d | Passed: %d | Failed: %d\n", length(test_cases), passed, failed))

if (failed > 0) {
  quit(status = 1)
}
