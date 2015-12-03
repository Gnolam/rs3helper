#### What is rs3helper

**rs3helper** includes a collection of functions to work on [Amazon Simple Storage Service (Amazon S3)](https://aws.amazon.com/s3/). Each function executes a Python script that performs an action using the [boto S3 library](http://boto.cloudhackers.com/en/latest/ref/s3.html) - [boto](https://github.com/boto/boto) is probably the most popular interface to Amazon Web Services in Python. In this regard, this package can be considered as a R wrapper of Python boto S3 library.

#### Why use Python

In relation to s3, although there are a number of existing packages, many of them seem to be deprecated, premature or platform-dependent. If there is not a comprehensive *R-way* of doing something yet, it may be necessary to create it from scratch. I have chosen to use Python as it is easy to learn and it has a comprehensive interface to AWS. For those who are interested in a R-based tool, see the [aws.s3](https://github.com/cloudyr/aws.s3) package of the [cloudyr project](https://github.com/cloudyr).

#### Prerequisites

Python and the boto library need to be installed. The Python version that is used for development is 2.7.10. The boto library can be installed using a Python package management system called **pip**. Once it is installed (see [here](http://pip.readthedocs.org/en/stable/installing/)), installing the boto library is as simple as the following.

```r
$ pip install boto
```

#### Package installation

```r
if (!require("devtools"))
  install.packages("devtools")
devtools::install_github("jaehyeon-kim/rs3helper")

library(rs3helper)
```

Note, if you see the following error, install the **jsonlite** package again and run the above snippet again - this package is used to parse responses of the Python scripts.

```r
Error in (function (dep_name, dep_ver = NA, dep_compare = NA)  : 
  Dependency package jsonlite not available.
Calls: suppressPackageStartupMessages ... <Anonymous> -> load_all -> load_depends 
                                                                      -> mapply -> <Anonymous>
Execution halted

Exited with status 1.
```
