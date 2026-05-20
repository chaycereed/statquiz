#' Generate a new statquiz question
#'
#' @export
question <- function(topic, difficulty = "medium", ...) {
  topic      <- tolower(topic)
  difficulty <- tolower(difficulty)

  if (topic == "random") {
    all_topics <- c(
      "anova", "probability", "t_test", "t_test_two_sample",
      "t_test_paired", "correlation", "spearman", "which_test",
      "kruskal_wallis", "wilcoxon_rank_sum", "wilcoxon_signed_rank",
      "linear_regression", "chi_square"
    )
    topic <- sample(all_topics, 1L)
  }

  if (topic == "anova") {

    out <- generate_anova_question(difficulty = difficulty, ...)

  } else if (topic == "probability") {

    out <- generate_probability_question(difficulty = difficulty, ...)

  } else if (topic %in% c("t_test", "ttest", "one_sample_t")) {

    out <- generate_ttest_one_sample_question(difficulty = difficulty, ...)

  } else if (topic %in% c("t_test_two_sample", "two_sample_t", "t_test2")) {

    out <- generate_ttest_two_sample_question(difficulty = difficulty, ...)

  } else if (topic %in% c("t_test_paired", "paired_t", "paired")) {

    out <- generate_ttest_paired_question(difficulty = difficulty, ...)

  } else if (topic %in% c("correlation", "corr",
                           "pearson", "pearson_correlation")) {

    out <- generate_correlation_question(
      difficulty = difficulty,
      method     = "pearson",
      ...
    )

  } else if (topic %in% c("spearman", "spearman_correlation")) {

    out <- generate_correlation_question(
      difficulty = difficulty,
      method     = "spearman",
      ...
    )

  } else if (topic %in% c("which_test", "test_choice", "which")) {

    out <- generate_which_test_question(difficulty = difficulty, ...)

  } else if (topic %in% c("kruskal_wallis", "kruskal",
                           "kruskal_wallis_test")) {

    out <- generate_kruskal_wallis_question(difficulty = difficulty, ...)

  } else if (topic %in% c("wilcoxon_rank_sum", "mann_whitney",
                           "mann_whitney_u")) {

    out <- generate_wilcoxon_rank_sum_question(difficulty = difficulty, ...)

  } else if (topic %in% c("wilcoxon_signed_rank", "signed_rank")) {

    out <- generate_wilcoxon_signed_rank_question(
      difficulty = difficulty, ...
    )

  } else if (topic %in% c("linear_regression", "lm", "regression",
                           "simple_regression")) {

    out <- generate_linear_regression_question(difficulty = difficulty, ...)

  } else if (topic %in% c("chi_square", "chisq", "chi_sq",
                           "chi_square_test")) {

    out <- generate_chi_square_question(difficulty = difficulty, ...)

  } else {
    stop(
      "Unknown topic: '", topic, "'. Supported topics include: ",
      "'anova', 'probability', 't_test', 't_test_two_sample', ",
      "'t_test_paired', 'correlation'/'pearson', 'spearman', ",
      "'kruskal_wallis', 'wilcoxon_rank_sum', 'wilcoxon_signed_rank', ",
      "'linear_regression', 'chi_square', 'which_test', 'random'."
    )
  }

  out
}

#' Print a statquiz question
#'
#' Displays the question prompt and, for data-bearing topics, a one-line
#' summary of the attached data frame. Called automatically when a
#' \code{"statquiz_question"} object is typed at the console.
#'
#' @param x A \code{"statquiz_question"} object returned by
#'   \code{\link{question}}.
#' @param ... Currently unused.
#' @return Invisibly returns \code{x}.
#' @export
print.statquiz_question <- function(x, ...) {
  cat(x$prompt, "\n")
  if (!is.null(x$data)) {
    cat(
      "\n[Data attached: n = ", nrow(x$data),
      ", columns: ", paste(names(x$data), collapse = ", "),
      " — access with q$data]\n",
      sep = ""
    )
  }
  invisible(x)
}

# Internal: validate and check a single question answer
check_question_answer <- function(question, user_answer) {

  type <- question$answer_type

  if (type == "decision") {

    if (!user_answer %in% c("reject", "fail_to_reject")) {
      stop(
        "For decision questions, `user_answer` must be ",
        "'reject' or 'fail_to_reject'."
      )
    }
    correct <- identical(user_answer, question$solution)

  } else if (type == "numeric_scalar") {

    if (!is.numeric(user_answer) || length(user_answer) != 1L) {
      stop(
        "For numeric questions, `user_answer` must be a single numeric value."
      )
    }
    tol <- question$meta$tolerance
    if (is.null(tol)) tol <- 1e-3
    correct <- abs(user_answer - question$solution) < tol

  } else if (type == "label") {

    if (!is.character(user_answer) || length(user_answer) != 1L) {
      stop(
        "For label questions, `user_answer` must be a single character string."
      )
    }
    norm     <- tolower(trimws(user_answer))
    accepted <- question$meta$accepted_labels
    correct  <- norm %in% accepted

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

#' Check a user's answer
#'
#' @export
check_answer <- function(question, user_answer) {

  if (inherits(question, "statquiz_quiz")) {
    return(check_quiz_answer(question, user_answer))
  }

  if (!inherits(question, "statquiz_question")) {
    stop("`question` must be a statquiz_question object.")
  }

  check_question_answer(question, user_answer)
}
