\name{generate_wilcoxon_signed_rank_question}
\alias{generate_wilcoxon_signed_rank_question}
\title{Internal: generate a Wilcoxon signed-rank test question}
\usage{
generate_wilcoxon_signed_rank_question(
  difficulty = "medium",
  n = 25,
  alpha = 0.05,
  alternative = "two.sided"
)
}
\arguments{
  \item{difficulty}{One of \code{"easy"}, \code{"medium"}, or
    \code{"hard"}. Controls the magnitude of the paired difference.}
  \item{n}{Number of paired observations.}
  \item{alpha}{Significance level for the hypothesis test.}
  \item{alternative}{One of \code{"two.sided"}, \code{"greater"}, or
    \code{"less"}.}
}
\value{
A \code{"statquiz_question"} object.
}
\description{
Generates a paired Wilcoxon signed-rank question with \code{before}
and \code{after} columns drawn from skewed distributions. The user
tests whether the median difference (before - after) differs from zero.
}
\keyword{internal}
