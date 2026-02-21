# Stack implementation using an environment for mutable state (O(1) push/pop)
make_stack <- function(capacity = 64L) {
  e <- new.env(hash = FALSE, parent = emptyenv())
  e$data <- vector("list", capacity)
  e$top <- 0L
  e
}

stack_push <- function(s, val) {
  s$top <- s$top + 1L
  # Resize if necessary (double capacity)
  if (s$top > length(s$data)) {
    length(s$data) <- 2L * length(s$data)
  }
  s$data[[s$top]] <- val
  invisible(NULL)
}

stack_pop <- function(s) {
  if (s$top <= 0L) stop("Stack underflow")
  val <- s$data[[s$top]]
  s$top <- s$top - 1L
  val
}

stack_peek <- function(s) {
  if (s$top <= 0L) stop("Stack empty")
  s$data[[s$top]]
}

stack_length <- function(s) {
  s$top
}

stack_to_list <- function(s) {
  if (s$top == 0L) return(list())
  s$data[1:s$top]
}
