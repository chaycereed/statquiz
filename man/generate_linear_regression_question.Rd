\name{generate_linear_regression_question}
\alias{generate_linear_regression_question}
\title{Internal: generate a simple linear regression question}
\usage{
generate_linear_regression_question(
  difficulty = "medium",
  n = 50,
  alpha = 0.05
)
}
\arguments{
  \item{difficulty}{One of \code{"easy"}, \code{"medium"}, or
    \code{"hard"}. Controls the strength of the linear relationship
    between x and y.}
  \item{n}{Number of observations.}
  \item{alpha}{Significance level for the hypothesis test.}
}
\value{
A \code{"statquiz_question"} object.
}
\description{
Generates a simple linear regression question with columns \code{x}
and \code{y}. The user fits \code{lm(y ~ x)} and tests whether x is
a significant predictor of y (H0: beta_1 = 0).
}
\keyword{internal}
