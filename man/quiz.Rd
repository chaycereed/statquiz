\name{quiz}
\alias{quiz}
\title{Start a multi-question quiz session}
\usage{
quiz(n = 5, topics = "all", difficulty = "medium")
}
\arguments{
  \item{n}{Number of questions to generate.}

  \item{topics}{Character vector of topics to draw from, or \code{"all"}
    to include every available topic.}

  \item{difficulty}{Difficulty level passed to each question generator.
    One of \code{"easy"}, \code{"medium"}, or \code{"hard"}.}
}
\value{
A \code{"statquiz_quiz"} environment. Pass it to
\code{\link{check_answer}} to record each answer, and call
\code{\link{score}} when finished.
}
\description{
Generates a sequence of randomized questions and tracks your answers as
you work through them. The quiz object prints the current question
automatically when typed at the console.
}
\examples{
\dontrun{
library(statquiz)

qz <- quiz(n = 3, difficulty = "easy")
qz  # prints Question 1 of 3

# Solve question 1, then submit:
check_answer(qz, "reject")

# Continue for questions 2 and 3, then see results:
score(qz)
}
}
