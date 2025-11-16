#' Internal: generate a basic probability question
#'
#' @keywords internal
generate_probability_question <- function(
  difficulty = "easy"
) {
  set.seed(NULL)

  sides <- 6L
  event <- c(1L, 2L)

  prompt_text <- paste0(
    "Topic: Basic probability (", difficulty, ")\n\n",
    "You roll a fair 6-sided die once.\n",
    "What is the probability the outcome is in {1, 2}?\n\n",
    "Return your answer as a numeric probability."
  )

  true_prob <- length(event) / sides

  question <- list(
    id          = paste0("prob_", as.integer(stats::runif(1, 1, 1e6))),
    topic       = "probability",
    difficulty  = difficulty,
    prompt      = prompt_text,
    data        = NULL,
    answer_type = "numeric_scalar",
    solution    = true_prob,
    meta        = list(
      event     = event,
      sides     = sides,
      tolerance = 1e-3
    )
  )

  class(question) <- "statquiz_question"
  question
}