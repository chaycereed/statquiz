\name{print.statquiz_question}
\alias{print.statquiz_question}
\title{Print a statquiz question}
\usage{
\method{print}{statquiz_question}(x, ...)
}
\arguments{
  \item{x}{A \code{"statquiz_question"} object returned by
    \code{\link{question}}.}
  \item{...}{Currently unused.}
}
\value{
Invisibly returns \code{x}.
}
\description{
Displays the question prompt and, for data-bearing topics, a one-line
summary of the attached data frame. Called automatically when a
\code{"statquiz_question"} object is typed at the console.
}
\examples{
\dontrun{
library(statquiz)
q <- question("anova", "easy")
q  # prints prompt + data summary
}
}
