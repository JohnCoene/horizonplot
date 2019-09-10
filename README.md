
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

<!-- badges: end -->

# horizon

Create horizon plots time series in R via
[horizon-timeseries-chart](https://github.com/vasturiano/horizon-timeseries-chart).

## Installation

Install from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("JohnCoene/horizon")
```

## Example

``` r
library(horizon)

horizon(tsdata, attrs(x = dates, y = value, group = grp))
```

<img src="man/figures/README-example-1.png" width="100%" />
