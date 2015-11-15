import argparse
import json

import boto

parser = argparse.ArgumentParser(description='get bucket names')
parser.add_argument('--access_key_id', required=True, type=str, help='AWS access key id')
parser.add_argument('--secret_access_key', required=True, type=str, help='AWS secret access key')

args = parser.parse_args()

conn = boto.connect_s3(args.access_key_id, args.secret_access_key)

try:
    buckets = conn.get_all_buckets()
    print(json.dumps([b.name for b in buckets]))
except boto.exception.S3ResponseError as se:
    print(json.dumps(['S3ResponseError - {0} {1}'.format(se[0], se[1])]))
except:
    print(json.dumps(['Unhandled error occurred']))


