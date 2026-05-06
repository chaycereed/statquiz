#' Internal: generate a Wilcoxon signed-rank test question
#'
#' @keywords internal
generate_wilcoxon_signed_rank_question <- function(
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

  true_diff <- sign * mean_diff

  # Skewed paired data: right-skewed before, zero-mean skewed noise
  before <- stats::rexp(n, rate = 0.5) + 5
  noise  <- stats::rexp(n, rate = 2) - 0.5
  after  <- before - true_diff + noise

  dat <- data.frame(before = before, after = after)

  wt <- suppressWarnings(
    stats::wilcox.test(dat$before, dat$after,
                       paired      = TRUE,
                       alternative = alternative)
  )
  true_decision <- ifelse(wt$p.value < alpha, "reject", "fail_to_reject")

  alt_text <- switch(
    alternative,
    "two.sided" = "different from 0",
    "greater"   = "greater than 0",
    "less"      = "less than 0"
  )

  prompt_text <- paste0(
    "Topic: Wilcoxon signed-rank test (", difficulty, ")\n\n",
    "You have paired before and after measurements for ", n, " subjects\n",
    "in columns `before` and `after`. The differences are skewed.\n",
    "Test whether the median difference (before - after) is ", alt_text,
    " at alpha = ", alpha, ".\n\n",
    "Return your decision as either 'reject' or 'fail_to_reject'."
  )

  question <- list(
    id          = paste0("wsr_", as.integer(stats::runif(1, 1, 1e6))),
    topic       = "wilcoxon_signed_rank",
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
