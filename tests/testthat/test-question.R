test_that("question() returns a statquiz_question for each topic", {
  set.seed(1)
  topics <- c(
    "anova", "probability", "t_test", "t_test_two_sample",
    "t_test_paired", "correlation", "spearman", "which_test",
    "kruskal_wallis", "wilcoxon_rank_sum", "wilcoxon_signed_rank",
    "linear_regression", "chi_square", "fishers_exact"
  )
  for (topic in topics) {
    q <- question(topic, "easy")
    expect_s3_class(q, "statquiz_question")
  }
})

test_that("question('random') returns a statquiz_question", {
  set.seed(1)
  q <- question("random")
  expect_s3_class(q, "statquiz_question")
})

test_that("question() sets topic and difficulty fields correctly", {
  set.seed(42)
  q <- question("anova", "hard")
  expect_equal(q$topic, "anova")
  expect_equal(q$difficulty, "hard")
})

test_that("question() errors on unknown topic", {
  expect_error(question("made_up"), "Unknown topic")
})

test_that("question() attaches a data frame for data-based topics", {
  set.seed(1)
  for (topic in c("anova", "t_test", "t_test_two_sample", "correlation")) {
    q <- question(topic)
    expect_true(is.data.frame(q$data))
  }
})

test_that("question() produces NULL data for which_test", {
  set.seed(1)
  q <- question("which_test")
  expect_null(q$data)
})

test_that("which_test easy difficulty only draws easy scenarios", {
  easy_ids <- c("one_way_anova", "pearson_correlation",
                "one_sample_t", "chi_square")
  set.seed(1)
  for (i in seq_len(30)) {
    q <- question("which_test", "easy")
    expect_true(q$meta$scenario_id %in% easy_ids)
  }
})

test_that("which_test hard difficulty only draws hard scenarios", {
  hard_ids <- c("wilcoxon_signed_rank", "fishers_exact", "mann_whitney_u")
  set.seed(2)
  for (i in seq_len(30)) {
    q <- question("which_test", "hard")
    expect_true(q$meta$scenario_id %in% hard_ids)
  }
})
