test_that("quiz() generates the right number of questions", {
  set.seed(1)
  qz <- quiz(4)
  expect_equal(qz$n, 4L)
  expect_length(qz$questions, 4)
})

test_that("quiz() only draws from specified topics", {
  set.seed(1)
  qz <- quiz(10, topics = c("anova", "probability"))
  for (q in qz$questions) {
    expect_true(q$topic %in% c("anova", "probability"))
  }
})

test_that("print.statquiz_quiz shows current question", {
  set.seed(1)
  qz <- quiz(2)
  expect_output(print(qz), "Question 1 of 2")
})

test_that("check_answer on quiz advances current and records result", {
  set.seed(1)
  qz <- quiz(3)
  expect_equal(qz$current, 1L)

  sol <- qz$questions[[1]]$solution
  check_answer(qz, sol)

  expect_equal(qz$current, 2L)
  expect_true(qz$correct[[1]])
})

test_that("check_answer on quiz records FALSE for wrong answer", {
  set.seed(1)
  qz <- quiz(2)

  # Deliberately submit a wrong decision answer
  wrong <- if (qz$questions[[1]]$solution == "reject") {
    "fail_to_reject"
  } else {
    "reject"
  }

  # only works if question 1 is a decision type
  if (qz$questions[[1]]$answer_type == "decision") {
    check_answer(qz, wrong)
    expect_false(qz$correct[[1]])
  } else {
    skip("Q1 is not a decision question in this seed")
  }
})

test_that("score() reports correct totals after full quiz", {
  set.seed(42)
  qz <- quiz(3)

  for (i in seq_len(3)) {
    check_answer(qz, qz$questions[[i]]$solution)
  }

  expect_output(score(qz), "Score: 3 / 3")
})

test_that("check_answer errors when quiz is already complete", {
  set.seed(1)
  qz <- quiz(1)
  check_answer(qz, qz$questions[[1]]$solution)

  expect_error(check_answer(qz, "reject"), "complete")
})
