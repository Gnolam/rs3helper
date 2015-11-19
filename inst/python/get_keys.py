import json
import argparse

from s3helper import connect_to_s3, get_keys

parser = argparse.ArgumentParser(description='get keys')
parser.add_argument('--access_key_id', required=True, type=str, help='AWS access key id')
parser.add_argument('--secret_access_key', required=True, type=str, help='AWS secret access key')
parser.add_argument('--bucket_name', required=True, type=str, help='S3 bucket name')
parser.add_argument('--prefix', required=False, type=str, help='S3 bucket name')
parser.add_argument('--region', required=False, type=str, help='Region info')

args = parser.parse_args()

conn = connect_to_s3(args.access_key_id, args.secret_access_key, args.region)
response = get_keys(conn, args.bucket_name, args.prefix)

print(json.dumps(response))
