#' List all available question topics
#'
#' Prints a formatted table of every topic supported by \code{\link{question}},
#' including its canonical name, a short description, and the answer type it
#' expects.
#'
#' @return Invisibly returns a data frame with columns \code{topic},
#'   \code{description}, and \code{answer_type}.
#' @export
topics <- function() {
  tbl <- data.frame(
    topic = c(
      "anova",
      "probability",
      "t_test",
      "t_test_two_sample",
      "t_test_paired",
      "correlation",
      "spearman",
      "linear_regression",
      "kruskal_wallis",
      "wilcoxon_rank_sum",
      "wilcoxon_signed_rank",
      "chi_square",
      "which_test"
    ),
    description = c(
      "One-way ANOVA across three groups",
      "Basic probability (die rolls, coin flips, two-dice sums)",
      "One-sample t-test against a null mean",
      "Two-sample t-test (equal-variance or Welch's)",
      "Paired t-test on before/after measurements",
      "Pearson correlation between two continuous variables",
      "Spearman rank correlation for monotonic associations",
      "Simple linear regression (test whether slope != 0)",
      "Kruskal-Wallis test on three skewed groups",
      "Wilcoxon rank-sum test on two independent skewed groups",
      "Wilcoxon signed-rank test on paired skewed data",
      "Chi-square test of independence on a 2x3 table",
      "Scenario: choose the most appropriate statistical test"
    ),
    answer_type = c(
      "decision",
      "numeric",
      "decision",
      "decision",
      "decision",
      "decision",
      "decision",
      "decision",
      "decision",
      "decision",
      "decision",
      "decision",
      "label"
    ),
    stringsAsFactors = FALSE
  )

  cat("Available topics (pass to question()):\n\n")
  cat(sprintf(
    "  %-24s %-48s %s\n",
    "TOPIC", "DESCRIPTION", "ANSWER TYPE"
  ))
  cat(sprintf(
    "  %-24s %-48s %s\n",
    strrep("-", 24), strrep("-", 48), strrep("-", 11)
  ))
  for (i in seq_len(nrow(tbl))) {
    cat(sprintf(
      "  %-24s %-48s %s\n",
      tbl$topic[i], tbl$description[i], tbl$answer_type[i]
    ))
  }
  cat(sprintf("\n  Pass topic = \"random\" to draw from all topics at random.\n"))

  invisible(tbl)
}
