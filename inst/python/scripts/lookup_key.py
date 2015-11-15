import argparse
import json

import boto

parser = argparse.ArgumentParser(description='get bucket names')
parser.add_argument('--access_key_id', required=True, type=str, help='AWS access key id')
parser.add_argument('--secret_access_key', required=True, type=str, help='AWS secret access key')
parser.add_argument('--bucket', required=True, type=str, help='Bucket name')
parser.add_argument('--key_name', required=True, type=str, help='Key name')
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
    key_info = bucket.lookup(args.key_name)
    if key_info is not None:
        print(json.dumps({'key_exist': True}))
    else:
        print(json.dumps({'key_exist': False}))
except boto.exception.S3ResponseError as se:
    print(json.dumps(['S3ResponseError - {0} {1}'.format(se[0], se[1])]))
except:
    print(json.dumps(['Unhandled error occurred']))

