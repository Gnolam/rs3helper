#### R wrapper of Python boto s3

[boto](http://boto.cloudhackers.com/en/latest/) is probably the most popular interface to Amazon Web Services in Python. **rs3helper** is a wrapper of [Python boto s3](http://boto.cloudhackers.com/en/latest/ref/s3.html). The main goal of this package is to implement some of its s3-related functionality in R. For those who are interested in native R, please see the [aws.s3](https://github.com/cloudyr/aws.s3) package of the [cloudyr project](https://github.com/cloudyr).

This package can be installed by

```r
if (!require("devtools"))
  install.packages("devtools")
devtools::install_github("jaehyeon-kim/rs3helper")
```
