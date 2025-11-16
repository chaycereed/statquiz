# statquiz

Welcome to **statquiz** — a tiny, friendly R package that turns your IDE into a personal stats training ground.

If you've ever wished you could drill statistics the same way you'd practice piano scales or coding interview questions, this is exactly that… but way more fun.

`statquiz` gives you **randomized statistical questions**, you solve them using real R code, and then the package tells you whether you nailed it or not. No multiple choice. No guessing. Just *you*, your brain, and your IDE.


@# 🚀 What statquiz can do today

Right now, statquiz supports two kinds of questions:

### ✔ **One-way ANOVA questions**
You'll get:
- Randomly simulated data  
- A simple prompt asking whether to reject or fail to reject  
- A clean R-based workflow to solve it  

You run the ANOVA yourself — no shortcuts.

### ✔ **Basic probability questions**
Straightforward probability tasks (like dice rolls).  
Perfect warmups or quick confidence builders.

More topics are being added soon — t-tests, normal distributions, correlation, CLT, everything you'd see in an introductory stats sequence.


## 📦 Installation

```r
devtools::install_github("chaycereed/statquiz")
```

Then load it:

```r
library(statquiz)
```


## Examples
### 🧠 Example #1: ANOVA Practice

You ask for a question:

```r
q <- question("anova", "easy")
cat(q$prompt)
```

It will look something like:

```
Topic: One-way ANOVA (easy)

You have three groups (A, B, C).
Test whether mean y differs across groups at alpha = 0.05.

Return your decision as either 'reject' or 'fail_to_reject'.
```

Now you solve it:

```r
fit <- aov(y ~ group, data = q$data)
summary(fit)

p <- summary(fit)[[1]][["Pr(>F)"]][1]
user_answer <- ifelse(p < q$meta$alpha, "reject", "fail_to_reject")
```

Then check your work:

```r
check_answer(q, user_answer)
```

If you're right:

```
✅ Correct!
```

If not… you’ll know it:

```
❌ Not quite.
You answered:   fail_to_reject
Correct answer: reject
```

---

### 🎲 Example #2: Probability

```r
q <- question("probability", "easy")
cat(q$prompt)
```

Example:

```
Topic: Basic probability (easy)

You roll a fair 6-sided die once.
What is the probability the outcome is in {1, 2}?
```

Solve it:

```r
user_answer <- 2/6
check_answer(q, user_answer)
```

---

## 📅 What's coming next

Upcoming topics include:

- Binomial distribution  
- Normal distribution & z-scores  
- Central Limit Theorem  
- One/two-sample t-tests  
- Pearson/Spearman correlation  
- Regression basics  
- Hypothesis testing scenarios  
- Interpretation-only questions (“Which test should you use?”)

---

## 🤝 Contribute, criticize, suggest

This project is tiny, but that’s the fun part — it can grow in any direction.

If you have:
- question ideas  
- new topics  
- improvements  
- or want to help with code  

…go for it. PRs and suggestions are always welcome.

---

## 📜 License

MIT © Your Name
