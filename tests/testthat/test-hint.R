test_that("hint() runs without error for every topic", {
  set.seed(1)
  topics <- c(
    "anova", "probability", "t_test", "t_test_two_sample",
    "t_test_paired", "correlation", "spearman", "which_test",
    "kruskal_wallis", "wilcoxon_rank_sum", "wilcoxon_signed_rank",
    "linear_regression", "chi_square", "fishers_exact"
  )
  for (topic in topics) {
    q <- question(topic)
    expect_error(hint(q), NA, label = paste("hint for topic:", topic))
  }
})

test_that("hint() errors on non-statquiz_question input", {
  expect_error(hint(list()), "statquiz_question")
})

test_that("hint() returns question invisibly", {
  set.seed(1)
  q      <- question("anova")
  result <- capture.output(ret <- hint(q))
  expect_identical(ret, q)
})

test_that("hint() produces output for all probability subtypes", {
  set.seed(1)
  for (i in seq_len(20)) {
    q <- question("probability", "medium")
    expect_error(hint(q), NA)
  }
})
