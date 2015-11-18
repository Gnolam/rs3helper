import boto
from boto.s3.connection import OrdinaryCallingFormat, Location

def connect_to_s3(access_key_id, secret_access_key, region = None):
    try:
        if region is None:
            conn = boto.connect_s3(access_key_id, secret_access_key)
        else:
            conn = boto.s3.connect_to_region(
               region_name = region,
               aws_access_key_id = access_key_id,
               aws_secret_access_key = secret_access_key,
               calling_format = OrdinaryCallingFormat()
               )
    except boto.exception.AWSConnectionError:
        conn = None
    return conn

def lookup_bucket(conn, bucket_name):
    if conn is not None:
        try:
            bucket = conn.lookup(bucket_name)
            if bucket is not None:
                response = 'Bucket {0} exists'.format(bucket_name)
            else:
                response = 'Bucket {0} does not exist'.format(bucket_name)
        except boto.exception.S3ResponseError as re:
            response = 'S3ResponseError = {0} {1}'.format(re[0], re[1])
        except:
            response = 'Unhandled error occurs'
    else:
        response = 'connection is not made'
    return response

def create_bucket(conn, bucket_name, location):
    if conn is not None:
        try:
            bucket = conn.lookup(bucket_name)
            if bucket is not None:
                response = 'Bucket {0} already exists'.format(bucket_name)
            else:
                try:
                    loc = location if location in dir(Location) else None
                    bucket = conn.create_bucket(bucket_name, location = loc) if loc else conn.create(bucket_name)
                    response = '{0} is created successfully'.format(bucket_name)
                except boto.exception.S3CreateError as ce:
                    response = 'S3CreateError = {0} {1}'.format(ce[0], ce[1])
        except boto.exception.S3ResponseError as re:
            response = 'S3ResponseError = {0} {1}'.format(re[0], re[1])
        except:
            response = 'Unhandled error occurs'
    else:
        response = 'connection is not made'
    return response


