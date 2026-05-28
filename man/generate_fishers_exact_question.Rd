\name{generate_fishers_exact_question}
\alias{generate_fishers_exact_question}
\title{Internal: generate a Fisher's exact test question}
\usage{
generate_fishers_exact_question(difficulty = "medium", n_per_group = 12, alpha = 0.05)
}
\arguments{
  \item{difficulty}{Difficulty level: \code{"easy"}, \code{"medium"}, or
    \code{"hard"}. Controls the strength of association between group and
    outcome (odds ratio).}

  \item{n_per_group}{Number of participants per group (default 12). Kept
    small so that some expected cell counts fall below 5, making
    Fisher's exact test appropriate.}

  \item{alpha}{Significance level (default 0.05).}
}
\value{
A \code{"statquiz_question"} object with \code{topic = "fishers_exact"}
and \code{answer_type = "decision"}.
}
\description{
Generates a Fisher's exact test question using a small 2x2 contingency
table (group A/B by outcome Success/Failure). The student tests whether
group and outcome are independent using
\code{fisher.test(table(q$data$group, q$data$outcome))}.
}
\keyword{internal}
