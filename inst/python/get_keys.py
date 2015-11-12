import argparse
import json

import boto
from boto.s3.connection import OrdinaryCallingFormat

parser = argparse.ArgumentParser(description='get all keys')
parser.add_argument('--access_key_id', required=True, type=str, help='AWS access key id')
parser.add_argument('--secret_access_key', required=True, type=str, help='AWS secret access key')
parser.add_argument('--bucket', required=True, type=str, help='Bucket name')
parser.add_argument('--prefix', required=False, type=str, help='Prefix')

args = parser.parse_args()

conn = boto.connect_s3(args.access_key_id, args.secret_access_key, calling_format=OrdinaryCallingFormat())
bucket = conn.get_bucket(args.bucket)

bucket_list = bucket.list(prefix=args.prefix) if args.prefix is not None else bucket.list()

keys = []
for lst in bucket_list:
    keys.append(lst.key)

print(json.dumps(keys))
