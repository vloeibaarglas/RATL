ratl_bin <- function(x) {
  if (x == 0) return("0")
  bits <- as.integer(rev(intToBits(x)))
  s <- paste(bits, collapse="")
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
  while(y != 0) {
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
  if (n <= 3) return(TRUE)
  if (n %% 2 == 0) return(FALSE)
  i <- 3L
  while (i * i <= n) {
    if (n %% i == 0) return(FALSE)
    i <- i + 2L
  }
  TRUE
}

ratl_factors <- function(n) {
  if (n == 0) return(numeric(0))
  Filter(function(i) n %% i == 0, 1:abs(n))
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

ratl_print <- function(x) {
  if (is.list(x)) {
    print(x)
  } else if (is.matrix(x)) {
    print(x)
  } else if (is.atomic(x) && length(x) <= 100) {
    cat(paste(x, collapse = " "), "\n", sep = "")
  } else {
    print(x)
  }
}
