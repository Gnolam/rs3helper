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

def get_bucket_by_name(conn, bucket_name):
    if conn is not None:
        try:
            bucket = conn.get_bucket(bucket_name)
            response = (bucket, None)
        except boto.exception.S3ResponseError as re:
            response = (None, 'S3ResponseError = {0} {1} when getting bucket'.format(re[0], re[1]))
        except:
            response = (None, 'Unhandled error occurred when getting bucket')
    else:
        response = (None, 'connection is not made')
    return response

def get_key_by_name(conn, bucket_name, key_name):
    if conn is not None:
        bucket, res = get_bucket_by_name(conn, bucket_name)
        if bucket is not None:
            try:
                key = bucket.get_key(key_name)
                response = (key, None)
            except boto.exception.S3ResponseError as re:
                response = (None, 'S3ResponseError = {0} {1} when getting key'.format(re[0], re[1]))
            except:
                response = (None, 'Unhandled error occurred when getting key')
        else:
            response = (None, res)
    else:
        response = (None, 'connection is not made')

def get_bucket_list(conn, bucket_name, prefix = None):
    if conn is not None:
        bucket, res = get_bucket_by_name(conn, bucket_name)
        if bucket is not None:
            try:
                bucket_list = bucket.list(prefix) if prefix is not None else bucket.list()
                response = (bucket_list, None)
            except boto.exception.S3ResponseError as re:
                response = (None, 'S3ResponseError = {0} {1} when getting bucket list'.format(re[0], re[1]))
            except:
                response = (None, 'Unhandled error occurred when getting bucket list')
    else:
        response = (None, 'connection is not made')

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

## add extra information
#http://docs.ceph.com/docs/v0.80/radosgw/s3/python/
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

## add extra information
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

def get_access_control_list(conn, bucket_name, key_name = None):
    response = None
    if conn is not None:
        if key_name is not None:
            try:
                bucket = conn.get_bucket(bucket_name)
                key = bucket.get_key(key_name)
                acp = key.get_acl()
            except boto.exception.S3ResponseError as re:
                acp = None
                response = {'permission': None, 'display_name': None, 'email_address': None, 'id': None, 'message': 'S3ResponseError = {0} {1}'.format(re[0], re[1])}
            except:
                response = {'permission': None, 'display_name': None, 'email_address': None, 'id': None, 'message': 'Unhandled error occurs when getting acp'}
        else:
            try:
                bucket = conn.get_bucket(bucket_name)
                acp = bucket.get_acl()
            except boto.exception.S3ResponseError as re:
                acp = None
                response = {'permission': None, 'display_name': None, 'email_address': None, 'id': None, 'message': 'S3ResponseError = {0} {1}'.format(re[0], re[1])}
            except:
                response = {'permission': None, 'display_name': None, 'email_address': None, 'id': None, 'message': 'Unhandled error occurs when getting acp'}
        if acp is not None:
            response = [{'permission': grant.permission, 'display_name': grant.display_name, 'email_address': grant.email_address, 'id': grant.id, 'message': None} for grant in acp.acl.grants]
    else:
        response = {'permission': None, 'display_name': None, 'email_address': None, 'id': None, 'message': 'connection is not made'}
    return response

def set_access_control_list(conn, bucket_name, permission, key_name = None):
    response = None
    if conn is not None:
        if key_name is not None:
            try:
                bucket = conn.get_bucket(bucket_name)
                key = bucket.get_key(key_name)
                key.set_acl(permission)
                response = {'permission': permission, 'name': key_name, 'message': None}
            except boto.exception.S3ResponseError as re:
                response = {'permission': None, 'name': key_name, 'message': 'S3ResponseError = {0} {1}'.format(re[0], re[1])}
            except:
                response = {'permission': None, 'name': key_name, 'message': 'Unhandled error occurs when setting acp'}
        else:
            try:
                bucket = conn.get_bucket(bucket_name)
                bucket.set_acl(permission)
                response = {'permission': permission, 'name': bucket_name, 'message': None}
            except boto.exception.S3ResponseError as re:
                response = {'permission': None, 'name': bucket_name, 'message': 'S3ResponseError = {0} {1}'.format(re[0], re[1])}
            except:
                response = {'permission': None, 'name': bucket_name, 'message': 'Unhandled error occurs when setting acp'}
    else:
        response = {'permission': permission, 'name': bucket_name, 'message': 'connection is not made'}
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
                    response = {'is_created': True, 'bucket': bucket_name, 'message': None}
                except boto.exception.S3CreateError as ce:
                    response = {'is_created': False, 'bucket': bucket_name, 'message': 'S3CreateError = {0} {1}'.format(ce[0], ce[1])}
        except boto.exception.S3ResponseError as re:
            response = {'is_created': False, 'bucket': bucket_name, 'message': 'S3ResponseError = {0} {1}'.format(re[0], re[1])}
        except:
            response = {'is_created': False, 'bucket': bucket_name, 'message': 'Unhandled error occurs in creating bucket'}
    else:
        response = {'is_created': False, 'bucket': bucket_name, 'message': 'connection is not made'}
    return response

def delete_bucket(conn, bucket_name):
    if conn is not None:
        try:
            bucket = conn.get_bucket(bucket_name)
            for key in bucket.list():
                key.delete()
            conn.delete_bucket(bucket_name)
            response = {'is_deleted': True, 'bucket': bucket_name, 'message': None}
        except boto.exception.S3ResponseError as re:
            response = {'is_deleted': False, 'bucket': bucket_name, 'message': 'S3ResponseError = {0} {1}'.format(re[0], re[1])}
        except:
            response = {'is_deleted': False, 'bucket': bucket_name, 'message': 'Unhandled error occurs in deleting the bucket'}
    else:
        response = {'is_deleted': False, 'bucket': bucket_name, 'message': 'connection is not made'}
    return response

def delete_key(conn, bucket_name, prefix = None, key_name = None):
    if conn is not None:
        try:
            bucket = conn.get_bucket(bucket_name)
        except boto.exception.S3ResponseError as re:
            bucket = None
            response = {'is_deleted': False, 'bucket': bucket_name, 'key': key_name, 'message': 'S3ResponseError = {0} {1} in getting bucket'.format(re[0], re[1])}
        except:
            bucket = None
            response = {'is_deleted': False, 'bucket': bucket_name, 'key': key_name, 'message': 'Unhandled error occurs in getting bucket'}
        if bucket is not None:
            if key_name is not None:
                try:
                    key = bucket.get_key(key_name)
                    if key is not None:
                        key.delete()
                        response = {'is_deleted': True, 'bucket': bucket_name, 'key': key_name, 'message': None}
                    else:
                        response = {'is_deleted': False, 'bucket': bucket_name, 'key': key_name, 'message': '{0} does not exist'.format(key_name)}
                except boto.exception.S3ResponseError as re:
                    response = {'is_deleted': False, 'bucket': bucket_name, 'key': key_name, 'message': 'S3ResponseError = {0} {1} deleting key'.format(re[0], re[1])}
                except:
                    response = {'is_deleted': False, 'bucket': bucket_name, 'key': key_name, 'message': 'Unhandled error occurs in deleting key'}
            else:
                key_names = []
                try:
                    bucket_list = bucket.list(prefix) if prefix is not None else bucket.list()
                    key_names = key_names.extend([str(lst.key) for lst in bucket_list])
                    for key in bucket_list:
                        key.delete()
                    response = {'is_deleted': True, 'bucket': bucket_name, 'key': key_names, 'message': None}
                except boto.exception.S3ResponseError as re:
                    response = {'is_deleted': False, 'bucket': bucket_name, 'key': key_names, 'message': 'S3ResponseError = {0} {1} deleting keys'.format(re[0], re[1])}
                except:
                    response = {'is_deleted': False, 'bucket': bucket_name, 'key': key_names, 'message': 'Unhandled error occurs in deleting keys'}

        else:
            response = {'is_deleted': False, 'bucket': bucket_name, 'key': key_name, 'message': 'bucket is not found'}
    else:
        response = {'is_deleted': False, 'bucket': bucket_name, 'key': key_name, 'message': 'connection is not made'}
    return response

# def download_file(conn, bucket_name, prefix = None, pattern = None, key_name = None):
#     if connection is not None:
#         try:
#             bucket = conn.get_bucket(bucket_name)
#         except boto.exception.S3ResponseError as re:
#             bucket = None
#         except:
#             bucket = None
#
#     else:
#         'connection is not made'











