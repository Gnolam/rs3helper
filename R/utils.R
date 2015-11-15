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
