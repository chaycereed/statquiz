#' Internal: generate a two-sample t-test question
#'
#' @keywords internal
generate_ttest_two_sample_question <- function(
  difficulty = "medium",
  n_per_group = 30,
  alpha = 0.05,
  alternative = "two.sided",
  var_equal = FALSE
) {
  set.seed(NULL)

  difficulty  <- tolower(difficulty)
  alternative <- match.arg(alternative, c("two.sided", "less", "greater"))

  # Effect size by difficulty: difference in group means (B - A)
  mean_diff <- switch(
    difficulty,
    "none"   = 0,
    "easy"   = 1.0,
    "medium" = 0.7,
    "hard"   = 0.4,
    0.7
  )

  base_mean <- 0

  # Decide sign of the effect based on alternative
  if (alternative == "two.sided") {
    sign <- sample(c(-1, 1), size = 1)
  } else if (alternative == "greater") {
    sign <- 1
  } else {
    sign <- -1
  }

  mu_a <- base_mean
  mu_b <- base_mean + sign * mean_diff

  sd <- 1

  group <- factor(rep(c("A", "B"), each = n_per_group))
  y <- c(
    stats::rnorm(n_per_group, mean = mu_a, sd = sd),
    stats::rnorm(n_per_group, mean = mu_b, sd = sd)
  )

  dat <- data.frame(
    y = y,
    group = group
  )

  # Compute the "true" decision using t.test
  tt <- stats::t.test(y ~ group,
                      data = dat,
                      alternative = alternative,
                      var.equal = var_equal)
  p_val <- tt$p.value
  true_decision <- ifelse(p_val < alpha, "reject", "fail_to_reject")

  alt_text <- switch(
    alternative,
    "two.sided" = "different between groups A and B",
    "greater"   = "greater in group B than group A",
    "less"      = "less in group B than group A"
  )

  prompt_text <- paste0(
    "Topic: Two-sample t-test (", difficulty, ")\n\n",
    "You have two independent groups, A and B, in columns `group` and `y`.\n",
    "Test whether the mean of y is ", alt_text,
    " at alpha = ", alpha, ".\n\n",
    "Return your decision as either 'reject' or 'fail_to_reject'."
  )

  question <- list(
    id          = paste0("ttest_2s_", as.integer(stats::runif(1, 1, 1e6))),
    topic       = "t_test_two_sample",
    difficulty  = difficulty,
    prompt      = prompt_text,
    data        = dat,
    answer_type = "decision",
    solution    = true_decision,
    meta        = list(
      alpha       = alpha,
      alternative = alternative,
      var_equal   = var_equal,
      mu_a        = mu_a,
      mu_b        = mu_b,
      sd          = sd,
      n_per_group = n_per_group
    )
  )

  class(question) <- "statquiz_question"
  question
}