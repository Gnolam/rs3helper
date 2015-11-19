connect_test <- function(access_key_id, secret_access_key, region = NULL) {
  path <- system.file('python', 'connect_test.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key)
  if(!is.null(region)) {
    if(region == '') {
      warning(paste('region: expected one argument - argument ignored'))
      region <- NULL
    }
  }
  if(!is.null(region)) command <- paste(command, '--region', region)
  response <- system(command, intern = TRUE)
  response
}

lookup_location <- function() {
  path <- system.file('python', 'lookup_location.py', package = 'rs3helper')
  command <- paste('python', path)
  response <- system(command, intern = TRUE)
  tryCatch({
    fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

lookup_region <- function() {
  path <- system.file('python', 'lookup_region.py', package = 'rs3helper')
  command <- paste('python', path)
  response <- system(command, intern = TRUE)
  tryCatch({
    fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

lookup_bucket <- function(access_key_id, secret_access_key, bucket_name, region = NULL) {
  path <- system.file('python', 'lookup_bucket.py', package = 'rs3helper')
  if(bucket_name == '') {
    out <- 'bucket_name: expected one argument'
  } else {
    command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket_name', bucket_name)
    if(!is.null(region)) {
      if(region == '') {
        warning(paste('region: expected one argument - argument ignored'))
        region <- NULL
      }
    }
    if(!is.null(region)) command <- paste(command, '--region', region)
    response <- system(command, intern = TRUE)
    out <- tryCatch({
      fromJSON(response)
    }, error = function(err) {
      warning('fails to parse JSON response')
      response
    })
  }
  out
}

lookup_key <- function(access_key_id, secret_access_key, bucket_name, key_name, region = NULL) {
  path <- system.file('python', 'lookup_bucket.py', package = 'rs3helper')
  if(bucket_name == '' | key_name == '') {
    out <- 'bucket_name and key_name: expected one argument'
  } else {
    command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket_name', bucket_name)
    if(!is.null(region)) {
      if(region == '') {
        warning(paste('region argument should not be empty string - argument ignored'))
        region <- NULL
      }
    }
    if(!is.null(region)) command <- paste(command, '--region', region)
    response <- system(command, intern = TRUE)
    out <- tryCatch({
      fromJSON(response)
    }, error = function(err) {
      warning('fails to parse JSON response')
      response
    })
  }
  out
}

get_keys <- function(access_key_id, secret_access_key, bucket_name, prefix = NULL, region = NULL) {
  path <- system.file('python', 'get_keys.py', package = 'rs3helper')
  if(bucket_name == '') {
    out <- 'bucket_name: expected one argument'
  } else {
    command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket_name', bucket_name)
    if(!is.null(prefix)) {
      if(prefix == '') {
        warning(paste('prefix: expected one argument - argument ignored'))
        prefix <- NULL
      }
    }
    if(!is.null(prefix)) command <- paste(command, '--prefix', prefix)

    if(!is.null(region)) {
      if(region == '') {
        warning(paste('region: expected one argument - argument ignored'))
        region <- NULL
      }
    }
    if(!is.null(region)) command <- paste(command, '--region', region)

    response <- system(command, intern = TRUE)
    out <- tryCatch({
      fromJSON(response)
    }, error = function(err) {
      warning('fails to parse JSON response')
      response
    })
  }
  out
}

# create_bucket <- function(access_key_id, secret_access_key, bucket, location = NULL, region = NULL) {
#   path <- system.file('python', 'create_bucket.py', package = 'rs3helper')
#   command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket', bucket)
#   if(!is.null(location)) command <- paste(command, '--location', location)
#   if(!is.null(region)) command <- paste(command, '--region', region)
#   response <- system(command, intern = TRUE)
#   if(length(response) > 0) fromJSON(response) else 'response is NULL'
# }
#
# lookup_key <- function(access_key_id, secret_access_key, bucket, key_name, region = NULL) {
#   path <- system.file('python', 'lookup_key.py', package = 'rs3helper')
#   command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket', bucket, '--key_name', key_name)
#   if(!is.null(region)) command <- paste(command, '--region', region)
#   response <- system(command, intern = TRUE)
#   if(length(response) > 0) fromJSON(response) else 'response is NULL'
# }
#
# get_keys <- function(access_key_id, secret_access_key, bucket, prefix = NULL, region = NULL) {
#   path <- system.file('python', 'get_keys.py', package = 'rs3helper')
#   command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket', bucket)
#   if(!is.null(prefix)) command <- paste(command, '--prefix', prefix)
#   if(!is.null(region)) command <- paste(command, '--region', region)
#   response <- system(command, intern = TRUE)
#   if(length(response) > 0) fromJSON(response) else 'response is NULL'
# }
#
# download_files <- function(access_key_id, secret_access_key, bucket, prefix = NULL, region = NULL, pattern = NULL, file_path = NULL) {
#   path <- system.file('python', 'download_files.py', package = 'rs3helper')
#   command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket', bucket)
#   if(!is.null(prefix)) command <- paste(command, '--prefix', prefix)
#   if(!is.null(pattern)) command <- paste(command, '--pattern', pattern)
#   if(!is.null(region)) command <- paste(command, '--region', region)
#   if(!is.null(file_path)) command <- paste(command, '--file_path', file_path)
#   response <- system(command, intern = TRUE)
#   if(length(response) > 0) fromJSON(response) else 'response is NULL'
# }
#
# upload_file_public <- function(access_key_id, secret_access_key, bucket, file_path, file_name, prefix = NULL) {
#   path <- system.file('python', 'upload_file_public.py', package = 'rs3helper')
#   command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key
#                    ,'--bucket', bucket, '--file_path', file_path, '--file_name', file_name)
#   if(!is.null(prefix)) command <- paste(command, '--prefix', prefix)
#   response <- system(command, intern = TRUE)
#   if(length(response) > 0) fromJSON(response) else 'response is NULL'
# }

