\name{topics}
\alias{topics}
\title{List all available question topics}
\usage{
topics()
}
\value{
Invisibly returns a data frame with columns \code{topic},
\code{description}, and \code{answer_type}.
}
\description{
Prints a formatted table of every topic supported by \code{\link{question}},
including its canonical name, a short description, and the answer type it
expects.
}
\examples{
\dontrun{
topics()
}
}
