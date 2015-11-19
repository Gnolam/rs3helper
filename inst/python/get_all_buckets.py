import json
import argparse

from s3helper import connect_to_s3, get_all_buckets

parser = argparse.ArgumentParser(description='get all bucket names')
parser.add_argument('--access_key_id', required=True, type=str, help='AWS access key id')
parser.add_argument('--secret_access_key', required=True, type=str, help='AWS secret access key')
parser.add_argument('--region', required=False, type=str, help='Region info')

args = parser.parse_args()

conn = connect_to_s3(args.access_key_id, args.secret_access_key, args.region)
response = get_all_buckets(conn)

print(json.dumps(response))

