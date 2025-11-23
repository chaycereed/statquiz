#' Internal: generate a one-way ANOVA question
#'
#' @keywords internal
generate_anova_question <- function(
  difficulty = "medium",
  n_per_group = 20,
  alpha = 0.05
) {

  difficulty <- tolower(difficulty)
  means <- switch(
    difficulty,
    "none"   = c(10, 10, 10),
    "easy"   = c(10, 12, 14),
    "medium" = c(10, 12, 14),
    "hard"   = c(10, 11, 13),
    c(10, 12, 14)
  )

  sd <- 3

  group <- factor(rep(c("A", "B", "C"), each = n_per_group))
  y <- c(
    stats::rnorm(n_per_group, mean = means[1], sd = sd),
    stats::rnorm(n_per_group, mean = means[2], sd = sd),
    stats::rnorm(n_per_group, mean = means[3], sd = sd)
  )

  dat <- data.frame(
    y = y,
    group = group
  )

  # Determine true decision
  fit <- stats::aov(y ~ group, data = dat)
  p_val <- summary(fit)[[1]][["Pr(>F)"]][1]
  true_decision <- ifelse(p_val < alpha, "reject", "fail_to_reject")

  prompt_text <- paste0(
    "Topic: One-way ANOVA (", difficulty, ")\n\n",
    "You have three groups (A, B, C).\n",
    "Test whether mean y differs across groups at alpha = ", alpha, ".\n\n",
    "Return your decision as either 'reject' or 'fail_to_reject'."
  )

  question <- list(
    id          = paste0("anova_", as.integer(stats::runif(1, 1, 1e6))),
    topic       = "anova",
    difficulty  = difficulty,
    prompt      = prompt_text,
    data        = dat,
    answer_type = "decision",
    solution    = true_decision,
    meta        = list(
      alpha = alpha,
      means = means,
      sd    = sd
    )
  )

  class(question) <- "statquiz_question"
  question
}