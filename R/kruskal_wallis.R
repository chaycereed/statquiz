#' Internal: generate a Kruskal-Wallis test question
#'
#' @keywords internal
generate_kruskal_wallis_question <- function(
  difficulty  = "medium",
  n_per_group = 20,
  alpha       = 0.05
) {

  difficulty <- tolower(difficulty)

  # Location shifts (in units of rexp sd = 1) for groups A, B, C
  shifts <- switch(
    difficulty,
    "easy"   = c(0, 1.5, 3.0),
    "medium" = c(0, 1.0, 2.0),
    "hard"   = c(0, 0.5, 1.0),
    c(0, 1.0, 2.0)
  )

  group <- factor(rep(c("A", "B", "C"), each = n_per_group))
  y <- c(
    stats::rexp(n_per_group, rate = 1) + shifts[1],
    stats::rexp(n_per_group, rate = 1) + shifts[2],
    stats::rexp(n_per_group, rate = 1) + shifts[3]
  )

  dat <- data.frame(y = y, group = group)

  kt            <- suppressWarnings(stats::kruskal.test(y ~ group, data = dat))
  true_decision <- ifelse(kt$p.value < alpha, "reject", "fail_to_reject")

  prompt_text <- paste0(
    "Topic: Kruskal-Wallis test (", difficulty, ")\n\n",
    "You have three independent groups (A, B, C) with right-skewed data.\n",
    "Test whether the distributions differ across groups at alpha = ",
    alpha, ".\n\n",
    "Return your decision as either 'reject' or 'fail_to_reject'."
  )

  question <- list(
    id          = paste0("kw_", as.integer(stats::runif(1, 1, 1e6))),
    topic       = "kruskal_wallis",
    difficulty  = difficulty,
    prompt      = prompt_text,
    data        = dat,
    answer_type = "decision",
    solution    = true_decision,
    meta        = list(alpha = alpha, shifts = shifts)
  )

  class(question) <- "statquiz_question"
  question
}
