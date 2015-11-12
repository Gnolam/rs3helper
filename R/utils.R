get_dir_str <- function(dir_str = getwd()) {
  if (length(grep('[w|W]in', Sys.info()['sysname'])) > 0) {
    gsub('/', '\\\\', dir_str)
  } else {
    gsub('\\\\', '/', dir_str)
  }
}
