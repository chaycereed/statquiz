#' Show the worked solution for a statquiz question
#'
#' After attempting a question, call \code{explain()} to see the correct R
#' code, the computed test statistic or probability, and the reasoning behind
#' the answer.
#'
#' @param question A \code{"statquiz_question"} object returned by
#'   \code{\link{question}}.
#' @return Invisibly returns \code{question}.
#' @export
explain <- function(question) {

  if (!inherits(question, "statquiz_question")) {
    stop("`question` must be a statquiz_question object.")
  }

  topic <- question$topic
  meta  <- question$meta
  sol   <- question$solution

  text <- switch(
    topic,

    anova = {
      fit <- stats::aov(y ~ group, data = question$data)
      p   <- summary(fit)[[1]][["Pr(>F)"]][1]
      paste0(
        "Run a one-way ANOVA:\n\n",
        "  fit <- aov(y ~ group, data = q$data)\n",
        "  p   <- summary(fit)[[1]][[\"Pr(>F)\"][[1]\n",
        "  # p = ", round(p, 4), "\n\n",
        "p ", if (p < meta$alpha) "<" else ">=", " alpha (",
        meta$alpha, "), so the correct decision is '", sol, "'."
      )
    },

    probability = {
      if (meta$type == "die_single") {
        paste0(
          "Count favourable outcomes over total equally likely outcomes:\n\n",
          "  # outcomes in event: ", length(meta$event), "\n",
          "  # total outcomes:    ", meta$sides, "\n",
          "  ", length(meta$event), " / ", meta$sides,
          " = ", round(question$solution, 6)
        )
      } else if (meta$type == "coin_exact_heads") {
        paste0(
          "Use the binomial formula or dbinom():\n\n",
          "  dbinom(", meta$k, ", size = ", meta$n_flips, ", prob = 0.5)\n",
          "  # = ", round(question$solution, 6)
        )
      } else {
        paste0(
          "Enumerate all ", meta$sides^2L, " equally likely outcomes ",
          "and count those\nwith sum in {",
          paste(meta$targets, collapse = ", "), "}:\n\n",
          "  all  <- expand.grid(d1 = 1:", meta$sides,
          ", d2 = 1:", meta$sides, ")\n",
          "  hits <- (all$d1 + all$d2) %in% c(",
          paste(meta$targets, collapse = ", "), ")\n",
          "  sum(hits) / nrow(all)\n",
          "  # = ", round(question$solution, 6)
        )
      }
    },

    t_test_one_sample = {
      tt <- stats::t.test(question$data$x,
                          mu          = meta$mu0,
                          alternative = meta$alternative)
      paste0(
        "Run a one-sample t-test:\n\n",
        "  tt <- t.test(q$data$x,\n",
        "               mu          = ", meta$mu0, ",\n",
        "               alternative = '", meta$alternative, "')\n",
        "  # p = ", round(tt$p.value, 4), "\n\n",
        "p ", if (tt$p.value < meta$alpha) "<" else ">=", " alpha (",
        meta$alpha, "), so the correct decision is '", sol, "'."
      )
    },

    t_test_two_sample = {
      tt <- stats::t.test(y ~ group,
                          data        = question$data,
                          alternative = meta$alternative,
                          var.equal   = meta$var_equal)
      paste0(
        "Run a two-sample t-test:\n\n",
        "  tt <- t.test(y ~ group, data = q$data,\n",
        "               alternative = '", meta$alternative, "',\n",
        "               var.equal   = ", meta$var_equal, ")\n",
        "  # p = ", round(tt$p.value, 4), "\n\n",
        "p ", if (tt$p.value < meta$alpha) "<" else ">=", " alpha (",
        meta$alpha, "), so the correct decision is '", sol, "'."
      )
    },

    t_test_paired = {
      tt <- stats::t.test(question$data$before,
                          question$data$after,
                          paired      = TRUE,
                          alternative = meta$alternative)
      paste0(
        "Run a paired t-test:\n\n",
        "  tt <- t.test(q$data$before, q$data$after,\n",
        "               paired      = TRUE,\n",
        "               alternative = '", meta$alternative, "')\n",
        "  # p = ", round(tt$p.value, 4), "\n\n",
        "p ", if (tt$p.value < meta$alpha) "<" else ">=", " alpha (",
        meta$alpha, "), so the correct decision is '", sol, "'."
      )
    },

    correlation = {
      ct <- stats::cor.test(question$data$x,
                            question$data$y,
                            alternative = meta$alternative,
                            method      = meta$method)
      method_label <- if (meta$method == "pearson") "Pearson" else "Spearman"
      paste0(
        "Run a ", method_label, " correlation test:\n\n",
        "  ct <- cor.test(q$data$x, q$data$y,\n",
        "                 alternative = '", meta$alternative, "',\n",
        "                 method      = '", meta$method, "')\n",
        "  # p = ", round(ct$p.value, 4), "\n\n",
        "p ", if (ct$p.value < meta$alpha) "<" else ">=", " alpha (",
        meta$alpha, "), so the correct decision is '", sol, "'."
      )
    },

    which_test = {
      paste0(
        "The correct answer is '", sol, "'.\n\n",
        "Reasoning: ", .which_test_rationale(meta$scenario_id)
      )
    },

    linear_regression = {
      fit <- stats::lm(y ~ x, data = question$data)
      p   <- summary(fit)$coefficients["x", "Pr(>|t|)"]
      paste0(
        "Fit a simple linear regression and inspect the slope:\n\n",
        "  fit <- lm(y ~ x, data = q$data)\n",
        "  p   <- summary(fit)$coefficients[\"x\", \"Pr(>|t|)\"]\n",
        "  # p = ", round(p, 4), "\n\n",
        "p ", if (p < meta$alpha) "<" else ">=", " alpha (",
        meta$alpha, "), so the correct decision is '", sol, "'."
      )
    },

    welch_anova = {
      wt <- stats::oneway.test(y ~ group, data = question$data,
                               var.equal = FALSE)
      paste0(
        "Run Welch's one-way ANOVA:\n\n",
        "  oneway.test(y ~ group, data = q$data, var.equal = FALSE)\n",
        "  # p = ", round(wt$p.value, 4), "\n\n",
        "p ", if (wt$p.value < meta$alpha) "<" else ">=", " alpha (",
        meta$alpha, "), so the correct decision is '", sol, "'.\n\n",
        "Welch's ANOVA is used instead of classical one-way ANOVA because\n",
        "the group variances differ substantially."
      )
    },

    fishers_exact = {
      tbl <- table(question$data$group, question$data$outcome)
      ft  <- fisher.test(tbl)
      paste0(
        "Run Fisher's exact test:\n\n",
        "  tbl <- table(q$data$group, q$data$outcome)\n",
        "  ft  <- fisher.test(tbl)\n",
        "  # p = ", round(ft$p.value, 4), "\n\n",
        "p ", if (ft$p.value < meta$alpha) "<" else ">=", " alpha (",
        meta$alpha, "), so the correct decision is '", sol, "'.\n\n",
        "Fisher's exact test is used here (rather than chi-square) because\n",
        "with only ", nrow(question$data), " total observations, some expected\n",
        "cell counts fall below 5."
      )
    },

    chi_square = {
      tbl <- table(question$data$group, question$data$outcome)
      ct  <- suppressWarnings(stats::chisq.test(tbl))
      paste0(
        "Run a chi-square test of independence:\n\n",
        "  tbl <- table(q$data$group, q$data$outcome)\n",
        "  ct  <- chisq.test(tbl)\n",
        "  # p = ", round(ct$p.value, 4), "\n\n",
        "p ", if (ct$p.value < meta$alpha) "<" else ">=", " alpha (",
        meta$alpha, "), so the correct decision is '", sol, "'."
      )
    },

    kruskal_wallis = {
      kt <- suppressWarnings(
        stats::kruskal.test(y ~ group, data = question$data)
      )
      paste0(
        "Run a Kruskal-Wallis test:\n\n",
        "  kt <- kruskal.test(y ~ group, data = q$data)\n",
        "  # p = ", round(kt$p.value, 4), "\n\n",
        "p ", if (kt$p.value < meta$alpha) "<" else ">=", " alpha (",
        meta$alpha, "), so the correct decision is '", sol, "'."
      )
    },

    wilcoxon_rank_sum = {
      wt <- suppressWarnings(
        stats::wilcox.test(y ~ group, data = question$data,
                           alternative = meta$alternative)
      )
      paste0(
        "Run a Wilcoxon rank-sum test:\n\n",
        "  wt <- wilcox.test(y ~ group, data = q$data,\n",
        "                    alternative = '", meta$alternative, "')\n",
        "  # p = ", round(wt$p.value, 4), "\n\n",
        "p ", if (wt$p.value < meta$alpha) "<" else ">=", " alpha (",
        meta$alpha, "), so the correct decision is '", sol, "'."
      )
    },

    wilcoxon_signed_rank = {
      wt <- suppressWarnings(
        stats::wilcox.test(question$data$before, question$data$after,
                           paired      = TRUE,
                           alternative = meta$alternative)
      )
      paste0(
        "Run a paired Wilcoxon signed-rank test:\n\n",
        "  wt <- wilcox.test(q$data$before, q$data$after,\n",
        "                    paired      = TRUE,\n",
        "                    alternative = '", meta$alternative, "')\n",
        "  # p = ", round(wt$p.value, 4), "\n\n",
        "p ", if (wt$p.value < meta$alpha) "<" else ">=", " alpha (",
        meta$alpha, "), so the correct decision is '", sol, "'."
      )
    },

    stop("No explanation available for topic: ", topic)
  )

  cat(text, "\n")
  invisible(question)
}

.which_test_rationale <- function(scenario_id) {
  rationales <- c(
    one_way_anova =
      "Continuous normal outcome, 3+ independent groups, equal variances.",
    welch_anova =
      "Continuous normal outcome across 3+ groups with unequal variances.",
    kruskal_wallis =
      "Ordinal or non-normal outcome across 3+ independent groups.",
    pearson_correlation =
      "Two continuous normal variables; assessing a linear association.",
    spearman_correlation =
      "Monotonic but non-linear association, or outliers present.",
    one_sample_t =
      "Single continuous normal sample tested against a known value.",
    wilcoxon_signed_rank =
      "Paired or single sample with non-normal or skewed differences.",
    chi_square =
      "Two categorical variables; all expected cell counts >= 5.",
    fishers_exact =
      "2x2 contingency table with small expected cell counts (< 5).",
    two_sample_t_equal_var =
      "Two independent normal groups with similar variances.",
    two_sample_t_welch =
      "Two independent normal groups with unequal variances.",
    mann_whitney_u =
      "Two independent groups with an ordinal or non-normal outcome."
  )
  r <- rationales[[scenario_id]]
  if (is.null(r)) return("No rationale available.")
  r
}
