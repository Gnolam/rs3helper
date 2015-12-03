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

#' S3 connection test
#'
#' \code{connect_test} is a function to test connection to AWS.
#'
#'
#' AWS key pairs are necessary. For accessing a bucket whose name is non-DNS compliant, set \code{is_ordinary_calling_format} to be \code{TRUE}.
#' For example, if a bucket name begins/ends with a dot(.) or includes both small and capital letters (eg MyAWSBucket), it is not DNS compliant. For details, see \url{http://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html}).
#' Connection can also be made in a specific region. Check available regions by running \link{lookup_region}.
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
    jsonlite::fromJSON(response)
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
    jsonlite::fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Lookup S3 bucket
#'
#' \code{lookup_bucket} checks whether a bucket exists.
#'
#'
#' For \code{is_ordinary_calling_format} and \code{region}, see \link{connect_test}.
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
    jsonlite::fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Lookup S3 key
#'
#' \code{lookup_key} checks whether a key exists in a bucket.
#'
#'
#' For \code{is_ordinary_calling_format} and \code{region}, see \link{connect_test}.
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
    jsonlite::fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Get all S3 buckets
#'
#' \code{get_all_buckets} shows information of all buckets.
#'
#'
#' For \code{is_ordinary_calling_format} and \code{region}, see \link{connect_test}.
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
    jsonlite::fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Get S3 keys
#'
#' \code{get_keys} shows information of keys in a bucket.
#'
#'
#' Keys can be filtered by \code{prefix}. For example, only the keys in a subfolder can be returned by selecting the subfolder's name as a prefix.
#'
#' For \code{is_ordinary_calling_format} and \code{region}, see \link{connect_test}.
#'
#' @param access_key_id AWS access key id
#' @param secret_access_key AWS secret access key
#' @param bucket_name S3 bucket name
#' @param prefix prefix that filters keys
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
    jsonlite::fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Get access control list
#'
#' \code{get_access_control_list} shows permission information.
#'
#'
#' If \code{key_name} is \code{NULL}, the bucket's permission information is shown - otherwise the key's permission info.
#'
#' For \code{is_ordinary_calling_format} and \code{region}, see \link{connect_test}.
#'
#' @param access_key_id AWS access key id
#' @param secret_access_key AWS secret access key
#' @param bucket_name S3 bucket name
#' @param key_name S3 key name
#' @param is_ordinary_calling_format Connection calling format
#' @param region Connection region
#' @return a data frame of access control information
#' @export
#' @examples
#' \dontrun{
#'
#'get_access_control_list('aws-access-id', 'secret-access-key', 'bucket-name')
#'get_access_control_list('aws-access-id', 'secret-access-key', 'bucket-name', 'key-name')
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
    jsonlite::fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Set access control list
#'
#' \code{set_access_control_list} sets a 'canned' access control list.
#'
#'
#' The following access control (or permission) values are accepted: private, public-read, public-read-write, authenticated-read. See \url{https://boto.readthedocs.org/en/2.6.0/s3_tut.html} for further details.
#'
#' For \code{is_ordinary_calling_format} and \code{region}, see \link{connect_test}.
#'
#' @param access_key_id AWS access key id
#' @param secret_access_key AWS secret access key
#' @param bucket_name S3 bucket name
#' @param key_name S3 key name
#' @param is_ordinary_calling_format Connection calling format
#' @param region Connection region
#' @return a list of access control set up information
#' @export
#' @examples
#' \dontrun{
#'
#'set_access_control_list('aws-access-id', 'secret-access-key', 'bucket-name')
#'set_access_control_list('aws-access-id', 'secret-access-key', 'bucket-name', 'key-name')
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
    jsonlite::fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Create S3 bucket
#'
#' \code{create_bucket} creates a S3 bucket.
#'
#'
#' A bucket can be created in a different location by specifying \code{location} - see \link{get_location}.
#'
#' For \code{is_ordinary_calling_format} and \code{region}, see \link{connect_test}.
#'
#' @param access_key_id AWS access key id
#' @param secret_access_key AWS secret access key
#' @param bucket_name S3 bucket name
#' @param location S3 location
#' @param is_ordinary_calling_format Connection calling format
#' @param region Connection region
#' @return a list of bucket creation information
#' @export
#' @examples
#' \dontrun{
#'
#'create_bucket('aws-access-id', 'secret-access-key', 'bucket-name')
#'create_bucket('aws-access-id', 'secret-access-key', 'bucket-name', 'location')
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
    jsonlite::fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Delete S3 bucket
#'
#' \code{delete_bucket} deletes a bucket.
#'
#'
#' For \code{is_ordinary_calling_format} and \code{region}, see \link{connect_test}.
#'
#' @param access_key_id AWS access key id
#' @param secret_access_key AWS secret access key
#' @param bucket_name S3 bucket name
#' @param is_ordinary_calling_format Connection calling format
#' @param region Connection region
#' @return a list of bucket deletion information
#' @export
#' @examples
#' \dontrun{
#'
#'delete_bucket('aws-access-id', 'secret-access-key', 'bucket-name')
#' }
delete_bucket <- function(access_key_id, secret_access_key, bucket_name, is_ordinary_calling_format = FALSE, region = NULL) {
  if(bucket_name == '') stop('bucket_name: expected one argument')

  path <- system.file('python', 'delete_bucket.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket_name', bucket_name)
  if(is_ordinary_calling_format) command <- paste(command, '--is_ordinary_calling_format', convert_bool(is_ordinary_calling_format))
  if(!is.null(region)) command <- paste(command, '--region', region)

  response <- system(command, intern = TRUE)
  tryCatch({
    jsonlite::fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Delete S3 key
#'
#' \code{delete_keys} deletes a key or keys.
#'
#'
#' If \code{key_name} is provided, only the key is deleted. If \code{prefix} is provided, all keys that are found by the given prefix are deleted. Finally, if \code{prefix} is \code{NULL}, all keys in the bucket are deleted.
#'
#' For \code{is_ordinary_calling_format} and \code{region}, see \link{connect_test}.
#'
#' @param access_key_id AWS access key id
#' @param secret_access_key AWS secret access key
#' @param bucket_name S3 bucket name
#' @param key_name S3 key name
#' @param prefix prefix that filters keys
#' @param is_ordinary_calling_format Connection calling format
#' @param region Connection region
#' @return a list of key deletion information
#' @export
#' @examples
#' \dontrun{
#'
#'delete_keys('aws-access-id', 'secret-access-key', 'bucket-name', key_name = 'key-name')
#'delete_keys('aws-access-id', 'secret-access-key', 'bucket-name', prefix = 'prefix')
#'delete_keys('aws-access-id', 'secret-access-key', 'bucket-name')
#' }
delete_keys <- function(access_key_id, secret_access_key, bucket_name, key_name = NULL, prefix = NULL, is_ordinary_calling_format = FALSE, region = NULL) {
  if(bucket_name == '') stop('bucket_name: expected one argument')
  if(!is.null(key_name)) {
    if(key_name == '') stop('key_name: expected one argument')
  }

  path <- system.file('python', 'delete_keys.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket_name', bucket_name)
  if(!is.null(key_name)) command <- paste(command, '--key_name', key_name)
  if(!is.null(prefix)) command <- paste(command, '--prefix', prefix)
  if(is_ordinary_calling_format) command <- paste(command, '--is_ordinary_calling_format', convert_bool(is_ordinary_calling_format))
  if(!is.null(region)) command <- paste(command, '--region', region)

  response <- system(command, intern = TRUE)
  tryCatch({
    jsonlite::fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Download S3 contents
#'
#' \code{download_file} download one or more S3 contents.
#'
#'
#' If \code{key_name} is provided, only the key is downloaded. If \code{prefix} is provided, all keys that are found by the given prefix are downloaded.
#' If \code{pattern} is provided, only the keys that match the pattern are downloaded. Finally, if only \code{bucket_name} is provided, all keys in the bucket are downloaded.
#'
#' For \code{is_ordinary_calling_format} and \code{region}, see \link{connect_test}.
#'
#' @param access_key_id AWS access key id
#' @param secret_access_key AWS secret access key
#' @param bucket_name S3 bucket name
#' @param key_name S3 key name
#' @param file_path download file path
#' @param pattern key search pattern
#' @param prefix prefix that filters keys
#' @param is_ordinary_calling_format Connection calling format
#' @param region Connection region
#' @return a data frame of content download information
#' @export
#' @examples
#' \dontrun{
#'
#'download_file('aws-access-key', 'secret-access-key', bucket_name = 'bucket-name', key_name = 'key-name', file_path = set_file_path(getwd()))
#'download_file('aws-access-key', 'secret-access-key', bucket_name = 'bucket-name', prfix = 'prefix', file_path = set_file_path(getwd()))
#'download_file('aws-access-key', 'secret-access-key', bucket_name = 'bucket-name', prfix = 'prefix', pattern = 'pattern', file_path = set_file_path(getwd()))
#'download_file('aws-access-key', 'secret-access-key', bucket_name = 'bucket-name', file_path = set_file_path(getwd()))
#' }
download_files <- function(access_key_id, secret_access_key, bucket_name, key_name = NULL, file_path = NULL, pattern = NULL, prefix = NULL, is_ordinary_calling_format = FALSE, region = NULL) {
  if(bucket_name == '') stop('bucket_name: expected one argument')
  if(!is.null(key_name)) {
    if(key_name == '') stop('key_name: expected one argument')
  }

  path <- system.file('python', 'download_files.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket_name', bucket_name)
  if(!is.null(key_name)) command <- paste(command, '--key_name', key_name)
  if(!is.null(file_path)) command <- paste(command, '--file_path', file_path)
  if(!is.null(pattern)) command <- paste(command, '--pattern', pattern)
  if(!is.null(prefix)) command <- paste(command, '--prefix', prefix)
  if(is_ordinary_calling_format) command <- paste(command, '--is_ordinary_calling_format', convert_bool(is_ordinary_calling_format))
  if(!is.null(region)) command <- paste(command, '--region', region)

  response <- system(command, intern = TRUE)
  tryCatch({
    jsonlite::fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Upload file to S3
#'
#' \code{upload_file} uploads a file
#'
#'
#' If \code{prefix} is \code{NULL}, the content is uploaded to the root of the bucket. \code{prefix} should be provided to upload to a necessary location.
#' For example, if a file should be uploaded to a subfolder, \code{prefix} should be the name of the subfolder.
#'
#' For \code{is_ordinary_calling_format} and \code{region}, see \link{connect_test}.
#'
#' @param access_key_id AWS access key id
#' @param secret_access_key AWS secret access key
#' @param bucket_name S3 bucket name
#' @param file_path folder path
#' @param file_name file name
#' @param prefix prefix that filters keys
#' @param is_ordinary_calling_format Connection calling format
#' @param region Connection region
#' @return a list of content upload information
#' @export
#' @examples
#' \dontrun{
#'
#'upload_file('aws-access-key', 'secret-access-key', 'bucket-name', file_path = set_file_path(), file_name = 'file-name')
#'upload_file('aws-access-key', 'secret-access-key', 'bucket-name', file_path = set_file_path(), file_name = 'file-name', prefix = 'subfolder')
#' }
upload_file <- function(access_key_id, secret_access_key, bucket_name, file_path, file_name, prefix = NULL, is_ordinary_calling_format = FALSE, region = NULL) {
  if(bucket_name == '') stop('bucket_name: expected one argument')

  path <- system.file('python', 'upload_file.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket_name', bucket_name)
  command <- paste(command, '--file_path', file_path, '--file_name', file_name)
  if(!is.null(prefix)) command <- paste(command, '--prefix', prefix)
  if(is_ordinary_calling_format) command <- paste(command, '--is_ordinary_calling_format', convert_bool(is_ordinary_calling_format))
  if(!is.null(region)) command <- paste(command, '--region', region)

  response <- system(command, intern = TRUE)
  tryCatch({
    jsonlite::fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Copy file
#'
#' \code{copy_file} copies a file within S3.
#'
#'
#' The source and destination bucket can be the same. A file can be copied into a subfolder of the destination bucket by adjusting \code{dst_key_name}. eg) \code{dst_key_name = 'subfolder/dst_key_name'}.
#'
#' For \code{is_ordinary_calling_format} and \code{region}, see \link{connect_test}.
#'
#' @param access_key_id AWS access key id
#' @param secret_access_key AWS secret access key
#' @param src_bucket_name Source S3 bucket name
#' @param src_key_name Source S3 key name
#' @param dst_bucket_name Destination S3 bucket name
#' @param dst_key_name Destination S3 key name
#' @param is_ordinary_calling_format Connection calling format
#' @param region Connection region
#' @return a list of content copy information
#' @export
#' @examples
#' \dontrun{
#'
#'copy_file('access-key-id', 'secret-access-key', 'src-bucket-name', 'src-key-name', 'dst-bucket-name', 'dst-key-name')
#'copy_file('access-key-id', 'secret-access-key', 'same-bucket-name', 'src-key-name', 'same-bucket-name', 'subfolder/src-key-name')
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
    jsonlite::fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Generate URL
#'
#' \code{generate_url} generates a URL for a S3 object given amount of time in second.
#'
#'
#' @param access_key_id AWS access key id
#' @param secret_access_key AWS secret access key
#' @param bucket_name S3 bucket name
#' @param key_name S3 key name
#' @param seconds Time in seconds
#' @param is_ordinary_calling_format Connection calling format
#' @param region Connection region
#' @return a list of content upload information
#' @export
#' @examples
#' \dontrun{
#'
#'generate_url('aws-access-key', 'secret-access-key', 'bucket-name', 'key-name', 30)
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

  print(command)
  response <- system(command, intern = TRUE)
  tryCatch({
    jsonlite::fromJSON(response)
  }, error = function(err) {
    warning('fails to parse JSON response')
    response
  })
}

#' Wrapper of other functions
#'
#' \code{rs3wrapper} returns a function where connection related arguments are pre-filled.
#'
#'
#' The following 4 connection related arguments are required in all functions:\code{access_key_id}, \code{secret_access_key}, \code{is_ordinary_calling_format} and \code{region}.
#' The arguments can be pre-filled at once using this function. A function that has a function argument(\code{f}) and unspecified arguments (\code{...}) is returned.
#' Then it is possible to execute a function with the remaining arguments.
#'
#'
#' For \code{is_ordinary_calling_format} and \code{region}, see \link{connect_test}.
#'
#' @param access_key_id AWS access key id
#' @param secret_access_key AWS secret access key
#' @param is_ordinary_calling_format Connection calling format
#' @param region Connection region
#' @return a wrapper function (\code{function(f, ...)})
#' @export
#' @examples
#' \dontrun{
#'
#'wrapper <- rs3wrapper('access-key-id', 'secret-access-key')
#'wrapper(get_all_buckets) # no remaining argument
#'wrapper(lookup_bucket, bucket_name = 'bucket-name') # bucket_name is specified
#'wrapper(lookup_key, 'bucket-name', 'key-name') # bucket_name and key_name are specified in order
#' }
rs3wrapper <- function(access_key_id, secret_access_key, is_ordinary_calling_format = FALSE, region = NULL) {
  function(f, ...) {
    f(access_key_id = access_key_id, secret_access_key = secret_access_key, is_ordinary_calling_format = is_ordinary_calling_format, region = region, ...)
  }
}



