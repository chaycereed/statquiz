\name{score}
\alias{score}
\title{Show quiz results}
\usage{
score(quiz)
}
\arguments{
  \item{quiz}{A \code{"statquiz_quiz"} object returned by
    \code{\link{quiz}}.}
}
\value{
Invisibly returns \code{quiz}.
}
\description{
Prints a score summary and a per-question breakdown after completing a
quiz session. For incorrect answers, shows what you submitted alongside
the correct answer.
}
\examples{
\dontrun{
library(statquiz)

qz <- quiz(n = 3, difficulty = "easy")

# Answer all questions via check_answer(), then:
score(qz)
}
}
