#' statquiz: Interactive statistics practice inside your R IDE
#'
#' @description
#' `statquiz` is a teaching and practice toolkit for statistics, designed to
#' be used entirely inside the R environment. Generate a randomized question
#' with [question()], solve it using real R code (e.g., `aov()`, `t.test()`,
#' `cor.test()`), and check your work with [check_answer()]. For multi-question
#' sessions, use [quiz()] and [score()]. To see the worked solution for any
#' question, call [explain()].
#'
#' It is intended for students, self-learners, and instructors who want
#' hands-on practice with core statistical ideas rather than multiple-choice
#' questions. All questions are built around real data objects and standard
#' R workflows.
#'
#' @section Topics:
#'
#' Supported topics include:
#'
#' - **One-way ANOVA**: compare means across three groups.
#' - **Probability**: basic probability questions with numeric answers.
#' - **One-sample t-test**: test a single mean against a null value.
#' - **Two-sample t-test**: compare two independent groups, with support for
#'   equal-variance and Welch-style settings.
#' - **Paired t-test**: test whether the mean difference between paired
#'   before/after measurements differs from zero.
#' - **Correlation**:
#'   - Pearson correlation for approximately linear, normal data.
#'   - Spearman rank correlation for monotonic or non-normal data.
#' - **Simple linear regression**: test whether x is a significant predictor
#'   of y (H0: beta_1 = 0) using `lm()`.
#' - **Kruskal-Wallis test**: non-parametric comparison of 3+ independent
#'   groups with skewed or ordinal data.
#' - **Wilcoxon rank-sum test**: non-parametric comparison of two independent
#'   groups (Mann-Whitney U equivalent).
#' - **Wilcoxon signed-rank test**: non-parametric paired test for skewed
#'   before/after differences.
#' - **Chi-square test of independence**: two categorical variables (group A/B
#'   and outcome Low/Medium/High); test with
#'   `chisq.test(table(q$data$group, q$data$outcome))`.
#' - **Fisher's exact test**: small 2x2 table (group A/B by Success/Failure)
#'   where expected cell counts fall below 5; test with `fisher.test()`.
#' - **Which test?**: scenario-based questions where you choose the most
#'   appropriate test (one-way ANOVA, Welch's ANOVA, Kruskal-Wallis,
#'   Pearson/Spearman correlation, one-sample t-test, Wilcoxon signed-rank,
#'   chi-square, Fisher's exact, equal-variance two-sample t, Welch's t, or
#'   Wilcoxon rank-sum / Mann-Whitney U).
#' - **Random**: pass `"random"` to draw a topic at random.
#'
#' Call [topics()] at any time to print a table of all available topics,
#' their descriptions, and expected answer types.
#'
#' @section Basic workflow:
#'
#' \enumerate{
#'   \item Call [question()] with a topic, e.g. `question("anova")`.
#'   \item Inspect the prompt and any attached data (e.g. `q$data`).
#'   \item If stuck, call [hint()] for a nudge toward the right R function.
#'   \item Solve the question using base R functions such as `aov()`,
#'         `t.test()`, or `cor.test()`.
#'   \item Convert your result to the required answer format:
#'         - `"reject"` / `"fail_to_reject"` for decision questions.
#'         - A single numeric value for probability questions.
#'         - A test label (e.g. `"kruskal_wallis"`) for which-test questions.
#'   \item Pass your answer to [check_answer()] to see if it matches the
#'         hidden solution.
#'   \item Optionally call [explain()] to see the worked solution.
#' }
#'
#' @section Quiz mode:
#'
#' \preformatted{
#'   qz <- quiz(n = 5, difficulty = "medium")
#'   qz  # prints Question 1 of 5
#'
#'   # Solve and submit each question:
#'   check_answer(qz, "reject")
#'
#'   # See final results:
#'   score(qz)
#' }
#'
#' @section Getting started:
#'
#' \preformatted{
#'   library(statquiz)
#'
#'   # Generate an ANOVA question
#'   q <- question("anova", "easy")
#'   q
#'
#'   # Solve and check
#'   fit <- aov(y ~ group, data = q$data)
#'   p   <- summary(fit)[[1]][["Pr(>F)"]][1]
#'   ans <- ifelse(p < q$meta$alpha, "reject", "fail_to_reject")
#'   check_answer(q, ans)
#'
#'   # See the worked solution
#'   explain(q)
#' }
#'
#' @docType package
#' @name statquiz
NULL
