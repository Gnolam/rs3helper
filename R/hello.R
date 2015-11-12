# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
hello <- function() {
  print("Hello, world!")
}

tmp <- function() {
  path <- system.file('python', 'hello.py', package = 'rs3helper')
  command <- paste("python", path)
  response <- system(command, intern = TRUE)
  fromJSON(response)
}

AWS_ACCESS_KEY_ID = 'AKIAJUWJX4N4SC6A3V6Q'
AWS_SECRET_ACCESS_KEY = '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'
BUCKET_NAME = 'anomaly.com.au'
PREFIX = 'spinworker_attribution'
PATTERN = 'log'
FILE_PATH = 'C:\\workspace\\rs3helper'
FILE_NAME = 'test.md'

#get_buckets(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)

#get_keys(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, BUCKET_NAME, PREFIX)
#all_keys <- get_keys(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, BUCKET_NAME)

#download_files(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, BUCKET_NAME, PREFIX, PATTERN, get_dir_str())

#upload_file_public(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, BUCKET_NAME, FILE_PATH, FILE_NAME, PREFIX)
