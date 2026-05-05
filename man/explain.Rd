\name{explain}
\alias{explain}
\title{Show the worked solution for a statquiz question}
\usage{
explain(question)
}
\arguments{
  \item{question}{A \code{"statquiz_question"} object returned by
    \code{\link{question}}.}
}
\value{
Invisibly returns \code{question}.
}
\description{
After attempting a question, call \code{explain()} to see the correct R
code, the computed test statistic or probability, and the reasoning behind
the answer. Works for all topics: ANOVA, t-tests (one-sample, two-sample,
paired), correlation, probability, and which-test scenarios.
}
\examples{
\dontrun{
library(statquiz)

q <- question("anova", "easy")
q

fit <- aov(y ~ group, data = q$data)
p   <- summary(fit)[[1]][["Pr(>F)"]][1]
check_answer(q, ifelse(p < q$meta$alpha, "reject", "fail_to_reject"))

explain(q)
}
}
