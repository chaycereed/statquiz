make_decision_q <- function(solution = "reject") {
  q <- list(
    id          = "test_decision",
    topic       = "anova",
    difficulty  = "easy",
    prompt      = "test",
    data        = NULL,
    answer_type = "decision",
    solution    = solution,
    meta        = list(alpha = 0.05)
  )
  class(q) <- "statquiz_question"
  q
}

make_numeric_q <- function(solution = 0.5, tolerance = 1e-3) {
  q <- list(
    id          = "test_numeric",
    topic       = "probability",
    difficulty  = "easy",
    prompt      = "test",
    data        = NULL,
    answer_type = "numeric_scalar",
    solution    = solution,
    meta        = list(tolerance = tolerance)
  )
  class(q) <- "statquiz_question"
  q
}

make_label_q <- function(solution = "kruskal_wallis") {
  q <- list(
    id          = "test_label",
    topic       = "which_test",
    difficulty  = "easy",
    prompt      = "test",
    data        = NULL,
    answer_type = "label",
    solution    = solution,
    meta        = list(accepted_labels = c("kruskal_wallis", "kruskal-wallis",
                                           "kruskal wallis"))
  )
  class(q) <- "statquiz_question"
  q
}

# --- decision ---

test_that("correct decision returns TRUE", {
  expect_true(check_answer(make_decision_q("reject"), "reject"))
  expect_true(check_answer(make_decision_q("fail_to_reject"), "fail_to_reject"))
})

test_that("wrong decision returns FALSE", {
  expect_false(check_answer(make_decision_q("reject"), "fail_to_reject"))
})

test_that("invalid decision string errors", {
  expect_error(check_answer(make_decision_q(), "yes"), "reject")
})

# --- numeric ---

test_that("numeric within tolerance returns TRUE", {
  expect_true(check_answer(make_numeric_q(0.5), 0.5))
  expect_true(check_answer(make_numeric_q(0.5), 0.5009))
})

test_that("numeric outside tolerance returns FALSE", {
  expect_false(check_answer(make_numeric_q(0.5), 0.502))
})

test_that("non-numeric answer errors for numeric question", {
  expect_error(check_answer(make_numeric_q(), "half"), "numeric")
})

# --- label ---

test_that("correct label returns TRUE", {
  expect_true(check_answer(make_label_q(), "kruskal_wallis"))
})

test_that("accepted alias returns TRUE", {
  expect_true(check_answer(make_label_q(), "kruskal-wallis"))
  expect_true(check_answer(make_label_q(), "Kruskal-Wallis"))
})

test_that("wrong label returns FALSE", {
  expect_false(check_answer(make_label_q(), "one_way_anova"))
})

test_that("non-character label errors", {
  expect_error(check_answer(make_label_q(), 1L), "character")
})

# --- guard ---

test_that("non-statquiz_question input errors", {
  expect_error(check_answer(list(), "reject"), "statquiz_question")
})

# --- round-trip: solution always passes ---

test_that("check_answer(q, q$solution) is TRUE for every topic", {
  set.seed(99)
  topics <- c(
    "anova", "probability", "t_test", "t_test_two_sample",
    "t_test_paired", "correlation", "spearman", "which_test",
    "kruskal_wallis", "wilcoxon_rank_sum", "wilcoxon_signed_rank",
    "linear_regression", "chi_square", "fishers_exact", "welch_anova"
  )
  for (topic in topics) {
    q <- question(topic)
    expect_true(check_answer(q, q$solution),
                label = paste("round-trip for topic:", topic))
  }
})
