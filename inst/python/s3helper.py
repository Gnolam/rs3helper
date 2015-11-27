import os
import os.path
import re
import ssl

import boto
from boto.s3.connection import OrdinaryCallingFormat, Location
from boto.s3.key import Key

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
        bucket_list = bucket.list(prefix) if prefix is not None else bucket.list()
        response = (bucket_list, None)
    else:
        response = (None, res)
    return response

def count_bucket_list(bucket_list_res):
    bucket_list, res = bucket_list_res
    if bucket_list is not None:
        cnt = 0
        for key in bucket_list:
            cnt += 1
    else:
        cnt = -1
    return cnt

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
    cnt = count_bucket_list(bucket_list_res)
    if cnt > 0:
        response = [{'key_name': key.name, 'key_size': key.size, 'modified': key.last_modified, 'message': None} for key in bucket_list]
    elif cnt == 0:
        response = [{'key_name': None, 'key_size': None, 'modified': None, 'message': 'No key found'}]
    else:
        response = [{'key_name': None, 'key_size': None, 'modified': None, 'message': res}]
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
            message = 'Unhandled error occurred when getting acp'
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
            response = {'permission': permission, 'is_set': False, 'message': 'Unhandled error occurred when setting acp'}
    else:
        response = {'permission': permission, 'is_set': False, 'message': target_res}
    return response

def create_bucket(conn_res, bucket_name, location):
    conn, res = conn_res
    loc = location if location in dir(Location) else None
    if conn is not None:
        if lookup_bucket(conn_res, bucket_name) is None:
            try:
                bucket = conn.create_bucket(bucket_name, location = loc) if loc else conn.create_bucket(bucket_name)
                response = {'bucket_name': bucket_name, 'is_created': True, 'location': loc, 'message': None}
            except boto.exception.S3CreateError as ce:
                response = {'bucket_name': bucket_name, 'is_created': False, 'location': loc, 'message': format(ce)}
        else:
            response = {'bucket_name': bucket_name, 'is_created': False, 'location': loc, 'message': 'bucket already exists'}
    else:
        response = {'bucket_name': bucket_name, 'is_created': False, 'location': loc, 'message': res}
    return response

def delete_bucket(conn_res, bucket_name):
    bucket, res = get_bucket_response(conn_res, bucket_name)
    if bucket is not None:
        bucket_list, res = get_bucket_list_response((bucket, res))
        cnt = count_bucket_list((bucket_list, res))
        key_msg = None
        if cnt > 0:
            try:
                for key in bucket_list:
                    key.delete()
            except boto.exception.S3ResponseError as re:
                key_msg = 'S3ResponseError = {0} {1}'.format(re[0], re[1])
            except:
                key_msg = 'Unhandled error occurred when deleting keys'
        conn, _ = conn_res
        bucket_msg = None
        try:
            conn.delete_bucket(bucket_name)
            response = {'bucket_name': bucket_name, 'is_deleted': True, 'prefix': prefix, 'message': None}
        except boto.exception.S3ResponseError as re:
            bucket_msg = 'S3ResponseError = {0} {1}'.format(re[0], re[1])
            response = {'bucket_name': bucket_name, 'is_deleted': False, 'prefix': prefix, 'message': 'bucket: {0} || key {1}'.format(bucket_msg, key_msg)}
        except:
            bucket_msg = 'Unhandled error occurred when deleting bucket'
            response = {'bucket_name': bucket_name, 'is_deleted': False, 'prefix': prefix, 'message': 'bucket: {0} || key {1}'.format(bucket_msg, key_msg)}
    else:
        response = {'bucket_name': bucket_name, 'is_deleted': False, 'prefix': prefix, 'message': res}
    return response

def delete_key(conn_res, bucket_name, key_name = None, prefix = None):
    bucket, res = get_bucket_response(conn_res, bucket_name)
    if bucket is not None:
        if key_name is not None:
            key, res = get_key_response((bucket, res), key_name)
            if key is not None:
                try:
                    bucket.delete_key(key_name)
                    response = {'key': key_name, 'is_deleted': True, 'num_keys': 1, 'message': None}
                except boto.exception.S3ResponseError as re:
                    response = {'key': key_name, 'is_deleted': False, 'num_keys': 1, 'message': 'S3ResponseError = {0} {1}'.format(re[0], re[1])}
                except:
                    response = {'key': key_name, 'is_deleted': False, 'num_keys': 1, 'message': 'Unhandled error occurred when deleting key'}
            else:
                response = {'key': key_name, 'is_deleted': False, 'num_keys': 1, 'message': res}
        else:
            bucket_list, res = get_bucket_list_response((bucket, res), prefix)
            cnt = count_bucket_list((bucket_list, res))
            if cnt > 0:
                try:
                    for key in bucket_list:
                        key.delete()
                    response = {'key': key_name, 'is_deleted': True, 'num_keys': cnt, 'message': None}
                except boto.exception.S3ResponseError as re:
                    response = {'key': key_name, 'is_deleted': False, 'num_keys': cnt, 'message': 'S3ResponseError = {0} {1}'.format(re[0], re[1])}
                except:
                    response = {'key': key_name, 'is_deleted': False, 'num_keys': cnt, 'message': 'Unhandled error occurred when deleting key'}
            elif cnt == 0:
                response = {'key': key_name, 'is_deleted': False, 'num_keys': cnt, 'message': 'No key is found'}
            else:
                response = {'key': key_name, 'is_deleted': False, 'num_keys': cnt, 'message': res}
    else:
        response = {'key': key_name, 'is_deleted': False, 'num_keys': None, 'message': res}
    return response

def get_filepath(file_path = None):
    if file_path is None or not os.path.isdir(file_path):
        filepath = os.path.expanduser('~')
    else:
        filepath = file_path
    return filepath

def get_filename(key_name):
    file_name = key_name.rsplit('/')[len(key_name.rsplit('/'))-1]
    file_name = file_name if file_name is not '' else 'file'
    return file_name

def download_file(key_res, key_name, file_path = None):
    file_path = get_filepath(file_path)
    file_name = get_filename(key_name)
    key, res = key_res
    if key is not None:
        try:
            key.get_contents_to_filename(os.path.join(file_path, file_name))
            response = {'key_name': key_name, 'is_downloaded': True, 'file_path': file_path, 'file_name': file_name, 'message': None}
        except boto.exception.S3ResponseError as re:
            response = {'key_name': key_name, 'is_downloaded': False, 'file_path': None, 'file_name': None, 'message': 'S3ResponseError = {0} {1}'.format(re[0], re[1])}
        except:
            response = {'key_name': key_name, 'is_downloaded': False, 'file_path': None, 'file_name': None, 'message': 'Unhandled error occurred when downloading file'}
    else:
        response = {'key_name': key_name, 'is_downloaded': False, 'file_path': None, 'file_name': None, 'message': res}
    return response

def download_files(conn_res, bucket_name, file_path = None, key_name = None, pattern = None, prefix = None):
    bucket_res = get_bucket_response(conn_res, bucket_name)
    response = []
    if key_name is not None:
        key_res = get_key_response(bucket_res, key_name)
        response.append(download_file(key_res, key_name, file_path))
    else:
        bucket_list, res = get_bucket_list_response(bucket_res, prefix)
        cnt = count_bucket_list((bucket_list, res))
        if cnt > 0:
            pattern = pattern if pattern is not None else '.+'
            for key in bucket_list:
                key_str = str(key.key)
                response.append(download_file((key, key_str), key_str, file_path))
        elif cnt == 0:
            response.append({'key_name': None, 'is_downloaded': False, 'file_path': None, 'file_name': None, 'message': 'no key is found'})
        else:
            response.append({'key_name': None, 'is_downloaded': False, 'file_path': None, 'file_name': None, 'message': res})

def upload_file(conn_res, bucket_name, file_path, file_name, prefix):
    full_path = os.path.join(file_path, file_name)
    if os.path.isfile(full_path):
        if prefix is None or prefix is '':
            prefix = '/'
        elif prefix[0:1] is not '/':
            prefix = '/' + prefix
        else:
            prefix = prefix
        bucket, res = get_bucket_response(conn_res, bucket_name)
        if bucket is not None:
            full_key_name = os.path.join(prefix, file_name).replace('\\', '/')
            key = bucket.new_key(full_key_name)
            try:
                key.set_contents_from_filename(os.path.join(file_path, file_name))
                response = {'file_name': file_name, 'is_uploaded': True, 'key_name': full_key_name, 'message': None}
            except boto.exception.S3ResponseError as re:
                response = {'file_name': file_name, 'is_uploaded': False, 'key_name': None, 'message': 'S3ResponseError = {0} {1}'.format(re[0], re[1])}
            except:
                response = {'file_name': file_name, 'is_uploaded': False, 'key_name': None, 'message': 'Unhandled error occurred when uploading file'}
        else:
            response = {'file_name': file_name, 'is_uploaded': False, 'key_name': None, 'message': res}
    else:
        response = {'file_name': file_name, 'is_uploaded': False, 'key_name': None, 'message': 'file is not found'}
    return response

def copy_file(conn_res, src_bucket_name, src_key_name, dst_bucket_name, dst_key_name):
    src_bucket_res = get_bucket_response(conn_res, src_bucket_name)
    src_key, src_res = get_key_response(src_key_res, src_key_name)
    if src_key is not None:
        dst_bucket, dst_res = get_bucket_response(conn_res, dst_bucket_name)
        if dst_bucket is not None:
            try:
                src_key.copy(dst_bucket_name, dst_key_name, preserve_acl=True)
                response = {'src_key_name': src_key_name, 'is_copied': True, 'dst_key_name': dst_key_name, 'message': None}
            except boto.exception.S3ResponseError as re:
                response = {'src_key_name': src_key_name, 'is_copied': False, 'dst_key_name': None, 'message': 'S3ResponseError = {0} {1}'.format(re[0], re[1])}
            except:
                response = {'src_key_name': src_key_name, 'is_copied': False, 'dst_key_name': None, 'message': 'Unhandled error occurred when copying key'}
        else:
            response = {'src_key_name': src_key_name, 'is_copied': False, 'dst_key_name': None, 'message': 'Destination bucket does not exist'}
    else:
        response = {'src_key_name': src_key_name, 'is_copied': False, 'dst_key_name': None, 'message': src_res}
    return response

def generate_url(bucket_res, key_name, seconds):
    key, res = get_key_response(bucket_res, key_name)
    if key is not None:
        try:
            url = key.generate_url(seconds)
            response = {'key_name': key_name, 'has_url': True, 'url': url, 'message': None}
        except boto.exception.S3ResponseError as re:
            response = {'key_name': key_name, 'has_url': False, 'url': None, 'message': 'S3ResponseError = {0} {1}'.format(re[0], re[1])}
        except:
            response = {'key_name': key_name, 'has_url': False, 'url': None, 'message': 'Unhandled error occurred when generating url'}
    else:
        response = {'key_name': key_name, 'has_url': False, 'url': None, 'message': res}
    return response


