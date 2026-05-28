#' Internal: generate a Fisher's exact test question
#'
#' @keywords internal
generate_fishers_exact_question <- function(
  difficulty  = "medium",
  n_per_group = 12,
  alpha       = 0.05
) {
  difficulty <- tolower(difficulty)

  # Probability of success in group A (baseline)
  p_a <- 0.25

  # Probability of success in group B by difficulty
  p_b <- switch(difficulty,
    "easy"   = 0.85,
    "medium" = 0.70,
    "hard"   = 0.50,
    0.70
  )

  # Randomly decide whether there is a real effect
  use_effect <- sample(c(TRUE, FALSE), 1L)

  outcomes_a <- sample(
    c("Success", "Failure"), n_per_group, replace = TRUE,
    prob = c(p_a, 1 - p_a)
  )
  if (use_effect) {
    outcomes_b <- sample(
      c("Success", "Failure"), n_per_group, replace = TRUE,
      prob = c(p_b, 1 - p_b)
    )
  } else {
    outcomes_b <- sample(
      c("Success", "Failure"), n_per_group, replace = TRUE,
      prob = c(p_a, 1 - p_a)
    )
  }

  data <- data.frame(
    group   = factor(c(rep("A", n_per_group), rep("B", n_per_group))),
    outcome = factor(
      c(outcomes_a, outcomes_b),
      levels = c("Success", "Failure")
    ),
    stringsAsFactors = FALSE
  )

  tbl    <- table(data$group, data$outcome)
  result <- fisher.test(tbl)

  solution <- if (result$p.value < alpha) "reject" else "fail_to_reject"

  prompt_text <- paste0(
    "A small pilot study assigned ", n_per_group, " participants to each of ",
    "two treatments (A and B) and recorded whether each participant had a ",
    "successful outcome.\n\n",
    "Test whether treatment group and outcome are independent ",
    "(H0: the odds of success are equal across groups).\n",
    "Use alpha = ", alpha, ".\n\n",
    "The data are in q$data with columns 'group' and 'outcome'.\n",
    "Run fisher.test(table(q$data$group, q$data$outcome)) and compare ",
    "the p-value to alpha.\n\n",
    "Note: Fisher's exact test is appropriate here because some expected ",
    "cell counts are below 5.\n\n",
    "Return 'reject' if you reject H0, or 'fail_to_reject' otherwise."
  )

  question <- list(
    id          = paste0("fishers_exact_", as.integer(stats::runif(1, 1, 1e6))),
    topic       = "fishers_exact",
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
