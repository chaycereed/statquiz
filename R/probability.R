#' Internal: generate a basic probability question
#'
#' @keywords internal
generate_probability_question <- function(
  difficulty = "easy"
) {
  difficulty <- tolower(difficulty)

  # Helper to build all possible scenarios
  scenarios <- list(

    # 1) Single die, subset of outcomes (like your original example)
    die_subset = function() {
      sides <- 6L
      # random event size between 1 and 5
      k <- sample.int(5L, size = 1L)
      event <- sort(sample.int(sides, size = k, replace = FALSE))

      prompt_text <- paste0(
        "You roll a fair ", sides, "-sided die once.\n",
        "What is the probability the outcome is in {",
        paste(event, collapse = ", "), "}?\n\n",
        "Return your answer as a numeric probability."
      )

      true_prob <- length(event) / sides

      list(
        prompt   = prompt_text,
        solution = true_prob,
        meta     = list(
          type      = "die_single",
          sides     = sides,
          event     = event,
          tolerance = 1e-3
        )
      )
    },

    # 2) Coin flips – exact number of heads
    coin_heads_exact = function() {
      n_flips <- sample(c(3L, 4L), size = 1L)
      k <- sample(0:n_flips, size = 1L)

      prompt_text <- paste0(
        "You flip a fair coin ", n_flips, " times.\n",
        "What is the probability of getting exactly ", k, " heads?\n\n",
        "Return your answer as a numeric probability."
      )

      true_prob <- stats::dbinom(k, size = n_flips, prob = 0.5)

      list(
        prompt   = prompt_text,
        solution = true_prob,
        meta     = list(
          type      = "coin_exact_heads",
          n_flips   = n_flips,
          k         = k,
          tolerance = 1e-3
        )
      )
    },

    # 3) Two dice – sum in a set
    two_dice_sum = function() {
      sides <- 6L

      # Choose target sums depending on difficulty
      sum_options <- switch(
        difficulty,
        "easy"   = list(c(7L), c(6L), c(8L)),
        "medium" = list(c(4L, 10L), c(5L, 9L), c(6L, 8L)),
        "hard"   = list(c(2L, 12L), c(3L, 11L), c(2L, 3L, 11L, 12L)),
        # default
        list(c(7L))
      )

      targets <- sample(sum_options, size = 1L)[[1L]]

      # All possible outcomes of rolling two dice
      all_outcomes <- expand.grid(
        d1 = 1:sides,
        d2 = 1:sides
      )
      sums <- all_outcomes$d1 + all_outcomes$d2
      hits <- sums %in% targets

      true_prob <- sum(hits) / nrow(all_outcomes)

      prompt_text <- paste0(
        "You roll two fair ", sides, "-sided dice and add the results.\n",
        "What is the probability that the sum is in {",
        paste(targets, collapse = ", "), "}?\n\n",
        "Return your answer as a numeric probability."
      )

      list(
        prompt   = prompt_text,
        solution = true_prob,
        meta     = list(
          type      = "two_dice_sum",
          sides     = sides,
          targets   = targets,
          tolerance = 1e-3
        )
      )
    }
  )

  # Choose which scenarios are allowed by difficulty
  available_names <- switch(
    difficulty,
    "easy"   = c("die_subset", "coin_heads_exact"),
    "medium" = c("die_subset", "coin_heads_exact", "two_dice_sum"),
    "hard"   = c("coin_heads_exact", "two_dice_sum"),
    # default
    c("die_subset", "coin_heads_exact", "two_dice_sum")
  )

  chosen_name <- sample(available_names, size = 1L)
  builder <- scenarios[[chosen_name]]

  built <- builder()

  prompt_text <- paste0(
    "Topic: Basic probability (", difficulty, ")\n\n",
    built$prompt
  )

  question <- list(
    id          = paste0("prob_", as.integer(stats::runif(1, 1, 1e6))),
    topic       = "probability",
    difficulty  = difficulty,
    prompt      = prompt_text,
    data        = NULL,
    answer_type = "numeric_scalar",
    solution    = built$solution,
    meta        = built$meta
  )

  class(question) <- "statquiz_question"
  question
}