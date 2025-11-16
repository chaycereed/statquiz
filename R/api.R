#' Generate a new statquiz question
#'
#' @export
question <- function(topic, difficulty = "medium", ...) {
  topic <- tolower(topic)
  difficulty <- tolower(difficulty)

  if (topic == "anova") {
    out <- generate_anova_question(difficulty = difficulty, ...)
  } else if (topic == "probability") {
    out <- generate_probability_question(difficulty = difficulty, ...)
  } else {
    stop("Unknown topic: '", topic, "'. Supported: 'anova', 'probability'.")
  }

  out
}

#' Check a user's answer
#'
#' @export
check_answer <- function(question, user_answer) {

  if (!inherits(question, "statquiz_question")) {
    stop("`question` must be a statquiz_question object.")
  }

  type <- question$answer_type

  if (type == "decision") {

    # New valid answers:
    #   "reject"
    #   "fail_to_reject"
    if (!user_answer %in% c("reject", "fail_to_reject")) {
      stop(
        "For decision questions, answer must be 'reject' or 'fail_to_reject'."
      )
    }

    correct <- identical(user_answer, question$solution)

  } else if (type == "numeric_scalar") {

    if (!is.numeric(user_answer) || length(user_answer) != 1L) {
      stop("For numeric questions, answer must be a single number.")
    }

    tol <- question$meta$tolerance %||% 1e-3
    correct <- abs(user_answer - question$solution) < tol

  } else {
    stop("Unsupported answer_type: ", type)
  }

  if (correct) {
    message("✅ Correct!")
  } else {
    message(
      "❌ Not quite.\n",
      "You answered:   ", user_answer, "\n",
      "Correct answer: ", question$solution
    )
  }

  invisible(correct)
}