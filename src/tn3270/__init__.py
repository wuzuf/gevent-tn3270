from client import TN3270Client
from server import TN3270Server, RequestHandler

import string
import _parser

def a2e(str):
    return string.translate(str, _parser.a2e)

def e2a(str):
    return string.translate(str, _parser.e2a)