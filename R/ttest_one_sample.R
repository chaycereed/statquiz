#' Internal: generate a one-sample t-test question
#'
#' @keywords internal
generate_ttest_one_sample_question <- function(
  difficulty = "medium",
  n = 30,
  mu0 = 0,
  alpha = 0.05,
  alternative = "two.sided"
) {

  difficulty <- tolower(difficulty)
  alternative <- match.arg(alternative, c("two.sided", "less", "greater"))

  # Effect size by difficulty: mean shift from mu0
  mean_shift <- switch(
    difficulty,
    "none"   = 0,
    "easy"   = 1.0,
    "medium" = 0.7,
    "hard"   = 0.4,
    0.7
  )

  # Pick true mean based on alternative and shift
  true_mean <- switch(
    alternative,
    "two.sided" = mu0 + sample(c(-1, 1), size = 1) * mean_shift,
    "greater"   = mu0 + mean_shift,
    "less"      = mu0 - mean_shift
  )

  sd <- 1

  x <- stats::rnorm(n, mean = true_mean, sd = sd)
  dat <- data.frame(x = x)

  # Compute the "true" decision using t.test
  tt <- stats::t.test(x, mu = mu0, alternative = alternative)
  p_val <- tt$p.value
  true_decision <- ifelse(p_val < alpha, "reject", "fail_to_reject")

  alt_text <- switch(
    alternative,
    "two.sided" = "different from",
    "greater"   = "greater than",
    "less"      = "less than"
  )

  prompt_text <- paste0(
    "Topic: One-sample t-test (", difficulty, ")\n\n",
    "You have a sample of size n = ", n, " stored in column `x`.\n",
    "Test whether the population mean is ", alt_text, " ", mu0,
    " at alpha = ", alpha, ".\n\n",
    "Return your decision as either 'reject' or 'fail_to_reject'."
  )

  question <- list(
    id          = paste0("ttest_1s_", as.integer(stats::runif(1, 1, 1e6))),
    topic       = "t_test_one_sample",
    difficulty  = difficulty,
    prompt      = prompt_text,
    data        = dat,
    answer_type = "decision",
    solution    = true_decision,
    meta        = list(
      alpha       = alpha,
      mu0         = mu0,
      alternative = alternative,
      true_mean   = true_mean,
      sd          = sd,
      n           = n
    )
  )

  class(question) <- "statquiz_question"
  question
}