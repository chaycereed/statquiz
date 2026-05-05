\name{generate_ttest_paired_question}
\alias{generate_ttest_paired_question}
\title{Internal: generate a paired t-test question}
\usage{
generate_ttest_paired_question(
  difficulty = "medium",
  n = 25,
  alpha = 0.05,
  alternative = "two.sided"
)
}
\arguments{
  \item{difficulty}{One of \code{"easy"}, \code{"medium"}, or
    \code{"hard"}. Controls the magnitude of the mean difference
    (before - after).}
  \item{n}{Number of paired observations.}
  \item{alpha}{Significance level for the hypothesis test.}
  \item{alternative}{One of \code{"two.sided"}, \code{"greater"}, or
    \code{"less"}.}
}
\value{
A \code{"statquiz_question"} object.
}
\description{
Generates a paired t-test question with \code{before} and \code{after}
columns. The user tests whether the mean difference (before - after)
differs from zero at the specified significance level.
}
\keyword{internal}
