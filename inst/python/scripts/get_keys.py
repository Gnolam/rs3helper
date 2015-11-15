import argparse
import json

import boto
from boto.s3.connection import OrdinaryCallingFormat

parser = argparse.ArgumentParser(description='get all keys')
parser.add_argument('--access_key_id', required=True, type=str, help='AWS access key id')
parser.add_argument('--secret_access_key', required=True, type=str, help='AWS secret access key')
parser.add_argument('--bucket', required=True, type=str, help='Bucket name')
parser.add_argument('--prefix', required=False, type=str, help='Prefix')
parser.add_argument('--region', required=False, type=str, help='Region info')

args = parser.parse_args()

if args.region is None:
    conn = boto.connect_s3(args.access_key_id, args.secret_access_key)
else:
    conn = boto.s3.connect_to_region(
       region_name = args.region,
       aws_access_key_id = args.access_key_id,
       aws_secret_access_key = args.secret_access_key,
       calling_format = boto.s3.connection.OrdinaryCallingFormat()
       )

try:
    bucket = conn.get_bucket(args.bucket)
    bucket_list = bucket.list(prefix=args.prefix) if args.prefix is not None else bucket.list()
    print(json.dumps([l.key for l in bucket_list]))
except boto.exception.S3ResponseError as se:
    print(json.dumps(['S3ResponseError - {0} {1}'.format(se[0], se[1])]))
except:
    print(json.dumps(['Unhandled error occurred']))
