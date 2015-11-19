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

def lookup_location():
    return [loc for loc in dir(Location) if loc[0].isupper()]

def lookup_region():
    return [rgn.name for rgn in boto.s3.regions()]

def lookup_bucket(conn, bucket_name):
    if conn is not None:
        try:
            bucket = conn.lookup(bucket_name)
            if bucket is not None:
                response = {'bucket': bucket_name, 'is_exist': True, 'message': None}
            else:
                response = {'bucket': bucket_name, 'is_exist': False, 'message': None}
        except boto.exception.S3ResponseError as re:
            response = {'bucket': bucket_name, 'is_exist': None, 'message': 'S3ResponseError = {0} {1}'.format(re[0], re[1])}
        except:
            response = {'bucket': bucket_name, 'is_exist': None, 'message': 'Unhandled error occurs'}
    else:
        response = {'bucket': bucket_name, 'is_exist': None, 'message': 'connection is not made'}
    return response

def lookup_key(conn, bucket_name, key_name):
    if conn is not None:
        try:
            bucket = conn.lookup(bucket_name)
            if bucket is not None:
                try:
                    key = bucket.lookup(key_name)
                    if key is not None:
                        response = {'key': key_name, 'is_exist': True, 'message': None}
                    else:
                        response = {'key': key_name, 'is_exist': False, 'message': None}
                except boto.exception.S3ResponseError as re:
                    response = {'key': key_name, 'is_exist': None, 'message': 'S3ResponseError = {0} {1}'.format(re[0], re[1])}
                except:
                    response = {'key': key_name, 'is_exist': None, 'message': 'Unhandled error occurs when looking up key'}
            else:
                response = {'key': key_name, 'is_exist': None, 'message': 'Bucket {0} is not looked up'.format(bucket_name)}
        except boto.exception.S3ResponseError as re:
            response = {'key': key_name, 'is_exist': None, 'message': 'S3ResponseError = {0} {1}'.format(re[0], re[1])}
        except:
            response = {'key': key_name, 'is_exist': None, 'message': 'Unhandled error occurs when looking up bucket'}
    else:
        response = {'key': key_name, 'is_exist': None, 'message': 'connection is not made'}
    return response

def get_all_buckets(conn):
  if conn is not None:
      try:
          buckets = conn.get_all_buckets()
          response = [b.name for b in buckets]
      except boto.exception.S3ResponseError as re:
          response = 'S3ResponseError = {0} {1}'.format(re[0], re[1])
      except:
          response = 'Unhandled error occurs'
  else:
      response = 'connection is not made'
  return response

def get_keys(conn, bucket_name, prefix = None):
    if conn is not None:
        try:
            bucket = conn.get_bucket(bucket_name)
            if bucket is not None:
                try:
                    bucket_list = bucket.list(prefix=prefix) if prefix is not None else bucket.list()
                    response = [lst.key for lst in bucket_list]
                except boto.exception.S3ResponseError as re:
                    response = 'S3ResponseError = {0} {1}'.format(re[0], re[1])
                except:
                    response = 'Unhandled error occurs when getting bucket list'
            else:
                response = 'bucket {0} fails to be obtained'.format(bucket_name)
        except boto.exception.S3ResponseError as re:
            response = 'S3ResponseError = {0} {1}'.format(re[0], re[1])
        except:
            response = 'Unhandled error occurs when getting bucket'
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


