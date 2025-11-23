#' Internal: generate a "which test" question
#'
#' @keywords internal
generate_which_test_question <- function(
  difficulty = "medium"
) {
  difficulty <- tolower(difficulty)

  # Internal list of scenarios
  scenarios <- list(
    list(
      id      = "one_way_anova",
      label   = "one_way_anova",
      aliases = c("one_way_anova", "anova", "one-way anova", "classic anova"),
      prompt  = paste0(
        "You want to compare the mean systolic blood pressure across 4 ",
        "independent treatment groups. The outcome is continuous and ",
        "approximately normal in each group, variances appear similar, ",
        "and sample sizes are around 30 per group.\n"
      )
    ),
    list(
      id      = "welch_anova",
      label   = "welch_anova",
      aliases = c("welch_anova", "welch's anova", "welch one-way anova"),
      prompt  = paste0(
        "You want to compare the mean reaction time across 3 independent ",
        "groups. The outcome is continuous and approximately normal, but ",
        "standard deviations differ substantially between groups and a ",
        "test for equal variances is clearly significant.\n"
      )
    ),
    list(
      id      = "kruskal_wallis",
      label   = "kruskal_wallis",
      aliases = c("kruskal_wallis", "kruskal-wallis", "kruskal wallis"),
      prompt  = paste0(
        "You want to compare a 1–5 pain rating across 4 independent ",
        "treatment groups. The outcome is ordinal with strong skew and ",
        "clear outliers; normality assumptions are not reasonable.\n"
      )
    ),
    list(
      id      = "pearson_correlation",
      label   = "pearson_correlation",
      aliases = c("pearson_correlation", "pearson", "pearson's correlation"),
      prompt  = paste0(
        "You measure height and weight for 100 adults and want to assess ",
        "the strength and direction of a linear relationship. Both ",
        "variables are continuous and approximately normal, with no ",
        "extreme outliers.\n"
      )
    ),
    list(
      id      = "spearman_correlation",
      label   = "spearman_correlation",
      aliases = c("spearman_correlation", "spearman", "spearman's correlation"),
      prompt  = paste0(
        "You have 60 people rated on two 1–10 preference scales. The ",
        "relationship appears monotonic but not linear, and the data ",
        "contain several clear outliers. You want a rank-based measure ",
        "of association.\n"
      )
    ),
    list(
      id      = "one_sample_t",
      label   = "one_sample_t",
      aliases = c("one_sample_t", "one-sample t-test", "one sample t test"),
      prompt  = paste0(
        "You have a single sample of 25 observations of daily step counts. ",
        "The outcome is continuous and roughly normal. You want to test ",
        "whether the mean differs from 10,000 steps.\n"
      )
    ),
    list(
      id      = "wilcoxon_signed_rank",
      label   = "wilcoxon_signed_rank",
      aliases = c("wilcoxon_signed_rank", "wilcoxon signed rank", "signed-rank"),
      prompt  = paste0(
        "You have before and after anxiety scores for the same 18 subjects ",
        "who completed a mindfulness program. The differences are strongly ",
        "skewed with several outliers, and the normality assumption for a ",
        "paired t-test is not appropriate.\n"
      )
    ),
    list(
      id      = "chi_square",
      label   = "chi_square",
      aliases = c("chi_square", "chi-square", "chisq", "chi square"),
      prompt  = paste0(
        "You want to test whether smoking status (smoker/non-smoker) is ",
        "associated with exercise frequency (low/medium/high) in a sample ",
        "of 400 adults. All expected cell counts are comfortably above 5.\n"
      )
    ),
    list(
      id      = "fishers_exact",
      label   = "fishers_exact",
      aliases = c("fishers_exact", "fisher's exact", "fisher exact"),
      prompt  = paste0(
        "You have a 2x2 table of treatment (drug/placebo) by outcome ",
        "(improved/not improved) in a very small clinical pilot study ",
        "with 12 total participants. Some expected cell counts are below 5.\n"
      )
    ),
    list(
      id      = "two_sample_t_equal_var",
      label   = "two_sample_t_equal_var",
      aliases = c("two_sample_t_equal_var", "pooled t-test", "two-sample t-test equal var"),
      prompt  = paste0(
        "You compare mean exam scores between two independent teaching ",
        "methods (A vs B) with 40 students per group. Scores are ",
        "continuous, approximately normal, and group variances appear ",
        "similar.\n"
      )
    ),
    list(
      id      = "two_sample_t_welch",
      label   = "two_sample_t_welch",
      aliases = c("two_sample_t_welch", "welch t-test", "welch two-sample t"),
      prompt  = paste0(
        "You compare mean length of hospital stay between two independent ",
        "treatments. Outcomes are continuous and roughly normal, but one ",
        "group has much larger variance than the other and equal-variance ",
        "assumptions are not reasonable.\n"
      )
    ),
    list(
      id      = "mann_whitney_u",
      label   = "mann_whitney_u",
      aliases = c("mann_whitney_u", "mann-whitney", "wilcoxon rank sum",
                  "wilcoxon rank-sum", "wilcoxon rank sum test"),
      prompt  = paste0(
        "You compare pain scores (0–10) between two independent groups ",
        "receiving different analgesics. The outcome is ordinal with a ",
        "skewed distribution and outliers; a normality-based t-test is ",
        "not appropriate.\n"
      )
    )
  )

  # Randomly select one scenario
  s <- scenarios[[sample.int(length(scenarios), 1)]]

  accepted_labels <- unique(
    tolower(trimws(c(s$label, s$aliases)))
  )

  prompt_text <- paste0(
    "Which statistical test is most appropriate for the following scenario?\n\n",
    s$prompt, "\n",
    "Return the test name as a string. Accepted canonical labels include:\n",
    "- 'one_way_anova'\n",
    "- 'welch_anova'\n",
    "- 'kruskal_wallis'\n",
    "- 'pearson_correlation'\n",
    "- 'spearman_correlation'\n",
    "- 'one_sample_t'\n",
    "- 'wilcoxon_signed_rank'\n",
    "- 'chi_square'\n",
    "- 'fishers_exact'\n",
    "- 'two_sample_t_equal_var'\n",
    "- 'two_sample_t_welch'\n",
    "- 'mann_whitney_u'\n"
  )

  question <- list(
    id          = paste0("which_test_", as.integer(stats::runif(1, 1, 1e6))),
    topic       = "which_test",
    difficulty  = difficulty,
    prompt      = prompt_text,
    data        = NULL,
    answer_type = "label",
    solution    = s$label,
    meta        = list(
      scenario_id     = s$id,
      accepted_labels = accepted_labels
    )
  )

  class(question) <- "statquiz_question"
  question
}