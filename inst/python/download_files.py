import os
import os.path
import argparse
import json
import re

import boto
from boto.s3.connection import OrdinaryCallingFormat

parser = argparse.ArgumentParser(description='download files')
parser.add_argument('--access_key_id', required=True, type=str, help='AWS access key id')
parser.add_argument('--secret_access_key', required=True, type=str, help='AWS secret access key')
parser.add_argument('--bucket', required=True, type=str, help='Bucket name')
parser.add_argument('--prefix', required=False, type=str, help='Prefix')
parser.add_argument('--pattern', required=False, type=str, help='key pattern')
parser.add_argument('--file_path', required=False, type=str, help='path to download files')

args = parser.parse_args()

conn = boto.connect_s3(args.access_key_id, args.secret_access_key, calling_format=OrdinaryCallingFormat())
bucket = conn.get_bucket(args.bucket)

bucket_list = bucket.list(prefix=args.prefix) if args.prefix is not None else bucket.list()
pattern = args.pattern if args.pattern is not None else '.+'
file_path = args.file_path if args.file_path is not None else os.path.expanduser('~')

download_result = []
for lst in bucket_list:
    key_str = str(lst.key)
    if re.search(pattern, key_str) is not None:
        key_str_split = key_str.rsplit('/')
        file_name = key_str.rsplit('/')[len(key_str.rsplit('/'))-1]
        file_name = file_name if file_name is not '' else 'file'
        try:
            lst.get_contents_to_filename(os.path.join(file_path, file_name))
            result = 'download completes'
        except:
            result = 'download failed'
        download_result.append({'key_str': key_str, 'result': result, 'file_name': file_name})


print(json.dumps(download_result))

