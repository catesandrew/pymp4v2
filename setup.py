from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import os, sys

if sys.platform == "darwin":
    # Disable Apple Double files on osx
    os.environ['COPYFILE_DISABLE'] = "true"

ext_modules = [
    Extension("mp4v2.mp4file", ["ext/mp4file.pyx"],
    include_dirs = ['/usr/local/include'],
    library_dirs = ['/usr/local/lib'],
    libraries    = ['mp4v2'],
    extra_compile_args = ["-g"],
    extra_link_args=["-g"],
    )
]

setup(
    name = "mp4v2",
    version = "0.1.1",
    description="A Python interface to libmp4v2",
    author="James A. Kyle",
    author_email="jameskyle@ucla.edu",
    url="",
    cmdclass = {'build_ext': build_ext},
    ext_modules = ext_modules,
    
    package_dir={'': 'lib'},
    packages =['mp4v2'],
    
)
