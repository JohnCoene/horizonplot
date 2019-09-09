library(horizon)

df <- tibble::tibble(
  x = c(
    seq.Date(Sys.Date() - 19, Sys.Date(), by = "days"),
    seq.Date(Sys.Date() - 19, Sys.Date(), by = "days")
  ),
  y = runif(40),
  grp = c(rep("a", 20), rep("b", 20))
)

horizon(df, attrs(x = x, y = y, group = grp))