# statquiz

Welcome to **statquiz** — a tiny, friendly R package that turns your IDE into a personal stats training ground.

`statquiz` gives you **randomized statistical questions**, you solve them using real R code, and the package checks your work.  
No multiple choice. No guessing. Just *you*, your code, and a clean statistical workflow.

<br />

## 🚀 What statquiz can do today

statquiz now supports **a full set of core intro–intermediate statistics question types**:

### ✔ One-way ANOVA  
Classic three‑group ANOVA with real simulated data and decision-based answers.

### ✔ Basic probability  
Lightweight numeric questions (like dice rolls or simple events).

### ✔ One-sample t-tests  
Practice testing a mean against a null value using real data.

### ✔ Two-sample t-tests  
Both:
- Equal‑variance (pooled)  
- Welch’s t-test (unequal variance)

### ✔ Pearson & Spearman correlation  
You decide whether the relationship is statistically significant.  
Both correlation types are fully supported.

### ✔ “Which test should I use?” questions  
Scenario-based conceptual prompts where you must choose the correct statistical test.  
Includes:
- One-way ANOVA  
- Welch’s ANOVA  
- Kruskal–Wallis  
- Pearson correlation  
- Spearman correlation  
- One-sample t-test  
- Wilcoxon signed-rank  
- Chi-square  
- Fisher’s exact  
- Two-sample t-test (equal or unequal variance)  
- Wilcoxon rank-sum / Mann–Whitney U test  

This makes statquiz a **full-spectrum practice toolkit** — both computational *and* conceptual.

<br />

## 📦 Installation

```r
devtools::install_github("chaycereed/statquiz")
```

Then load it:

```r
library(statquiz)
```

<br />

## 📝 Examples

### Example #1: One-way ANOVA

```r
q <- question("anova", "easy")
cat(q$prompt)
```

It will look like:

```
Topic: One-way ANOVA (easy)

You have three groups (A, B, C).
Test whether mean y differs across groups at alpha = 0.05.

Return your decision as either 'reject' or 'fail_to_reject'.
```

Solve it:

```r
fit <- aov(y ~ group, data = q$data)
p <- summary(fit)[[1]][["Pr(>F)"]][1]
user_answer <- ifelse(p < q$meta$alpha, "reject", "fail_to_reject")
check_answer(q, user_answer)
```

---

### Example #2: Probability

```r
q <- question("probability", "easy")
cat(q$prompt)
```

Example prompt:

```
Topic: Basic probability (easy)

You roll a fair 6-sided die once.
What is the probability the outcome is in {1, 2}?
```

Solution:

```r
user_answer <- 2/6
check_answer(q, user_answer)
```

---

### Example #3: Which-test scenario

```r
q <- question("which_test", "easy")
cat(q$prompt)
```

Prompt (example):

```
Which statistical test is most appropriate?

You compare an ordinal 1–5 pain rating across four independent treatments.
Data are skewed with clear outliers.

Return the test name as a string.
```

You choose:

```r
check_answer(q, "kruskal_wallis")
```

<br />

## 📅 What's coming next

- Normal distribution & z-scores  
- Binomial distribution  
- Central Limit Theorem sampling demos  
- Regression basics  
- Paired tests  
- Effect sizes  
- A future Shiny interface  

<br />

## 🤝 Contribute, criticize, suggest

This project is tiny, but that’s the fun part — it can grow in any direction.  
PRs and suggestions are always welcome.

<br />

## 📜 License

MIT License. See `LICENSE` for details.
