get_dir_str <- function(dir_str = getwd()) {
  if (length(grep('[w|W]in', Sys.info()['sysname'])) > 0) {
    gsub('/', '\\\\', dir_str)
  } else {
    gsub('\\\\', '/', dir_str)
  }
}

set_file_path <- function(file_path = getwd(), file_name = NULL) {
  full_path <- if(!is.null(file_name)) file.path(file_path, file_name) else file_path
  get_dir_str(full_path)
}

convert_bool <- function(bool) {
  if(bool) 'True' else 'False'
}

connect_test <- function(access_key_id, secret_access_key, is_ordinary_calling_format = FALSE, region = NULL) {
  path <- system.file('python', 'connect_test.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key)
  if(is_ordinary_calling_format) command <- paste(command, '--is_ordinary_calling_format', convert_bool(is_ordinary_calling_format))
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

create_bucket <- function(access_key_id, secret_access_key, bucket_name, is_ordinary_calling_format = FALSE, region = NULL) {
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

# create_bucket <- function(access_key_id, secret_access_key, bucket, location = NULL, region = NULL) {
#   path <- system.file('python', 'create_bucket.py', package = 'rs3helper')
#   command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket', bucket)
#   if(!is.null(location)) command <- paste(command, '--location', location)
#   if(!is.null(region)) command <- paste(command, '--region', region)
#   response <- system(command, intern = TRUE)
#   if(length(response) > 0) fromJSON(response) else 'response is NULL'
# }
#
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

