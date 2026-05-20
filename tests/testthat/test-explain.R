test_that("explain() runs without error for every topic", {
  set.seed(1)
  topics <- c(
    "anova", "probability", "t_test", "t_test_two_sample",
    "t_test_paired", "correlation", "spearman", "which_test",
    "kruskal_wallis", "wilcoxon_rank_sum", "wilcoxon_signed_rank",
    "linear_regression", "chi_square"
  )
  for (topic in topics) {
    q <- question(topic)
    expect_error(explain(q), NA, label = paste("explain for topic:", topic))
  }
})

test_that("explain() errors on non-statquiz_question input", {
  expect_error(explain(list()), "statquiz_question")
})

test_that("explain() returns question invisibly", {
  set.seed(1)
  q <- question("anova")
  result <- capture.output(ret <- explain(q))
  expect_identical(ret, q)
})

test_that("explain() produces output for all probability subtypes", {
  set.seed(1)
  # Run enough times to hit all three subtypes
  for (i in seq_len(20)) {
    q <- question("probability", "medium")
    expect_error(explain(q), NA)
  }
})
