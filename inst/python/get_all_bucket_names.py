import argparse
import json

import boto
from boto.s3.connection import OrdinaryCallingFormat

parser = argparse.ArgumentParser(description='get bucket names')
parser.add_argument('--access_key_id', required=True, type=str, help='AWS access key id')
parser.add_argument('--secret_access_key', required=True, type=str, help='AWS secret access key')

args = parser.parse_args()

conn = boto.connect_s3(args.access_key_id, args.secret_access_key, calling_format=OrdinaryCallingFormat())
buckets = conn.get_all_buckets()

bucket_names = []
for b in buckets:
    bucket_names.append(b.name)

print(json.dumps(bucket_names))
