#' Internal: generate a Wilcoxon rank-sum (Mann-Whitney) question
#'
#' @keywords internal
generate_wilcoxon_rank_sum_question <- function(
  difficulty  = "medium",
  n_per_group = 30,
  alpha       = 0.05,
  alternative = "two.sided"
) {

  difficulty  <- tolower(difficulty)
  alternative <- match.arg(alternative, c("two.sided", "less", "greater"))

  # Location shift between groups (in units of rexp sd = 1)
  mean_diff <- switch(
    difficulty,
    "easy"   = 1.5,
    "medium" = 1.0,
    "hard"   = 0.5,
    1.0
  )

  if (alternative == "two.sided") {
    sign <- sample(c(-1, 1), size = 1)
  } else if (alternative == "greater") {
    sign <- 1
  } else {
    sign <- -1
  }

  shift_b <- sign * mean_diff

  group <- factor(rep(c("A", "B"), each = n_per_group))
  y <- c(
    stats::rexp(n_per_group, rate = 1),
    stats::rexp(n_per_group, rate = 1) + shift_b
  )

  dat <- data.frame(y = y, group = group)

  wt <- suppressWarnings(
    stats::wilcox.test(y ~ group, data = dat, alternative = alternative)
  )
  true_decision <- ifelse(wt$p.value < alpha, "reject", "fail_to_reject")

  alt_text <- switch(
    alternative,
    "two.sided" = "differ between groups A and B",
    "greater"   = "tend to be greater in group B than group A",
    "less"      = "tend to be less in group B than group A"
  )

  prompt_text <- paste0(
    "Topic: Wilcoxon rank-sum test (", difficulty, ")\n\n",
    "You have two independent groups (A and B) with right-skewed data\n",
    "in columns `group` and `y`.\n",
    "Test whether the values of y tend to ", alt_text,
    " at alpha = ", alpha, ".\n\n",
    "Return your decision as either 'reject' or 'fail_to_reject'."
  )

  question <- list(
    id          = paste0("wrs_", as.integer(stats::runif(1, 1, 1e6))),
    topic       = "wilcoxon_rank_sum",
    difficulty  = difficulty,
    prompt      = prompt_text,
    data        = dat,
    answer_type = "decision",
    solution    = true_decision,
    meta        = list(
      alpha       = alpha,
      alternative = alternative,
      shift_b     = shift_b
    )
  )

  class(question) <- "statquiz_question"
  question
}
