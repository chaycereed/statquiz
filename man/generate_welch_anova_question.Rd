\name{generate_welch_anova_question}
\alias{generate_welch_anova_question}
\title{Internal: generate a Welch's one-way ANOVA question}
\usage{
generate_welch_anova_question(difficulty = "medium", n_per_group = 25, alpha = 0.05)
}
\arguments{
  \item{difficulty}{Difficulty level: \code{"easy"}, \code{"medium"}, or
    \code{"hard"}. Controls the separation between group means.}

  \item{n_per_group}{Number of observations per group (default 25).}

  \item{alpha}{Significance level (default 0.05).}
}
\value{
A \code{"statquiz_question"} object with \code{topic = "welch_anova"}
and \code{answer_type = "decision"}.
}
\description{
Generates a Welch's one-way ANOVA question with three groups (A, B, C)
that have substantially different standard deviations, making the
classical equal-variance ANOVA inappropriate. The student runs
\code{oneway.test(y ~ group, data = q$data, var.equal = FALSE)}.
}
\keyword{internal}
