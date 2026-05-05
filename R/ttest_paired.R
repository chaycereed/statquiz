#' Internal: generate a paired t-test question
#'
#' @keywords internal
generate_ttest_paired_question <- function(
  difficulty  = "medium",
  n           = 25,
  alpha       = 0.05,
  alternative = "two.sided"
) {

  difficulty  <- tolower(difficulty)
  alternative <- match.arg(alternative, c("two.sided", "less", "greater"))

  mean_diff <- switch(
    difficulty,
    "easy"   = 1.0,
    "medium" = 0.7,
    "hard"   = 0.4,
    0.7
  )

  if (alternative == "two.sided") {
    sign <- sample(c(-1, 1), size = 1)
  } else if (alternative == "greater") {
    sign <- 1
  } else {
    sign <- -1
  }

  true_mean_diff <- sign * mean_diff
  sd_diff        <- 1

  before      <- stats::rnorm(n, mean = 10, sd = 2)
  differences <- stats::rnorm(n, mean = true_mean_diff, sd = sd_diff)
  after       <- before - differences

  dat <- data.frame(before = before, after = after)

  tt            <- stats::t.test(dat$before, dat$after,
                                 paired      = TRUE,
                                 alternative = alternative)
  true_decision <- ifelse(tt$p.value < alpha, "reject", "fail_to_reject")

  alt_text <- switch(
    alternative,
    "two.sided" = "different from 0",
    "greater"   = "greater than 0",
    "less"      = "less than 0"
  )

  prompt_text <- paste0(
    "Topic: Paired t-test (", difficulty, ")\n\n",
    "You have before and after measurements for ", n, " subjects in\n",
    "columns `before` and `after`. Test whether the mean difference\n",
    "(before - after) is ", alt_text, " at alpha = ", alpha, ".\n\n",
    "Return your decision as either 'reject' or 'fail_to_reject'."
  )

  question <- list(
    id          = paste0("ttest_paired_",
                         as.integer(stats::runif(1, 1, 1e6))),
    topic       = "t_test_paired",
    difficulty  = difficulty,
    prompt      = prompt_text,
    data        = dat,
    answer_type = "decision",
    solution    = true_decision,
    meta        = list(
      alpha       = alpha,
      alternative = alternative,
      n           = n
    )
  )

  class(question) <- "statquiz_question"
  question
}
