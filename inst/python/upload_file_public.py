import os
import os.path
import argparse
import json

import boto
from boto.s3.connection import OrdinaryCallingFormat

parser = argparse.ArgumentParser(description='upload file')
parser.add_argument('--access_key_id', required=True, type=str, help='AWS access key id')
parser.add_argument('--secret_access_key', required=True, type=str, help='AWS secret access key')
parser.add_argument('--bucket', required=True, type=str, help='Bucket name')
parser.add_argument('--file_path', required=True, type=str, help='path where the file exists')
parser.add_argument('--file_name', required=True, type=str, help='name of the file')
parser.add_argument('--prefix', required=False, type=str, help='Prefix')

args = parser.parse_args()

upload_result = []
if os.path.isfile(os.path.join(args.file_path, args.file_name)):
    if args.prefix is None or args.prefix is '':
        prefix = '/'
    elif args.prefix[0:1] is not '/':
        prefix = '/' + args.prefix
    else:
        prefix = args.prefix
    conn = boto.connect_s3(args.access_key_id, args.secret_access_key, calling_format=OrdinaryCallingFormat())
    bucket = conn.get_bucket(args.bucket)
    full_key_name = os.path.join(prefix, args.file_name).replace('\\', '/')
    k = bucket.new_key(full_key_name)
    try:
        k.set_contents_from_filename(os.path.join(args.file_path, args.file_name))
        k.make_public()
        upload_result.append({'file': args.file_name, 'message': 'upload completes'})
    except:
        upload_result.append({'file': args.file_name, 'message': 'upload failed'})
else:
    upload_result.append({'file': args.file_name, 'message': 'file not exists'})

print(json.dumps(upload_result))
