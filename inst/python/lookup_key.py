import json
import argparse

from s3helper import connect_to_s3, lookup_key

parser = argparse.ArgumentParser(description='lookup a key')
parser.add_argument('--access_key_id', required=True, type=str, help='AWS access key id')
parser.add_argument('--secret_access_key', required=True, type=str, help='AWS secret access key')
parser.add_argument('--bucket_name', required=True, type=str, help='S3 bucket name')
parser.add_argument('--key_name', required=True, type=str, help='S3 key name')
parser.add_argument('--region', required=False, type=str, help='Region info')

args = parser.parse_args()

conn = connect_to_s3(args.access_key_id, args.secret_access_key, args.region)
response = lookup_key(conn, args.bucket_name, args.key_name)

print(json.dumps(response))

