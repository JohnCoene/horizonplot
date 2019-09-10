set.seed(123)
n <- 1000

# white noise:
wn <- ts(rnorm(n))

# initialise the first two values:
ar1 <- ma1 <- arma11 <- arma22 <- wn[1:2]

# loop through and create the 3:1000th values:
for(i in 3:n){
   ar1[i]      <- ar1[i - 1] * 0.8 + wn[i]
   ma1[i]      <- wn[i - 1]  * 0.8 + wn[i]
   arma11[i]   <- arma11[i - 1] * 0.8 + wn[i - 1] * 0.8 + wn[i] 
   arma22[i]   <- arma22[i - 1] * 0.8 + arma22[i - 2]  * (-0.3) + 0.8 * wn[i-1] - 0.3 * wn[i-2] + wn[i]
}

# turn them into time series, and for the last two, "integrate" them via cumulative sum
ar1 <- ts(ar1)
ma1 <- ts(ma1)
arma11 <- ts(arma11)
arima111 <- ts(cumsum(arma11))
arima222 <- ts(cumsum(cumsum(arma22)))

dates <- seq.Date(Sys.Date()-999, Sys.Date(), by = "days")
tsdata <- tibble(
  dates = rep(dates, 5),
  value = c(ar1, ma1, arma11, arima111, arima222),
  grp = c(
    rep("autoregressive", 1000L),
    rep("moving average", 1000L),
    rep("autoregressive moving average", 1000L),
    rep("arima 1", 1000L),
    rep("arima 2", 1000L)
  )
)

horizon(tsdata, attrs(x = dates, y = value, group = grp))

usethis::use_data(tsdata, overwrite = TRUE)
