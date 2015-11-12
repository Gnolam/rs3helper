get_buckets <- function(access_key_id, secret_access_key) {
  path <- system.file('python', 'get_buckets.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key)
  response <- system(command, intern = TRUE)
  fromJSON(response)
}

get_keys <- function(access_key_id, secret_access_key, bucket, prefix = NULL) {
  path <- system.file('python', 'get_keys.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket', bucket)
  if(!is.null(prefix)) command <- paste(command, '--prefix', prefix)

  response <- system(command, intern = TRUE)
  fromJSON(response)
}

download_files <- function(access_key_id, secret_access_key, bucket, prefix = NULL, pattern = NULL, file_path = NULL) {
  path <- system.file('python', 'download_files.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key, '--bucket', bucket)
  if(!is.null(prefix)) command <- paste(command, '--prefix', prefix)
  if(!is.null(pattern)) command <- paste(command, '--pattern', pattern)
  if(!is.null(file_path)) command <- paste(command, '--file_path', file_path)

  response <- system(command, intern = TRUE)
  fromJSON(response)
}

upload_file_public <- function(access_key_id, secret_access_key, bucket, file_path, file_name, prefix = NULL) {
  path <- system.file('python', 'upload_file_public.py', package = 'rs3helper')
  command <- paste('python', path, '--access_key_id', access_key_id, '--secret_access_key', secret_access_key
                   ,'--bucket', bucket, '--file_path', file_path, '--file_name', file_name)
  if(!is.null(prefix)) command <- paste(command, '--prefix', prefix)

  response <- system(command, intern = TRUE)
  fromJSON(response)
}

