\name{generate_wilcoxon_rank_sum_question}
\alias{generate_wilcoxon_rank_sum_question}
\title{Internal: generate a Wilcoxon rank-sum question}
\usage{
generate_wilcoxon_rank_sum_question(
  difficulty = "medium",
  n_per_group = 30,
  alpha = 0.05,
  alternative = "two.sided"
)
}
\arguments{
  \item{difficulty}{One of \code{"easy"}, \code{"medium"}, or
    \code{"hard"}. Controls the location shift between groups.}
  \item{n_per_group}{Number of observations per group.}
  \item{alpha}{Significance level for the hypothesis test.}
  \item{alternative}{One of \code{"two.sided"}, \code{"greater"}, or
    \code{"less"}.}
}
\value{
A \code{"statquiz_question"} object.
}
\description{
Generates a Wilcoxon rank-sum (Mann-Whitney U) question with two
independent groups (A and B) drawn from shifted exponential
distributions. The user tests whether the location of y differs
between groups.
}
\keyword{internal}
