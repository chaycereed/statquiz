#' Internal: generate a chi-square test of independence question
#'
#' @keywords internal
generate_chi_square_question <- function(
  difficulty = "medium",
  n_per_group = 60,
  alpha       = 0.05
) {
  difficulty <- tolower(difficulty)

  levels_outcome <- c("Low", "Medium", "High")

  # Null (no association) proportions
  p_null <- c(Low = 1/3, Medium = 1/3, High = 1/3)

  # Alternative proportions by difficulty
  p_alt <- switch(difficulty,
    "easy"   = c(Low = 0.60, Medium = 0.25, High = 0.15),
    "medium" = c(Low = 0.50, Medium = 0.30, High = 0.20),
    "hard"   = c(Low = 0.40, Medium = 0.35, High = 0.25),
    c(Low = 0.50, Medium = 0.30, High = 0.20)
  )

  # Randomly decide whether there is a real effect
  use_effect <- sample(c(TRUE, FALSE), 1L)

  group_a <- sample(
    levels_outcome, n_per_group, replace = TRUE, prob = p_null
  )
  if (use_effect) {
    group_b <- sample(
      levels_outcome, n_per_group, replace = TRUE, prob = p_alt
    )
  } else {
    group_b <- sample(
      levels_outcome, n_per_group, replace = TRUE, prob = p_null
    )
  }

  data <- data.frame(
    group   = factor(c(rep("A", n_per_group), rep("B", n_per_group))),
    outcome = factor(
      c(group_a, group_b),
      levels = levels_outcome
    ),
    stringsAsFactors = FALSE
  )

  tbl    <- table(data$group, data$outcome)
  result <- suppressWarnings(chisq.test(tbl))

  solution <- if (result$p.value < alpha) "reject" else "fail_to_reject"

  prompt_text <- paste0(
    "Two independent groups (A and B) were surveyed on their exercise ",
    "frequency, recorded as Low, Medium, or High.\n\n",
    "Test whether exercise frequency is independent of group membership ",
    "(H0: the two categorical variables are independent).\n",
    "Use alpha = ", alpha, ".\n\n",
    "The data are in q$data with columns 'group' and 'outcome'.\n",
    "Run chisq.test(table(q$data$group, q$data$outcome)) and compare ",
    "the p-value to alpha.\n\n",
    "Return 'reject' if you reject H0, or 'fail_to_reject' otherwise."
  )

  question <- list(
    id          = paste0("chi_square_", as.integer(stats::runif(1, 1, 1e6))),
    topic       = "chi_square",
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
