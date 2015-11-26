import ssl

import boto
from boto.s3.connection import OrdinaryCallingFormat, Location

def get_connection_response(access_key_id, secret_access_key, is_ordinary_calling_format = False, region = None):
    try:
        if region is None:
            if is_ordinary_calling_format:
                conn = boto.connect_s3(access_key_id, secret_access_key, calling_format=OrdinaryCallingFormat())
                response = (conn, None)
            else:
                conn = boto.connect_s3(access_key_id, secret_access_key)
                response = (conn, None)
        else:
            conn = boto.s3.connect_to_region(
               region_name = region,
               aws_access_key_id = access_key_id,
               aws_secret_access_key = secret_access_key,
               calling_format = OrdinaryCallingFormat()
               )
            response = (conn, None)
    except boto.exception.AWSConnectionError:
        response = (None, 'AWS connection error')
    return response

def get_bucket_response(conn_res, bucket_name):
    conn, res = conn_res
    if conn is not None:
        try:
            bucket = conn.get_bucket(bucket_name)
            if bucket is not None:
                response = (bucket, None)
            else:
                response = (None, '{0} does not exist'.format(bucket_name))
        except boto.exception.S3ResponseError as re:
            response = (None, 'S3ResponseError = {0} {1} when getting bucket'.format(re[0], re[1]))
        except ssl.CertificateError as se:
            response = (None, se.message)
        except:
            response = (None, 'Unhandled error occurred when getting bucket')
    else:
        response = (None, res)
    return response

def get_key_response(bucket_res, key_name):
    bucket, res = bucket_res
    if bucket is not None:
        try:
            key = bucket.get_key(key_name)
            if key is not None:
                response = (key, None)
            else:
                response = (None, '{0} does not exist'.format(key_name))
        except boto.exception.S3ResponseError as re:
            response = (None, 'S3ResponseError = {0} {1} when getting key'.format(re[0], re[1]))
        except:
            response = (None, 'Unhandled error occurred when getting key')
    else:
        response = (None, res)
    return response

def get_bucket_list_response(bucket_res, prefix = None):
    bucket, res = bucket_res
    if bucket is not None:
        try:
            bucket_list = bucket.list(prefix) if prefix is not None else bucket.list()
            if bucket_list is not None:
                response = (bucket_list, None)
            else:
                response = (None, 'No element in {0}'.format(bucket.name))
        except boto.exception.S3ResponseError as re:
            response = (None, 'S3ResponseError = {0} {1} when getting bucket list'.format(re[0], re[1]))
        except:
            response = (None, 'Unhandled error occurred when getting bucket list')
    else:
        response = (None, res)
    return response

def lookup_location():
    return [loc for loc in dir(Location) if loc[0].isupper()]

def lookup_region():
    return [rgn.name for rgn in boto.s3.regions()]

def lookup_bucket(conn_res, bucket_name):
    bucket, res = get_bucket_response(conn_res, bucket_name)
    if bucket is not None:
        response = {'bucket_name': bucket_name, 'is_exists': True, 'message': None}
    else:
        response = {'bucket_name': bucket_name, 'is_exists': False, 'message': res}
    return response

def lookup_key(bucket_res, key_name):
    key, res = get_key_response(bucket_res, key_name)
    if key is not None:
        response = {'key_name': key_name, 'is_exists': True, 'message': None}
    else:
        response = {'key_name': key_name, 'is_exists': False, 'message': res}
    return response

def get_all_buckets(conn_res):
    conn, res = conn_res
    if conn is not None:
        buckets = conn.get_all_buckets()
        if buckets is not None:
            response = [{'bucket_name': bucket.name, 'created': bucket.creation_date, 'message': None} for bucket in buckets]
        else:
            response = [{'bucket_name': None, 'created': None, 'message': 'buckets are not looked up'} for bucket in buckets]
    else:
        response = [{'bucket_name': None, 'created': None, 'message': res} for bucket in buckets]
    return response

def get_keys(bucket_list_res):
    bucket_list, res = bucket_list_res
    if bucket_list is not None:
        response = [{'key_name': key.name, 'key_size': key.size, 'modified': key.last_modified, 'message': None} for key in bucket_list]
    else:
        response = [{'key_name': None, 'key_size': None, 'modified': None, 'message': res} for key in bucket_list]
    return response

def get_access_control_list(conn_res, bucket_name, key_name = None):
    bucket, res = get_bucket_response(conn_res, bucket_name)
    if key_name is not None:
        target, target_res = get_key_response((bucket, res), key_name)
    else:
        target, target_res = bucket, res
    if target is not None:
        try:
            acp = target.get_acl()
            message = None
        except boto.exception.S3ResponseError as re:
            acp = None
            message = 'S3ResponseError = {0} {1}'.format(re[0], re[1])
        except:
            acp = None
            message = 'Unhandled error occurs when getting acp'
    else:
        acp = None
        message = target_res
    if acp is not None:
        response = [{'permission': grant.permission, 'display_name': grant.display_name, 'email_address': grant.email_address, 'id': grant.id, 'message': message} for grant in acp.acl.grants]
        if len(response) == 0:
            response = {'permission': None, 'display_name': None, 'email_address': None, 'id': None, 'message': 'no acl element'}
    else:
        response = {'permission': None, 'display_name': None, 'email_address': None, 'id': None, 'message': message}
    return response

## canned access control policy: private, public-read, public-read-write, authenticated-read
def set_access_control_list(conn_res, bucket_name, permission, key_name = None):
    bucket, res = get_bucket_response(conn_res, bucket_name)
    if key_name is not None:
        target, target_res = get_key_response((bucket, res), key_name)
    else:
        target, target_res = bucket, res
    if target is not None:
        try:
            target.set_acl(permission)
            response = {'permission': permission, 'is_set': True, 'message': None}
        except boto.exception.S3ResponseError as re:
            response = {'permission': permission, 'is_set': False, 'message': 'S3ResponseError = {0} {1}'.format(re[0], re[1])}
        except:
            response = {'permission': permission, 'is_set': False, 'message': 'Unhandled error occurs when setting acp'}
    else:
        response = {'permission': permission, 'is_set': False, 'message': target_res}
    return response

def create_bucket(conn_res, bucket_name, location):
    conn, res = conn_res
    if conn is not None:
        if lookup_bucket(conn_res, bucket_name) is None:
            ''
        else:
            response = {'bucket_name': bucket_name, 'is_created': None, 'message': 'bucket already exists'}
    else:
        ''

# def create_bucket(conn, bucket_name, location):
#     if conn is not None:
#         try:
#             bucket = conn.lookup(bucket_name)
#             if bucket is not None:
#                 response = 'Bucket {0} already exists'.format(bucket_name)
#             else:
#                 try:
#                     loc = location if location in dir(Location) else None
#                     bucket = conn.create_bucket(bucket_name, location = loc) if loc else conn.create(bucket_name)
#                     response = {'is_created': True, 'bucket': bucket_name, 'message': None}
#                 except boto.exception.S3CreateError as ce:
#                     response = {'is_created': False, 'bucket': bucket_name, 'message': 'S3CreateError = {0} {1}'.format(ce[0], ce[1])}
#         except boto.exception.S3ResponseError as re:
#             response = {'is_created': False, 'bucket': bucket_name, 'message': 'S3ResponseError = {0} {1}'.format(re[0], re[1])}
#         except:
#             response = {'is_created': False, 'bucket': bucket_name, 'message': 'Unhandled error occurs in creating bucket'}
#     else:
#         response = {'is_created': False, 'bucket': bucket_name, 'message': 'connection is not made'}
#     return response
#
# def delete_bucket(conn, bucket_name):
#     if conn is not None:
#         try:
#             bucket = conn.get_bucket(bucket_name)
#             for key in bucket.list():
#                 key.delete()
#             conn.delete_bucket(bucket_name)
#             response = {'is_deleted': True, 'bucket': bucket_name, 'message': None}
#         except boto.exception.S3ResponseError as re:
#             response = {'is_deleted': False, 'bucket': bucket_name, 'message': 'S3ResponseError = {0} {1}'.format(re[0], re[1])}
#         except:
#             response = {'is_deleted': False, 'bucket': bucket_name, 'message': 'Unhandled error occurs in deleting the bucket'}
#     else:
#         response = {'is_deleted': False, 'bucket': bucket_name, 'message': 'connection is not made'}
#     return response
#
# def delete_key(conn, bucket_name, prefix = None, key_name = None):
#     if conn is not None:
#         try:
#             bucket = conn.get_bucket(bucket_name)
#         except boto.exception.S3ResponseError as re:
#             bucket = None
#             response = {'is_deleted': False, 'bucket': bucket_name, 'key': key_name, 'message': 'S3ResponseError = {0} {1} in getting bucket'.format(re[0], re[1])}
#         except:
#             bucket = None
#             response = {'is_deleted': False, 'bucket': bucket_name, 'key': key_name, 'message': 'Unhandled error occurs in getting bucket'}
#         if bucket is not None:
#             if key_name is not None:
#                 try:
#                     key = bucket.get_key(key_name)
#                     if key is not None:
#                         key.delete()
#                         response = {'is_deleted': True, 'bucket': bucket_name, 'key': key_name, 'message': None}
#                     else:
#                         response = {'is_deleted': False, 'bucket': bucket_name, 'key': key_name, 'message': '{0} does not exist'.format(key_name)}
#                 except boto.exception.S3ResponseError as re:
#                     response = {'is_deleted': False, 'bucket': bucket_name, 'key': key_name, 'message': 'S3ResponseError = {0} {1} deleting key'.format(re[0], re[1])}
#                 except:
#                     response = {'is_deleted': False, 'bucket': bucket_name, 'key': key_name, 'message': 'Unhandled error occurs in deleting key'}
#             else:
#                 key_names = []
#                 try:
#                     bucket_list = bucket.list(prefix) if prefix is not None else bucket.list()
#                     key_names = key_names.extend([str(lst.key) for lst in bucket_list])
#                     for key in bucket_list:
#                         key.delete()
#                     response = {'is_deleted': True, 'bucket': bucket_name, 'key': key_names, 'message': None}
#                 except boto.exception.S3ResponseError as re:
#                     response = {'is_deleted': False, 'bucket': bucket_name, 'key': key_names, 'message': 'S3ResponseError = {0} {1} deleting keys'.format(re[0], re[1])}
#                 except:
#                     response = {'is_deleted': False, 'bucket': bucket_name, 'key': key_names, 'message': 'Unhandled error occurs in deleting keys'}
#
#         else:
#             response = {'is_deleted': False, 'bucket': bucket_name, 'key': key_name, 'message': 'bucket is not found'}
#     else:
#         response = {'is_deleted': False, 'bucket': bucket_name, 'key': key_name, 'message': 'connection is not made'}
#     return response

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











