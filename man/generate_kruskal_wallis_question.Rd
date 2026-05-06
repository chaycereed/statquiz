\name{generate_kruskal_wallis_question}
\alias{generate_kruskal_wallis_question}
\title{Internal: generate a Kruskal-Wallis test question}
\usage{
generate_kruskal_wallis_question(
  difficulty = "medium",
  n_per_group = 20,
  alpha = 0.05
)
}
\arguments{
  \item{difficulty}{One of \code{"easy"}, \code{"medium"}, or
    \code{"hard"}. Controls the location shift between groups.}
  \item{n_per_group}{Number of observations per group.}
  \item{alpha}{Significance level for the hypothesis test.}
}
\value{
A \code{"statquiz_question"} object.
}
\description{
Generates a Kruskal-Wallis question with three groups (A, B, C) drawn
from shifted exponential distributions. The user tests whether the
distributions differ across groups.
}
\keyword{internal}
