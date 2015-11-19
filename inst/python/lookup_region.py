import json

from s3helper import lookup_region

print(json.dumps(lookup_region()))
