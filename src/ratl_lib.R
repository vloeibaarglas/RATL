ratl_bin <- function(x) {
  if (x == 0) return("0")
  # intToBits returns 32 bits (raw). 
  # rev puts MSB first.
  # as.integer converts raw to 0/1 integers.
  bits <- as.integer(rev(intToBits(x)))
  # Collapse to string
  s <- paste(bits, collapse="")
  # Remove leading zeros
  sub("^0+", "", s)
}

ratl_mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

ratl_rms <- function(x) {
  sqrt(mean(x^2))
}

ratl_gcd <- function(x, y) {
  while(y) {
    temp = y
    y = x %% y
    x = temp
  }
  return(x)
}

ratl_lcm <- function(x, y) {
  if (x == 0 || y == 0) return(0)
  abs(x * y) / ratl_gcd(x, y)
}

ratl_is_prime <- function(n) {
  if (n <= 1) return(FALSE)
  if (n == 2) return(TRUE)
  if (n %% 2 == 0) return(FALSE)
  for (i in seq(3, sqrt(n), by = 2)) {
    if (n %% i == 0) return(FALSE)
  }
  return(TRUE)
}

ratl_factors <- function(n) {
  if (n == 0) return(numeric(0))
  f <- c()
  for (i in 1:abs(n)) {
    if (n %% i == 0) f <- c(f, i)
  }
  return(f)
}

ratl_prime_factors <- function(n) {
  factors <- c()
  d <- 2
  while (n > 1) {
    while (n %% d == 0) {
      factors <- c(factors, d)
      n <- n / d
    }
    d <- d + 1
    if (d*d > n) {
      if (n > 1) factors <- c(factors, n)
      break
    }
  }
  return(factors)
}

ratl_cum_sd <- function(x) {
  sapply(seq_along(x), function(i) if(i==1) NA else sd(x[1:i]))
}
