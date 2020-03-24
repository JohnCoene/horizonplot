<!-- badges: start -->
<!-- badges: end -->

# horizon

Create horizon plots time series in R via [horizon-timeseries-chart](https://github.com/vasturiano/horizon-timeseries-chart).

> Still in development.

## Installation

Install from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("JohnCoene/horyzon")
```

## Example

```r
library(horizonplot)

horizon(tsdata, attrs(x = dates, y = value, group = grp))
```
