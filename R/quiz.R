#' Start a multi-question quiz session
#'
#' Generates a sequence of randomized questions and tracks your answers as you
#' work through them. Pass the returned object to \code{\link{check_answer}}
#' to record each answer and advance to the next question. Call
#' \code{\link{score}} when finished.
#'
#' @param n Number of questions to generate.
#' @param topics Character vector of topics to draw from, or \code{"all"}
#'   to include every available topic.
#' @param difficulty Difficulty level passed to each question generator.
#'   One of \code{"easy"}, \code{"medium"}, or \code{"hard"}.
#' @return A \code{"statquiz_quiz"} environment.
#' @export
quiz <- function(n = 5, topics = "all", difficulty = "medium") {

  all_topics <- c(
    "anova", "probability", "t_test", "t_test_two_sample",
    "t_test_paired", "correlation", "spearman", "which_test",
    "kruskal_wallis", "wilcoxon_rank_sum", "wilcoxon_signed_rank"
  )

  if (identical(topics, "all")) {
    topics <- all_topics
  } else {
    topics <- tolower(topics)
  }

  questions <- vector("list", n)
  for (i in seq_len(n)) {
    t            <- sample(topics, 1L)
    questions[[i]] <- question(t, difficulty = difficulty)
  }

  qz              <- new.env(parent = emptyenv())
  qz$questions    <- questions
  qz$n            <- as.integer(n)
  qz$current      <- 1L
  qz$correct      <- rep(NA, n)
  qz$user_answers <- vector("list", n)
  qz$difficulty   <- difficulty

  class(qz) <- "statquiz_quiz"
  qz
}

#' Print a statquiz quiz
#'
#' Shows the current question and progress indicator. Once all questions have
#' been answered, prompts you to call \code{\link{score}}.
#'
#' @param x A \code{"statquiz_quiz"} object returned by \code{\link{quiz}}.
#' @param ... Currently unused.
#' @return Invisibly returns \code{x}.
#' @export
print.statquiz_quiz <- function(x, ...) {
  if (x$current > x$n) {
    cat("Quiz complete. Call score() to see your results.\n")
    return(invisible(x))
  }
  cat(sprintf("Question %d of %d\n\n", x$current, x$n))
  print(x$questions[[x$current]])
  invisible(x)
}

#' Show quiz results
#'
#' Prints a score summary and a per-question breakdown after completing a
#' quiz session started with \code{\link{quiz}}.
#'
#' @param quiz A \code{"statquiz_quiz"} object returned by \code{\link{quiz}}.
#' @return Invisibly returns \code{quiz}.
#' @export
score <- function(quiz) {
  if (!inherits(quiz, "statquiz_quiz")) {
    stop("`quiz` must be a statquiz_quiz object.")
  }

  answered   <- !is.na(quiz$correct)
  n_answered <- sum(answered)
  n_correct  <- sum(quiz$correct[answered])

  cat(sprintf("Score: %d / %d", n_correct, n_answered))
  if (n_answered < quiz$n) {
    cat(sprintf(" (%d question(s) unanswered)", quiz$n - n_answered))
  }
  cat("\n\n")

  for (i in seq_len(quiz$n)) {
    q <- quiz$questions[[i]]
    if (is.na(quiz$correct[[i]])) {
      cat(sprintf("  Q%d [%s]: not answered\n", i, q$topic))
    } else if (quiz$correct[[i]]) {
      cat(sprintf("  Q%d [%s]: correct\n", i, q$topic))
    } else {
      ans <- quiz$user_answers[[i]]
      cat(sprintf(
        "  Q%d [%s]: incorrect — you: '%s', correct: '%s'\n",
        i, q$topic, as.character(ans), q$solution
      ))
    }
  }

  invisible(quiz)
}

# Internal: record answer and advance quiz
check_quiz_answer <- function(qz, user_answer) {
  if (qz$current > qz$n) {
    stop("Quiz is already complete. Call score() to see results.")
  }

  q      <- qz$questions[[qz$current]]
  result <- check_question_answer(q, user_answer)

  qz$correct[[qz$current]]      <- result
  qz$user_answers[[qz$current]] <- user_answer
  qz$current                    <- qz$current + 1L

  if (qz$current <= qz$n) {
    cat(sprintf("\nQuestion %d of %d\n\n", qz$current, qz$n))
    print(qz$questions[[qz$current]])
  } else {
    cat("\nQuiz complete. Call score() to see your results.\n")
  }

  invisible(result)
}
