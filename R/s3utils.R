#' Get directory string
#'
#' \code{get_dir_str} converts a slash into a backslash (or vice versa) according to the operating system. This function is not exported.
#'
#' @param dir_str directory string
#' @return directory string where slash or backslash is corrected
get_dir_str <- function(dir_str = getwd()) {
  if (length(grep('[w|W]in', Sys.info()['sysname'])) > 0) {
    gsub('/', '\\\\', dir_str)
  } else {
    gsub('\\\\', '/', dir_str)
  }
}

#' Set a file path
#'
#' \code{set_file_path} constructs a file path with the correct separator (slash or backslash) of the OS.
#'
#' @param file_path file path
#' @param file_name file name
#' @return file path with the correct separator of the OS
#' @export
#' @examples
#' \dontrun{
#'
#'set_file_path(file_path = getwd(), file_name = NULL)
#' }
set_file_path <- function(file_path = getwd(), file_name = NULL) {
  full_path <- if(!is.null(file_name)) file.path(file_path, file_name) else file_path
  get_dir_str(full_path)
}

#' Convert R bool value into Python bool value as a string
#'
#' \code{convert_bool} converts a R bool value (TRUE or FALSE) into a Python bool value (True or False). This function is not exported.
#'
#' @param bool R bool value
#' @return Python bool value as a string
convert_bool <- function(bool) {
  if(bool) 'True' else 'False'
}

#' Connection test
#'
#' \code{connect_test} is a quick function to test connection to AWS. AWS key pairs are necessary.
#' For accessing a bucket whose name is non-DNS compliant, set \code{is_ordinary_calling_format} to be \code{TRUE}.
#' For example, if a bucket name contains a dot(.) or is mixed-character, it is not DNS compliant. For details, see \link{http://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html}).
#' Connection can also be made in a specific region. Check available regions in \link{lookup_region}.
#'
#' @param access_key_id AWS access key id
#' @param secret_access_key AWS secret access key
#' @param is_ordinary_calling_format Connection calling format
#' @param region Connection region
#' @return connection string
#' @export
#' @examples
#' \dontrun{
#'
#'connect_test('access-key-id', 'secret-access-key')
#' }
connect_test <- function(access_key_id, secret_access_key, is_ordinary_calling_format = FALSE, region = NULL) {
  path <- system.file('python', 'connect_test.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key)
  if(is_ordinary_calling_format) command <- paste(command, '--is_ordinary_calling_format', convert_bool(is_ordinary_calling_format))
  if(!is.null(region)) command <- paste(command, '--region', region)

  response <- system(command, intern = TRUE)
  response
}

#' Lookup location
#'
#' \code{lookup_location} returns available locations where a bucket can be created.
#'
#' @return a charactor vector of available locations
#' @export
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

#' Lookup region
#'
#' \code{lookup_region} returns available regions where connection to AWS can be made. See \link{connect_test}.
#'
#' @return a character vector of available regions
#' @export
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

#' Lookup bucket
#'
#' \code{lookup_bucket} checks whether a bucket exists. For \code{is_ordinary_calling_format} and \code{region}, see \link{connect_test}.
#'
#' @param access_key_id AWS access key id
#' @param secret_access_key AWS secret access key
#' @param bucket_name S3 bucket name
#' @param is_ordinary_calling_format Connection calling format
#' @param region Connection region
#' @return a list of reponse including status
#' @export
#' @examples
#' \dontrun{
#'
#'lookup_bucket('aws-access-id', 'secret-access-key', 'bucket-name')
#' }
lookup_bucket <- function(access_key_id, secret_access_key, bucket_name, is_ordinary_calling_format = FALSE, region = NULL) {
  if(bucket_name == '') stop('bucket_name: expected one argument')

  path <- system.file('python', 'lookup_bucket.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket_name', bucket_name)
  if(is_ordinary_calling_format) command <- paste(command, '--is_ordinary_calling_format', convert_bool(is_ordinary_calling_format))
  if(!is.null(region)) command <- paste(command, '--region', region)

  response <- system(command, intern = TRUE)
  tryCatch({
    fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Lookup key
#'
#' \code{lookup_key} checks whether a key exists in a bucket. For \code{is_ordinary_calling_format} and \code{region}, see \link{connect_test}.
#'
#' @param access_key_id AWS access key id
#' @param secret_access_key AWS secret access key
#' @param bucket_name S3 bucket name
#' @param key_name S3 key name
#' @param is_ordinary_calling_format Connection calling format
#' @param region Connection region
#' @return a list of reponse including status
#' @export
#' @examples
#' \dontrun{
#'
#'lookup_key('aws-access-id', 'secret-access-key', 'bucket-name', 'key-name')
#' }
lookup_key <- function(access_key_id, secret_access_key, bucket_name, key_name, is_ordinary_calling_format = FALSE, region = NULL) {
  if(bucket_name == '') stop('bucket_name: expected one argument')
  if(key_name == '') stop('key_name: expected one argument')

  path <- system.file('python', 'lookup_key.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket_name', bucket_name, '--key_name', key_name)
  if(is_ordinary_calling_format) command <- paste(command, '--is_ordinary_calling_format', convert_bool(is_ordinary_calling_format))
  if(!is.null(region)) command <- paste(command, '--region', region)

  response <- system(command, intern = TRUE)
  tryCatch({
    fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Get all buckets
#'
#' \code{get_all_buckets} returns all buckets. For \code{is_ordinary_calling_format} and \code{region}, see \link{connect_test}.
#'
#' @param access_key_id AWS access key id
#' @param secret_access_key AWS secret access key
#' @param is_ordinary_calling_format Connection calling format
#' @param region Connection region
#' @return a data frame of bucket information
#' @export
#' @examples
#' \dontrun{
#'
#'get_all_buckets('aws-access-id', 'secret-access-key')
#' }
get_all_buckets <- function(access_key_id, secret_access_key, is_ordinary_calling_format = FALSE, region = NULL) {
  path <- system.file('python', 'get_all_buckets.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key)
  if(is_ordinary_calling_format) command <- paste(command, '--is_ordinary_calling_format', convert_bool(is_ordinary_calling_format))
  if(!is.null(region)) command <- paste(command, '--region', region)

  response <- system(command, intern = TRUE)
  tryCatch({
    fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Get keys
#'
#' \code{get_keys} returns information on keys in a bucket. Keys can be filtered by \code{prefix}. For example, only the keys in a subfolder can be returned by selecting the subfolder's name as a prefix.
#' For \code{is_ordinary_calling_format} and \code{region}, see \link{connect_test}.
#'
#' @param access_key_id AWS access key id
#' @param secret_access_key AWS secret access key
#' @param bucket_name S3 bucket name
#' @param prefix prefix to filter keys
#' @param is_ordinary_calling_format Connection calling format
#' @param region Connection region
#' @return a data frame of key information
#' @export
#' @examples
#' \dontrun{
#'
#'get_keys('aws-access-id', 'secret-access-key', 'bucket-name')
#'get_keys('aws-access-id', 'secret-access-key', 'bucket-name', 'prefix')
#' }
get_keys <- function(access_key_id, secret_access_key, bucket_name, prefix = NULL, is_ordinary_calling_format = FALSE, region = NULL) {
  if(bucket_name == '') stop('bucket_name: expected one argument')

  path <- system.file('python', 'get_keys.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket_name', bucket_name)
  if(!is.null(prefix)) command <- paste(command, '--prefix', prefix)
  if(is_ordinary_calling_format) command <- paste(command, '--is_ordinary_calling_format', convert_bool(is_ordinary_calling_format))
  if(!is.null(region)) command <- paste(command, '--region', region)

  response <- system(command, intern = TRUE)
  tryCatch({
    fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Get access control list
#'
#' \code{get_access_control_list} returns
#'
#' @param param param
#' @return
#' @export
#' @examples
#' \dontrun{
#'
#' }
get_access_control_list <- function(access_key_id, secret_access_key, bucket_name, key_name = NULL, is_ordinary_calling_format = FALSE, region = NULL) {
  if(bucket_name == '') stop('bucket_name: expected one argument')
  if(!is.null(key_name)) {
    if(key_name == '') stop('key_name: expected one argument')
  }

  path <- system.file('python', 'get_access_control_list.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket_name', bucket_name)
  if(!is.null(key_name)) command <- paste(command, '--key_name', key_name)
  if(is_ordinary_calling_format) command <- paste(command, '--is_ordinary_calling_format', convert_bool(is_ordinary_calling_format))
  if(!is.null(region)) command <- paste(command, '--region', region)

  response <- system(command, intern = TRUE)
  tryCatch({
    fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Set access control list
#'
#' \code{set_access_control_list}
#'
#' @param param param
#' @return
#' @export
#' @examples
#' \dontrun{
#'
#' }
set_access_control_list <- function(access_key_id, secret_access_key, bucket_name, permission, key_name = NULL, is_ordinary_calling_format = FALSE, region = NULL) {
  if(bucket_name == '') stop('bucket_name: expected one argument')
  if(permission == '') stop('permission: expected on argument')
  if(!is.null(key_name)) {
    if(key_name == '') stop('key_name: expected one argument')
  }

  path <- system.file('python', 'set_access_control_list.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket_name', bucket_name, '--permission', permission)
  if(!is.null(key_name)) command <- paste(command, '--key_name', key_name)
  if(is_ordinary_calling_format) command <- paste(command, '--is_ordinary_calling_format', convert_bool(is_ordinary_calling_format))
  if(!is.null(region)) command <- paste(command, '--region', region)

  response <- system(command, intern = TRUE)
  tryCatch({
    fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Create bucket
#'
#' \code{create_bucket}
#'
#' @param param param
#' @return
#' @export
#' @examples
#' \dontrun{
#'
#' }
create_bucket <- function(access_key_id, secret_access_key, bucket_name, location = NULL, is_ordinary_calling_format = FALSE, region = NULL) {
  if(bucket_name == '') stop('bucket_name: expected one argument')

  path <- system.file('python', 'create_bucket.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket_name', bucket_name)
  if(!is.null(location)) command <- paste(command, '--location', location)
  if(is_ordinary_calling_format) command <- paste(command, '--is_ordinary_calling_format', convert_bool(is_ordinary_calling_format))
  if(!is.null(region)) command <- paste(command, '--region', region)

  response <- system(command, intern = TRUE)
  tryCatch({
    fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Delete bucket
#'
#' \code{delete_bucket}
#'
#' @param param param
#' @return
#' @export
#' @examples
#' \dontrun{
#'
#' }
delete_bucket <- function(access_key_id, secret_access_key, bucket_name, is_ordinary_calling_format = FALSE, region = NULL) {
  if(bucket_name == '') stop('bucket_name: expected one argument')

  path <- system.file('python', 'delete_bucket.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket_name', bucket_name)
  if(is_ordinary_calling_format) command <- paste(command, '--is_ordinary_calling_format', convert_bool(is_ordinary_calling_format))
  if(!is.null(region)) command <- paste(command, '--region', region)

  response <- system(command, intern = TRUE)
  tryCatch({
    fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Delete key
#'
#' \code{delete_key}
#'
#' @param param param
#' @return
#' @export
#' @examples
#' \dontrun{
#'
#' }
delete_key <- function(access_key_id, secret_access_key, bucket_name, key_name = NULL, prefix = NULL, is_ordinary_calling_format = FALSE, region = NULL) {
  if(bucket_name == '') stop('bucket_name: expected one argument')
  if(!is.null(key_name)) {
    if(key_name == '') stop('key_name: expected one argument')
  }

  path <- system.file('python', 'delete_key.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket_name', bucket_name)
  if(!is.null(key_name)) command <- paste(command, '--key_name', key_name)
  if(!is.null(prefix)) command <- paste(command, '--prefix', prefix)
  if(is_ordinary_calling_format) command <- paste(command, '--is_ordinary_calling_format', convert_bool(is_ordinary_calling_format))
  if(!is.null(region)) command <- paste(command, '--region', region)

  response <- system(command, intern = TRUE)
  tryCatch({
    fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Download file
#'
#' \code{download_file}
#'
#' @param param param
#' @return
#' @export
#' @examples
#' \dontrun{
#'
#' }
download_file <- function(access_key_id, secret_access_key, bucket_name, key_name = NULL, file_path = NULL, pattern = NULL, prefix = NULL, is_ordinary_calling_format = FALSE, region = NULL) {
  if(bucket_name == '') stop('bucket_name: expected one argument')
  if(!is.null(key_name)) {
    if(key_name == '') stop('key_name: expected one argument')
  }

  path <- system.file('python', 'download_file.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket_name', bucket_name)
  if(!is.null(key_name)) command <- paste(command, '--key_name', key_name)
  if(!is.null(file_path)) command <- paste(command, '--file_path', file_path)
  if(!is.null(pattern)) command <- paste(command, '--pattern', pattern)
  if(!is.null(prefix)) command <- paste(command, '--prefix', prefix)
  if(is_ordinary_calling_format) command <- paste(command, '--is_ordinary_calling_format', convert_bool(is_ordinary_calling_format))
  if(!is.null(region)) command <- paste(command, '--region', region)

  response <- system(command, intern = TRUE)
  tryCatch({
    fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Upload file
#'
#' \code{upload_file}
#'
#' @param param param
#' @return
#' @export
#' @examples
#' \dontrun{
#'
#' }
upload_file <- function(access_key_id, secret_access_key, bucket_name, file_path, file_name, prefix = NULL, is_ordinary_calling_format = FALSE, region = NULL) {
  if(bucket_name == '') stop('bucket_name: expected one argument')
  if(!is.null(key_name)) {
    if(key_name == '') stop('key_name: expected one argument')
  }

  path <- system.file('python', 'upload_file.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket_name', bucket_name)
  command <- paste(command, '--file_path', file_path, '--file_name', file_name)
  if(!is.null(prefix)) command <- paste(command, '--prefix', prefix)
  if(is_ordinary_calling_format) command <- paste(command, '--is_ordinary_calling_format', convert_bool(is_ordinary_calling_format))
  if(!is.null(region)) command <- paste(command, '--region', region)

  response <- system(command, intern = TRUE)
  tryCatch({
    fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Copy file
#'
#' \code{copy_file}
#'
#' @param param param
#' @return
#' @export
#' @examples
#' \dontrun{
#'
#' }
copy_file <- function(access_key_id, secret_access_key, src_bucket_name, src_key_name, dst_bucket_name, dst_key_name, is_ordinary_calling_format = FALSE, region = NULL) {
  names <- c(src_bucket_name, src_key_name, dst_bucket_name, dst_key_name)
  if (all(names %in% '')) {
    stop('NULL string is found in bucket and/or key names')
  }

  path <- system.file('python', 'copy_file.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key)
  command <- paste(command, '--src_bucket_name', src_bucket_name, '--src_key_name', src_key_name, '--dst_bucket_name', dst_bucket_name, '--dst_key_name', dst_key_name)
  if(is_ordinary_calling_format) command <- paste(command, '--is_ordinary_calling_format', convert_bool(is_ordinary_calling_format))
  if(!is.null(region)) command <- paste(command, '--region', region)

  response <- system(command, intern = TRUE)
  tryCatch({
    fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Generate URL
#'
#' \code{generate_url}
#'
#' @param param param
#' @return
#' @export
#' @examples
#' \dontrun{
#'
#' }
generate_url <- function(access_key_id, secret_access_key, bucket_name, key_name, seconds, is_ordinary_calling_format = FALSE, region = NULL) {
  if(bucket_name == '') stop('bucket_name: expected one argument')
  if(key_name == '') stop('key_name: expected one argument')
  if(!is.numeric(seconds)) stop('seconds: integer value is required')

  path <- system.file('python', 'generate_url.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket_name', bucket_name, '--key_name', key_name)
  command <- paste(command, '--seconds', as.integer(seconds))
  if(is_ordinary_calling_format) command <- paste(command, '--is_ordinary_calling_format', convert_bool(is_ordinary_calling_format))
  if(!is.null(region)) command <- paste(command, '--region', region)

  response <- system(command, intern = TRUE)
  tryCatch({
    fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

