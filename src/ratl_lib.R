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

# --- Ciphers ---

ratl_rot <- function(x, n = 13) {
  chars <- utf8ToInt(x)
  is_lower <- chars >= 97 & chars <= 122
  is_upper <- chars >= 65 & chars <= 90
  result <- chars
  result[is_lower] <- ((chars[is_lower] - 97 + n) %% 26) + 97
  result[is_upper] <- ((chars[is_upper] - 65 + n) %% 26) + 65
  intToUtf8(result)
}

ratl_caesar <- function(x, n) {
  ratl_rot(x, n)
}

ratl_atbash <- function(x) {
  chars <- utf8ToInt(x)
  is_lower <- chars >= 97 & chars <= 122
  is_upper <- chars >= 65 & chars <= 90
  result <- chars
  result[is_lower] <- 219 - chars[is_lower]
  result[is_upper] <- 155 - chars[is_upper]
  intToUtf8(result)
}

ratl_vigenere <- function(text, key) {
  txt <- utf8ToInt(text)
  k <- utf8ToInt(key)
  is_alpha <- (txt >= 65 & txt <= 90) | (txt >= 97 & txt <= 122)
  result <- txt
  ki <- 1
  for (i in seq_along(txt)) {
    if (is_alpha[i]) {
      shift <- ((k[ki] - 65) %% 26)
      if (txt[i] >= 97) {
        result[i] <- ((txt[i] - 97 + shift) %% 26) + 97
      } else {
        result[i] <- ((txt[i] - 65 + shift) %% 26) + 65
      }
      ki <- (ki %% length(k)) + 1
    }
  }
  intToUtf8(result)
}

ratl_rail_fence <- function(text, rails) {
  chars <- strsplit(text, "")[[1]]
  n <- length(chars)
  fence <- matrix("", nrow = rails, ncol = n)
  row <- 1; dir <- 1
  for (i in 1:n) {
    fence[row, i] <- chars[i]
    if (rails > 1) {
      if (row == rails) dir <- -1
      if (row == 1) dir <- 1
      row <- row + dir
    }
  }
  paste(apply(fence, 1, function(r) paste(r[r != ""], collapse = "")), collapse = "")
}

ratl_columnar <- function(text, cols) {
  chars <- strsplit(text, "")[[1]]
  pad_len <- ceiling(length(chars) / cols) * cols
  length(chars) <- pad_len
  chars[is.na(chars)] <- "X"
  grid <- matrix(chars, ncol = cols, byrow = TRUE)
  paste(grid, collapse = "")
}
