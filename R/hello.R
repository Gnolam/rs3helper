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

get_all_bucket_names <- function(access_key_id, secret_access_key) {
  path <- system.file('python', 'get_all_bucket_names.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key)
  response <- system(command, intern = TRUE)
  fromJSON(response)
}

#get_all_bucket_names(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)

get_all_keys <- function(access_key_id, secret_access_key, bucket_name, prefix = NULL) {
  path <- system.file('python', 'get_all_keys.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket_name', bucket_name)
  if(!is.null(prefix)) {
    command <- paste(command, '--prefix', prefix)
  }
  response <- system(command, intern = TRUE)
  fromJSON(response)
}

#get_all_keys(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, BUCKET_NAME, PREFIX)
#all_keys <- get_all_keys(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, BUCKET_NAME)


