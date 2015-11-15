import json

import boto

print(json.dumps([re.name for re in boto.s3.regions()]))
