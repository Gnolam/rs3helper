import json
import argparse

from s3helper import get_connection_response, copy_file

parser = argparse.ArgumentParser(description='delete a key')
parser.add_argument('--access_key_id', required=True, type=str, help='AWS access key id')
parser.add_argument('--secret_access_key', required=True, type=str, help='AWS secret access key')
parser.add_argument('--src_bucket_name', required=True, type=str, help='S3 bucket name - source')
parser.add_argument('--src_key_name', required=True, type=str, help='S3 bucket name - source')
parser.add_argument('--dst_bucket_name', required=True, type=str, help='S3 bucket name - destination')
parser.add_argument('--dst_key_name', required=True, type=str, help='S3 bucket name - destination')
parser.add_argument('--is_ordinary_calling_format', required=False, type=bool, help='Connected in ordinary calling format?')
parser.add_argument('--region', required=False, type=str, help='Region info')

args = parser.parse_args()

conn_res = get_connection_response(args.access_key_id, args.secret_access_key, args.is_ordinary_calling_format, args.region)
response = copy_file(conn_res, args.src_bucket_name, args.src_key_name, args.dst_bucket_name, args.dst_key_name)

print(json.dumps(response, sort_keys=True, indent=4, separators=(',', ': ')))
