#' Generate a new statquiz question
#'
#' @export
question <- function(topic, difficulty = "medium", ...) {
  topic      <- tolower(topic)
  difficulty <- tolower(difficulty)

  if (topic == "anova") {

    out <- generate_anova_question(difficulty = difficulty, ...)

  } else if (topic == "probability") {

    out <- generate_probability_question(difficulty = difficulty, ...)

  } else if (topic %in% c("t_test", "ttest", "one_sample_t")) {

    out <- generate_ttest_one_sample_question(difficulty = difficulty, ...)

  } else if (topic %in% c("t_test_two_sample", "two_sample_t", "t_test2")) {

    out <- generate_ttest_two_sample_question(difficulty = difficulty, ...)

  } else if (topic %in% c("correlation", "corr", "pearson", "pearson_correlation")) {

    # Default correlation: Pearson
    out <- generate_correlation_question(
      difficulty = difficulty,
      method     = "pearson",
      ...
    )

  } else if (topic %in% c("spearman", "spearman_correlation")) {

    # Spearman correlation
    out <- generate_correlation_question(
      difficulty = difficulty,
      method     = "spearman",
      ...
    )

  } else if (topic %in% c("which_test", "test_choice", "which")) {

    out <- generate_which_test_question(difficulty = difficulty, ...)

  } else {
    stop(
      "Unknown topic: '", topic, "'. Supported topics include: ",
      "'anova', 'probability', 't_test' (one-sample), ",
      "'t_test_two_sample' (two-sample), 'correlation'/'pearson', ",
      "'spearman', 'which_test'."
    )
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

    if (!user_answer %in% c("reject", "fail_to_reject")) {
      stop(
        "For decision questions, `user_answer` must be 'reject' or 'fail_to_reject'."
      )
    }
    correct <- identical(user_answer, question$solution)

  } else if (type == "numeric_scalar") {

    if (!is.numeric(user_answer) || length(user_answer) != 1L) {
      stop("For numeric questions, `user_answer` must be a single numeric value.")
    }

    tol <- question$meta$tolerance
    if (is.null(tol)) tol <- 1e-3

    correct <- abs(user_answer - question$solution) < tol

  } else if (type == "label") {

    if (!is.character(user_answer) || length(user_answer) != 1L) {
      stop("For label questions, `user_answer` must be a single character string.")
    }

    norm <- tolower(trimws(user_answer))
    accepted <- question$meta$accepted_labels

    correct <- norm %in% accepted

  } else {
    stop("Unsupported answer_type: ", type)
  }

  if (correct) {
    message("✅ Correct!")
  } else {
    message(
      "❌ Not quite.\n",
      "You answered:   ", user_answer, "\n",
      "Correct answer (canonical): ", question$solution
    )
  }

  invisible(correct)
}