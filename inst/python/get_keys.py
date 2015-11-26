import json
import argparse

from s3helper import get_connection_response, get_bucket_response, get_bucket_list_response, get_keys

parser = argparse.ArgumentParser(description='get keys')
parser.add_argument('--access_key_id', required=True, type=str, help='AWS access key id')
parser.add_argument('--secret_access_key', required=True, type=str, help='AWS secret access key')
parser.add_argument('--bucket_name', required=True, type=str, help='S3 bucket name')
parser.add_argument('--prefix', required=False, type=str, help='S3 prefix')
parser.add_argument('--is_ordinary_calling_format', required=False, type=bool, help='Connected in ordinary calling format?')
parser.add_argument('--region', required=False, type=str, help='Region info')

args = parser.parse_args()

conn_res = get_connection_response(args.access_key_id, args.secret_access_key, args.is_ordinary_calling_format, args.region)
bucket_res = get_bucket_response(conn_res, args.bucket_name)
bucket_list_res = get_bucket_list_response(bucket_res, args.prefix)
response = get_keys(bucket_list_res)

print(json.dumps(response))
