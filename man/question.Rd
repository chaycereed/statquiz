\name{question}
\alias{question}
\title{Generate a new statquiz question}
\usage{
question(topic, difficulty = "medium", ...)
}
\arguments{
  \item{topic}{
    A character string specifying the topic, e.g. \code{"anova"},
    \code{"probability"}, \code{"t_test"}, \code{"t_test_two_sample"},
    \code{"correlation"}, \code{"spearman"}, or \code{"which_test"}.
    Some aliases are also supported (see Details).
  }

  \item{difficulty}{
    A character string indicating difficulty level, such as
    \code{"easy"}, \code{"medium"}, or \code{"hard"}. Interpretation
    depends on the topic but typically controls effect size or signal
    strength.
  }

  \item{...}{
    Additional arguments passed to the internal generator for the given
    topic.
  }
}
\value{
A \code{"statquiz_question"} object containing the generated question.
It is a list with components such as \code{prompt}, \code{data},
\code{answer_type}, \code{solution}, and \code{meta}.
}
\description{
\code{question()} creates a randomized statistics practice question that
you answer using real R code in your IDE. You then check your answer
with \code{\link{check_answer}}. The question object always includes a
prompt, data (if needed), the expected answer type, and metadata such as
alpha.
}
\details{
Supported topics currently include:

\itemize{
  \item \strong{\code{"anova"}}:
  One-way ANOVA with three groups (A, B, C). You decide whether to
  \code{"reject"} or \code{"fail_to_reject"} the null of equal means.

  \item \strong{\code{"probability"}}:
  A basic probability question (e.g., probability of an event when
  rolling a die). You return a numeric probability. These questions use
  \code{answer_type = "numeric_scalar"}.

  \item \strong{\code{"t_test"}}, \strong{\code{"ttest"}},
  \strong{\code{"one_sample_t"}}:
  One-sample t-test on a single numeric vector \code{x}. You test
  whether the mean differs from a specified null value and return
  \code{"reject"} or \code{"fail_to_reject"}.

  \item \strong{\code{"t_test_two_sample"}},
  \strong{\code{"two_sample_t"}}, \strong{\code{"t_test2"}}:
  Two-sample t-test with groups A and B in columns \code{y} and
  \code{group}. Depending on settings, this can correspond to an
  equal-variance (pooled) t-test or Welch's t-test. You return
  \code{"reject"} or \code{"fail_to_reject"}.

  \item \strong{\code{"correlation"}}, \strong{\code{"corr"}},
  \strong{\code{"pearson"}}, \strong{\code{"pearson_correlation"}}:
  Pearson correlation between \code{x} and \code{y}. You test whether
  the true correlation is non-zero (or greater/less than 0 depending on
  the alternative) and return \code{"reject"} or \code{"fail_to_reject"}.

  \item \strong{\code{"spearman"}},
  \strong{\code{"spearman_correlation"}}:
  Spearman rank correlation between \code{x} and \code{y}. As with
  Pearson, you test whether the correlation is non-zero and return
  \code{"reject"} or \code{"fail_to_reject"}.

  \item \strong{\code{"which_test"}},
  \strong{\code{"test_choice"}},
  \strong{\code{"which"}}:
  Conceptual questions that describe a scenario (e.g., comparing
  groups, small-sample contingency tables, skewed ordinal outcomes) and
  ask which statistical test is most appropriate. You return a label
  such as \code{"one_way_anova"}, \code{"welch_anova"},
  \code{"kruskal_wallis"}, \code{"pearson_correlation"},
  \code{"spearman_correlation"}, \code{"one_sample_t"},
  \code{"wilcoxon_signed_rank"}, \code{"chi_square"},
  \code{"fishers_exact"}, \code{"two_sample_t_equal_var"},
  \code{"two_sample_t_welch"}, or \code{"mann_whitney_u"}.
  These use \code{answer_type = "label"}.
}
}
\examples{
\dontrun{
library(statquiz)

## One-way ANOVA
q_anova <- question("anova", "easy")
cat(q_anova$prompt, "\n")

## One-sample t-test
q_t1 <- question("t_test", "easy")
cat(q_t1$prompt, "\n")
head(q_t1$data)

## Two-sample t-test
q_t2 <- question("t_test_two_sample", "medium")
cat(q_t2$prompt, "\n")
table(q_t2$data$group)

## Pearson correlation
q_corr_p <- question("correlation", "easy")
cat(q_corr_p$prompt, "\n")
head(q_corr_p$data)

## Spearman correlation
q_corr_s <- question("spearman", "medium")
cat(q_corr_s$prompt, "\n")

## Probability
q_prob <- question("probability", "easy")
cat(q_prob$prompt, "\n")

## Which-test (scenario-based)
q_which <- question("which_test", "easy")
cat(q_which$prompt, "\n")
}
}