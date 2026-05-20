\name{generate_chi_square_question}
\alias{generate_chi_square_question}
\title{Internal: generate a chi-square test of independence question}
\usage{
generate_chi_square_question(difficulty = "medium", n_per_group = 60, alpha = 0.05)
}
\arguments{
  \item{difficulty}{Difficulty level: \code{"easy"}, \code{"medium"}, or
    \code{"hard"}. Controls how strongly the two categorical variables
    are associated.}

  \item{n_per_group}{Number of observations in each group (default 60).}

  \item{alpha}{Significance level (default 0.05).}
}
\value{
A \code{"statquiz_question"} object with \code{topic = "chi_square"}
and \code{answer_type = "decision"}.
}
\description{
Generates a chi-square test of independence question. Two independent
groups (A and B) are surveyed on an ordinal outcome (Low / Medium / High).
The student tests whether exercise frequency is independent of group
membership using \code{chisq.test(table(q$data$group, q$data$outcome))}.
}
\keyword{internal}
