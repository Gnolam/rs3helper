import json

from s3helper import lookup_region

print(json.dumps(response, sort_keys=True, indent=4, separators=(',', ': ')))
