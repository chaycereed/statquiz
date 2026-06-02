#' Internal: generate a Welch's one-way ANOVA question
#'
#' @keywords internal
generate_welch_anova_question <- function(
  difficulty  = "medium",
  n_per_group = 25,
  alpha       = 0.05
) {
  difficulty <- tolower(difficulty)

  # Unequal group standard deviations — what motivates Welch's over classic ANOVA
  sds <- c(A = 1.5, B = 5.0, C = 3.0)

  # Group means by difficulty (larger gaps needed given high variance in group B)
  means <- switch(difficulty,
    "easy"   = c(A = 10, B = 17, C = 24),
    "medium" = c(A = 10, B = 15, C = 20),
    "hard"   = c(A = 10, B = 13, C = 16),
    c(A = 10, B = 15, C = 20)
  )

  data <- data.frame(
    y = c(
      stats::rnorm(n_per_group, means["A"], sds["A"]),
      stats::rnorm(n_per_group, means["B"], sds["B"]),
      stats::rnorm(n_per_group, means["C"], sds["C"])
    ),
    group = factor(rep(c("A", "B", "C"), each = n_per_group))
  )

  result   <- stats::oneway.test(y ~ group, data = data, var.equal = FALSE)
  solution <- if (result$p.value < alpha) "reject" else "fail_to_reject"

  prompt_text <- paste0(
    "You have measurements from three independent groups (A, B, C). ",
    "A test for homogeneity of variance suggests the group standard ",
    "deviations differ substantially, so a standard one-way ANOVA is ",
    "not appropriate.\n\n",
    "Test whether the group means are equal using Welch's one-way ANOVA ",
    "(H0: all group means are equal). Use alpha = ", alpha, ".\n\n",
    "The data are in q$data with columns 'y' and 'group'.\n",
    "Run oneway.test(y ~ group, data = q$data, var.equal = FALSE) and ",
    "compare the p-value to alpha.\n\n",
    "Return 'reject' if you reject H0, or 'fail_to_reject' otherwise."
  )

  question <- list(
    id          = paste0("welch_anova_", as.integer(stats::runif(1, 1, 1e6))),
    topic       = "welch_anova",
    difficulty  = difficulty,
    prompt      = prompt_text,
    data        = data,
    answer_type = "decision",
    solution    = solution,
    meta        = list(alpha = alpha)
  )

  class(question) <- "statquiz_question"
  question
}
