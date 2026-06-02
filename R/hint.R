#' Get a hint for a statquiz question
#'
#' Prints a short nudge pointing you toward the right R function and key
#' considerations without revealing the answer or p-value. Call this when
#' you're stuck but not ready to see the full worked solution from
#' \code{\link{explain}}.
#'
#' @param question A \code{"statquiz_question"} object returned by
#'   \code{\link{question}}.
#' @return Invisibly returns \code{question}.
#' @export
hint <- function(question) {

  if (!inherits(question, "statquiz_question")) {
    stop("`question` must be a statquiz_question object.")
  }

  topic <- question$topic
  meta  <- question$meta

  text <- switch(
    topic,

    anova =
      paste0(
        "Fit a one-way ANOVA:\n\n",
        "  fit <- aov(y ~ group, data = q$data)\n\n",
        "Extract the p-value with:\n",
        "  summary(fit)[[1]][[\"Pr(>F)\"][[1]\n\n",
        "Compare it to q$meta$alpha."
      ),

    probability = {
      if (meta$type == "die_single") {
        paste0(
          "Count how many sides of the die satisfy the event, ",
          "then divide by the total number of sides."
        )
      } else if (meta$type == "coin_exact_heads") {
        paste0(
          "Use the binomial formula for exactly k heads in n flips:\n\n",
          "  dbinom(k, size = n, prob = 0.5)"
        )
      } else {
        paste0(
          "Enumerate all outcomes for two dice, then count those matching ",
          "the target sum(s):\n\n",
          "  all <- expand.grid(d1 = 1:", meta$sides,
          ", d2 = 1:", meta$sides, ")\n",
          "  mean((all$d1 + all$d2) %in% c(...))"
        )
      }
    },

    t_test_one_sample =
      paste0(
        "Run a one-sample t-test:\n\n",
        "  t.test(q$data$x, mu = q$meta$mu0,\n",
        "         alternative = q$meta$alternative)\n\n",
        "Compare the p-value to q$meta$alpha."
      ),

    t_test_two_sample =
      paste0(
        "Run a two-sample t-test:\n\n",
        "  t.test(y ~ group, data = q$data,\n",
        "         var.equal = q$meta$var_equal)\n\n",
        "Compare the p-value to q$meta$alpha."
      ),

    t_test_paired =
      paste0(
        "Run a paired t-test:\n\n",
        "  t.test(q$data$before, q$data$after, paired = TRUE)\n\n",
        "Compare the p-value to q$meta$alpha."
      ),

    correlation =
      paste0(
        "Run a correlation test:\n\n",
        "  cor.test(q$data$x, q$data$y,\n",
        "           method      = q$meta$method,\n",
        "           alternative = q$meta$alternative)\n\n",
        "Compare the p-value to q$meta$alpha."
      ),

    which_test =
      paste0(
        "Work through these questions about the scenario:\n\n",
        "  1. Is the outcome continuous, ordinal, or categorical?\n",
        "  2. How many groups or variables are being compared?\n",
        "  3. Are the observations independent or paired?\n",
        "  4. Is a normality assumption reasonable?\n",
        "  5. Are sample sizes large enough for chi-square, or is ",
        "Fisher's exact needed?"
      ),

    linear_regression =
      paste0(
        "Fit a simple linear regression and inspect the slope:\n\n",
        "  fit <- lm(y ~ x, data = q$data)\n",
        "  summary(fit)$coefficients[\"x\", \"Pr(>|t|)\"]\n\n",
        "Compare the p-value to q$meta$alpha."
      ),

    welch_anova =
      paste0(
        "Run Welch's one-way ANOVA:\n\n",
        "  oneway.test(y ~ group, data = q$data, var.equal = FALSE)\n\n",
        "Compare the p-value to q$meta$alpha."
      ),

    kruskal_wallis =
      paste0(
        "Run a Kruskal-Wallis test:\n\n",
        "  kruskal.test(y ~ group, data = q$data)\n\n",
        "Compare the p-value to q$meta$alpha."
      ),

    wilcoxon_rank_sum =
      paste0(
        "Run a Wilcoxon rank-sum test:\n\n",
        "  wilcox.test(y ~ group, data = q$data,\n",
        "              alternative = q$meta$alternative)\n\n",
        "Compare the p-value to q$meta$alpha."
      ),

    wilcoxon_signed_rank =
      paste0(
        "Run a paired Wilcoxon signed-rank test:\n\n",
        "  wilcox.test(q$data$before, q$data$after,\n",
        "              paired = TRUE,\n",
        "              alternative = q$meta$alternative)\n\n",
        "Compare the p-value to q$meta$alpha."
      ),

    chi_square =
      paste0(
        "Run a chi-square test of independence:\n\n",
        "  chisq.test(table(q$data$group, q$data$outcome))\n\n",
        "Compare the p-value to q$meta$alpha."
      ),

    fishers_exact =
      paste0(
        "Run Fisher's exact test (appropriate for small expected ",
        "cell counts):\n\n",
        "  fisher.test(table(q$data$group, q$data$outcome))\n\n",
        "Compare the p-value to q$meta$alpha."
      ),

    stop("No hint available for topic: ", topic)
  )

  cat("Hint:", text, "\n")
  invisible(question)
}
