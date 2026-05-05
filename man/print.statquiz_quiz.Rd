\name{print.statquiz_quiz}
\alias{print.statquiz_quiz}
\title{Print a statquiz quiz}
\usage{
\method{print}{statquiz_quiz}(x, ...)
}
\arguments{
  \item{x}{A \code{"statquiz_quiz"} object returned by
    \code{\link{quiz}}.}
  \item{...}{Currently unused.}
}
\value{
Invisibly returns \code{x}.
}
\description{
Shows the current question and progress indicator. Once all questions
have been answered, prompts you to call \code{\link{score}}.
}
\examples{
\dontrun{
library(statquiz)
qz <- quiz(5)
qz  # prints Question 1 of 5
}
}
