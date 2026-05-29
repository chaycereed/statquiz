\name{hint}
\alias{hint}
\title{Get a hint for a statquiz question}
\usage{
hint(question)
}
\arguments{
  \item{question}{A \code{"statquiz_question"} object returned by
    \code{\link{question}}.}
}
\value{
Invisibly returns \code{question}.
}
\description{
Prints a short nudge pointing you toward the right R function and key
considerations without revealing the answer or p-value. Call this when
you're stuck but not ready to see the full worked solution from
\code{\link{explain}}.
}
\examples{
\dontrun{
q <- question("t_test_paired", "medium")
hint(q)
}
}
