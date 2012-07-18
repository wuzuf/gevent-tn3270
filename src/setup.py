from distutils.core import setup
from distutils.extension import Extension

setup(
    name = "gevent-tn3270",
    version = "1.0",
    description = "TN3270 library for gevent",
    packages = ['tn3270'],
    package_dir = {'': '.'},
    
    ext_modules = [Extension("tn3270._parser", ["ext/_parser.c", "ext/_tn3270_parser.c"])],
    install_requires=["gevent"]
)
