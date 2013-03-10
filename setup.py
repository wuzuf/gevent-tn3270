from distutils.core import setup
from distutils.extension import Extension

setup(
    name = "gevent-tn3270",
    version = "1.0",
    description = "TN3270 library for gevent",
    packages = ['tn3270'],
    package_dir = {'': 'src'},
    
    ext_modules = [Extension("tn3270._parser", ["src/ext/_parser.c", "src/ext/_tn3270_parser.c"])],
    install_requires=["gevent"]
)
