\name{check_answer}
\alias{check_answer}
\title{Check a user's answer to a statquiz question}
\usage{
check_answer(question, user_answer)
}
\arguments{
  \item{question}{
    A \code{"statquiz_question"} object returned by \code{\link{question}}.
  }

  \item{user_answer}{
    The user's answer. For decision-type questions, this should be
    \code{"reject"} or \code{"fail_to_reject"}. For numeric questions,
    this should be a single numeric value. For label questions, this
    should be a single character string naming the test.
  }
}
\value{
Invisibly returns \code{TRUE} if the answer is correct and
\code{FALSE} otherwise, and prints a short message indicating
correctness.
}
\description{
After generating a question with \code{\link{question}}, you solve it
using R and then pass your answer to \code{check_answer()} to see if it
matches the hidden solution.
}
\details{
\code{check_answer()} supports multiple answer types, controlled by the
\code{answer_type} field of the \code{"statquiz_question"} object:

\itemize{
  \item \strong{Decision questions} (\code{answer_type = "decision"}):
  You return \code{"reject"} or \code{"fail_to_reject"}. These are used
  for topics such as ANOVA, one-sample and two-sample t-tests, and
  correlation tests (Pearson and Spearman).

  \item \strong{Numeric questions} (\code{answer_type = "numeric_scalar"}):
  You return a single numeric value (e.g., a probability). These are
  used for basic probability questions and can be used by future
  numeric topics. Correctness is checked within a small tolerance
  (stored in \code{question$meta$tolerance} if provided).

  \item \strong{Label questions} (\code{answer_type = "label"}):
  You return a character string naming the appropriate statistical test.
  These are used by the \code{"which_test"} topic, where you choose
  between tests such as one-way ANOVA, Welch's ANOVA, Kruskal-Wallis,
  Pearson correlation, Spearman correlation, one-sample t-test,
  Wilcoxon signed-rank test, chi-square test, Fisher's exact test,
  equal-variance two-sample t-test, Welch's t-test, or the
  Wilcoxon rank-sum / Mann-Whitney U test. The question object contains
  a canonical label and a set of accepted labels/aliases, and your
  answer is normalized before comparison.
}
}
\examples{
\dontrun{
library(statquiz)

## ANOVA (decision)
q_anova <- question("anova", "easy")
fit <- aov(y ~ group, data = q_anova$data)
p <- summary(fit)[[1]][["Pr(>F)"]][1]
ans_anova <- ifelse(p < q_anova$meta$alpha, "reject", "fail_to_reject")
check_answer(q_anova, ans_anova)

## One-sample t-test (decision)
q_t1 <- question("t_test", "easy")
tt1 <- t.test(q_t1$data$x, mu = q_t1$meta$mu0,
              alternative = q_t1$meta$alternative)
ans_t1 <- ifelse(tt1$p.value < q_t1$meta$alpha, "reject", "fail_to_reject")
check_answer(q_t1, ans_t1)

## Correlation (Pearson or Spearman, decision)
q_corr <- question("correlation", "easy")
ct <- cor.test(q_corr$data$x, q_corr$data$y,
               alternative = q_corr$meta$alternative,
               method      = q_corr$meta$method)
ans_corr <- ifelse(ct$p.value < q_corr$meta$alpha, "reject", "fail_to_reject")
check_answer(q_corr, ans_corr)

## Probability (numeric)
q_prob <- question("probability", "easy")
check_answer(q_prob, 2/6)

## Which-test (label)
q_which <- question("which_test", "easy")
cat(q_which$prompt, "\n")

## Suppose you believe the correct test is Kruskal-Wallis:
check_answer(q_which, "kruskal_wallis")
}
}