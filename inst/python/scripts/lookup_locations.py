import json

from boto.s3.connection import Location

print(json.dumps([l for l in dir(Location) if l[0].isupper()]))
