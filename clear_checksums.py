#!/usr/bin/python
import sys
import re

with open(sys.argv[1], "r+") as f:
    cont = f.read()
    f.seek(0)
    f.write(re.sub(r"""("files":{)[^}]*""", r"\1", cont))
    f.truncate()
