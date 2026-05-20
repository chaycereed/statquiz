#' Internal: generate a simple linear regression question
#'
#' @keywords internal
generate_linear_regression_question <- function(
  difficulty = "medium",
  n          = 50,
  alpha      = 0.05
) {

  difficulty <- tolower(difficulty)

  # Target correlation (controls slope significance)
  target_r <- switch(
    difficulty,
    "easy"   = 0.7,
    "medium" = 0.5,
    "hard"   = 0.3,
    0.5
  )

  sign <- sample(c(-1, 1), size = 1)
  rho  <- sign * target_r

  x <- stats::rnorm(n, mean = 0, sd = 1)
  z <- stats::rnorm(n, mean = 0, sd = 1)
  y <- rho * x + sqrt(1 - rho^2) * z

  dat <- data.frame(x = x, y = y)

  fit   <- stats::lm(y ~ x, data = dat)
  p_val <- summary(fit)$coefficients["x", "Pr(>|t|)"]
  true_decision <- ifelse(p_val < alpha, "reject", "fail_to_reject")

  prompt_text <- paste0(
    "Topic: Simple linear regression (", difficulty, ")\n\n",
    "You have paired observations in columns `x` and `y`.\n",
    "Test whether x is a significant predictor of y at alpha = ", alpha,
    ".\n",
    "(i.e., test H0: beta_1 = 0)\n\n",
    "Return your decision as either 'reject' or 'fail_to_reject'."
  )

  question <- list(
    id          = paste0("lm_", as.integer(stats::runif(1, 1, 1e6))),
    topic       = "linear_regression",
    difficulty  = difficulty,
    prompt      = prompt_text,
    data        = dat,
    answer_type = "decision",
    solution    = true_decision,
    meta        = list(
      alpha    = alpha,
      target_r = rho,
      n        = n
    )
  )

  class(question) <- "statquiz_question"
  question
}
