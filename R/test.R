AWS_ACCESS_KEY_ID = 'access-key-id'
AWS_SECRET_ACCESS_KEY = 'secret-access-key'
BUCKET_NAME = 'rs3helper'
PREFIX = 'iris.csv'
PREFIX = NULL
PATTERN = NULL
FILE_PATH = 'C:\\workspace\\rs3helper'
FILE_NAME = 'test.md'
REGION = 'ap-southeast-2'

## lookup methods
#lookup_regions()
#lookup_locations()
#lookup_bucket(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, BUCKET_NAME)
PREFIX = 'iris.csv'
#lookup_key(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, BUCKET_NAME, PREFIX)

## get methods
#get_all_buckets(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
#get_keys(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, BUCKET_NAME, PREFIX)
#get_keys(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, BUCKET_NAME, PREFIX, REGION)
#all_keys <- get_keys(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, BUCKET_NAME)

## set methods
BUCKET_NAME <- 'rs3helper_test2'
LOCATION <- 'APSoutheast'
#create_bucket(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, BUCKET_NAME)
#create_bucket(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, BUCKET_NAME, 'APSoutheast2', 'ap-southeast-2')

## download/upload methods
#download_files(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, BUCKET_NAME, PREFIX, NULL, PATTERN, get_dir_str())
PREFIX = 'test'
#upload_file_public(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, BUCKET_NAME, FILE_PATH, FILE_NAME, PREFIX)
