# statquiz

An R package for practicing statistics interactively inside your IDE.

<video src="https://github.com/user-attachments/assets/646c7a0c-1e8b-4292-a01e-291e08f060a5"
       width="750"
       autoplay
       loop
       muted>
</video>

## Features

- Randomized questions built from real simulated data
- Three difficulty levels: `"easy"`, `"medium"`, and `"hard"`
- Immediate feedback when you check your answer
- Hints via `hint()` when you're stuck, without revealing the answer
- Worked solutions via `explain()` showing the correct R code and p-value
- Quiz mode via `quiz()` for scored multi-question sessions
- `topics()` to browse all available topics at a glance
- Pass `"random"` as the topic to draw from any topic at random
- Supported topics:
  - One-way ANOVA
  - Basic probability (die rolls, coin flips, two-dice sums)
  - One-sample t-test
  - Two-sample t-test (equal-variance and Welch's)
  - Paired t-test
  - Pearson and Spearman correlation
  - Kruskal-Wallis test
  - Wilcoxon rank-sum test (Mann-Whitney U)
  - Wilcoxon signed-rank test
  - Simple linear regression
  - Chi-square test of independence
  - Fisher's exact test
  - "Which test?" scenario questions covering 12 statistical tests

## Installation

Requires R 4.0 or higher. Install directly from GitHub:

```r
devtools::install_github("chaycereed/statquiz")
```

Then load it:

```r
library(statquiz)
```

## Usage

### Browse available topics

Call `topics()` to print all supported topics with their descriptions and
expected answer types:

```r
topics()
```

### Generate and solve a question

Call `question()` with a topic and an optional difficulty. The question prints
automatically and includes a prompt and, for most topics, an attached data frame
accessible via `q$data`.

```r
q <- question("anova", "easy")
q
```

Solve it using standard R functions, then pass your answer to `check_answer()`:

```r
fit <- aov(y ~ group, data = q$data)
p   <- summary(fit)[[1]][["Pr(>F)"]][1]
check_answer(q, ifelse(p < q$meta$alpha, "reject", "fail_to_reject"))
```

### Probability questions

Probability questions ask for a numeric answer rather than a hypothesis-test
decision:

```r
q <- question("probability", "easy")
q
check_answer(q, 2/6)
```

### Which-test questions

Which-test questions describe a scenario and ask you to name the most
appropriate statistical test:

```r
q <- question("which_test", "medium")
q
check_answer(q, "kruskal_wallis")
```

Accepted labels include `"one_way_anova"`, `"welch_anova"`, `"kruskal_wallis"`,
`"pearson_correlation"`, `"spearman_correlation"`, `"one_sample_t"`,
`"wilcoxon_signed_rank"`, `"chi_square"`, `"fishers_exact"`,
`"two_sample_t_equal_var"`, `"two_sample_t_welch"`, and `"mann_whitney_u"`.

### Quiz mode

`quiz()` generates a sequence of questions and tracks your answers as you work
through them. Call `score()` when finished to see your results.

```r
qz <- quiz(n = 5, difficulty = "medium")
qz
```

Solve the current question using its data, then submit with `check_answer()`.
The quiz advances automatically and prints the next question:

```r
q1 <- qz$questions[[1]]
fit <- aov(y ~ group, data = q1$data)
p   <- summary(fit)[[1]][["Pr(>F)"]][1]
check_answer(qz, ifelse(p < q1$meta$alpha, "reject", "fail_to_reject"))
```

After all questions are answered:

```r
score(qz)
```

### Hints

If you're stuck, call `hint()` to get a nudge toward the right approach
without seeing the full solution:

```r
q <- question("wilcoxon_signed_rank", "hard")
hint(q)
```

### Worked solutions

Call `explain()` on any question to see the correct R code, the computed
p-value or probability, and the reasoning behind the answer:

```r
q <- question("t_test_paired", "hard")
q
explain(q)
```

`explain()` works for every topic and can be called before or after submitting
an answer.

## License

MIT License. See `LICENSE` for details.
