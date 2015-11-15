import argparse
import json

import boto
from boto.s3.connection import Location

parser = argparse.ArgumentParser(description='get bucket names')
parser.add_argument('--access_key_id', required=True, type=str, help='AWS access key id')
parser.add_argument('--secret_access_key', required=True, type=str, help='AWS secret access key')
parser.add_argument('--bucket', required=True, type=str, help='Bucket name')
parser.add_argument('--location', required=False, type=str, help='Location lookup value')
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
    bucket = conn.lookup(args.bucket)
    if bucket:
        print(json.dumps(['Bucket {0} already exists'.format(args.bucket)]))
    else:
        try:
            if args.location:
                loc = args.location if [l for l in dir(Location) if l[0].isupper()] else None
            else:
                loc = None
            bucket = conn.create_bucket(args.bucket, location=loc) if loc is not None else conn.create_bucket(args.bucket)
            print(json.dumps(['{0} created successfully'.format(args.bucket)]))
        except boto.exception.S3CreateError as e:
            print(json.dumps(['S3CreateError - {0} {1}'.format(e[0], e[1])]))
        except :
            print(json.dumps(['Unhandled error in creating {0} occurred'.format(args.bucket)]))
except boto.exception.S3ResponseError as se:
    print(json.dumps(['S3ResponseError - {0} {1}'.format(se[0], se[1])]))
except:
    print(json.dumps(['Unhandled error occurred']))

