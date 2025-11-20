#' Internal: generate a correlation question (Pearson or Spearman)
#'
#' @keywords internal
generate_correlation_question <- function(
  difficulty  = "medium",
  n           = 50,
  alpha       = 0.05,
  alternative = "two.sided",
  method      = "pearson"
) {
  set.seed(NULL)

  difficulty  <- tolower(difficulty)
  alternative <- match.arg(alternative, c("two.sided", "less", "greater"))
  method      <- match.arg(tolower(method), c("pearson", "spearman"))

  # Target correlation magnitude by difficulty
  target_r <- switch(
    difficulty,
    "none"   = 0.0,
    "easy"   = 0.7,
    "medium" = 0.5,
    "hard"   = 0.3,
    0.5
  )

  # Choose sign based on alternative
  if (alternative == "two.sided") {
    sign <- sample(c(-1, 1), size = 1)
  } else if (alternative == "greater") {
    sign <- 1
  } else { # "less"
    sign <- -1
  }

  rho <- sign * target_r

  # Generate paired data with approximate correlation rho
  # For both Pearson and Spearman we can start from a bivariate normal.
  x <- stats::rnorm(n, mean = 0, sd = 1)
  z <- stats::rnorm(n, mean = 0, sd = 1)
  y <- rho * x + sqrt(1 - rho^2) * z

  dat <- data.frame(
    x = x,
    y = y
  )

  # Compute the "true" decision using cor.test with chosen method
  ct <- stats::cor.test(
    dat$x,
    dat$y,
    alternative = alternative,
    method      = method
  )
  p_val <- ct$p.value
  true_decision <- ifelse(p_val < alpha, "reject", "fail_to_reject")

  alt_text <- switch(
    alternative,
    "two.sided" = "is non-zero",
    "greater"   = "is greater than 0",
    "less"      = "is less than 0"
  )

  method_label <- if (method == "pearson") "Pearson" else "Spearman"

  prompt_text <- paste0(
    "Topic: ", method_label, " correlation (", difficulty, ")\n\n",
    "You have paired observations in columns `x` and `y`.\n",
    "Test whether the true correlation between x and y ", alt_text,
    " at alpha = ", alpha, ".\n\n",
    "Use cor.test(x, y, method = '", method, "', alternative = '",
    alternative, "').\n",
    "Return your decision as either 'reject' or 'fail_to_reject'."
  )

  question <- list(
    id          = paste0("corr_", method, "_", as.integer(stats::runif(1, 1, 1e6))),
    topic       = "correlation",
    difficulty  = difficulty,
    prompt      = prompt_text,
    data        = dat,
    answer_type = "decision",
    solution    = true_decision,
    meta        = list(
      alpha       = alpha,
      alternative = alternative,
      target_r    = rho,
      n           = n,
      method      = method
    )
  )

  class(question) <- "statquiz_question"
  question
}