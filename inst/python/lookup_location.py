import json

from s3helper import lookup_location

print(json.dumps(lookup_location()))
