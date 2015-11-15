import boto
from boto.s3.connection import OrdinaryCallingFormat

def connect_to_s3(access_key_id, secret_access_key, region = None):
    if region is None:
        conn = boto.connect_s3(access_key_id, secret_access_key)
    else:
        conn = boto.s3.connect_to_region(
           region_name = region,
           aws_access_key_id = access_key_id,
           aws_secret_access_key = secret_access_key,
           calling_format = OrdinaryCallingFormat()
           )
    return conn
