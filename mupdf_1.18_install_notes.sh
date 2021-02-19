#!/bin/bash

# 2021-02-19


# https://mupdf.com
# https://artifex.com/products/mupdf/


MODULE_NAME=mupdf
VERSION=1.18
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



git clone --recursive git://git.ghostscript.com/mupdf.git
# Create an archive
tar cvzf mupdf.tar.gz mupdf/


cd $MODULES_DIR/$MODULE_NAME/$VERSION/mupdf
# Explicitly checkout the latest commit
# 2021-02-18
git checkout 54382973b24a6bfd1e4179be3d29272810bc4949
git reset --hard
git checkout master







# ---------------------------------------------------------------------
# Install instructions
# ---------------------------------------------------------------------


# cat mupdf/docs/building.html

# If you are compiling from source you will need several third party libraries:
# freetype2, jbig2dec, libjpeg, openjpeg, and zlib. These libraries are contained
# in the source archive. If you are using git, they are included as git
# submodules.
# 
# You will also need the X11 headers and libraries if you're building on Linux.
# These can typically be found in the xorg-dev package. Alternatively, if you
# only want the command line tools, you can build with HAVE_X11=no.
# 
# 
# The new OpenGL-based viewer also needs OpenGL headers and libraries. If you're
# building on Linux, install the mesa-common-dev, libgl1-mesa-dev packages, and
# libglu1-mesa-dev packages. You'll also need several X11 development packages:
# xorg-dev, libxcursor-dev, libxrandr-dev, and libxinerama-dev. To skip building
# the OpenGL viewer, build with HAVE_GLUT=no.




# ---------------------------------------------------------------------
# Compile
# ---------------------------------------------------------------------


module purge
module load gcc/9.2.0
mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/build
cd $MODULES_DIR/$MODULE_NAME/$VERSION/mupdf
make clean
make XCFLAGS="-Doff_t=__off64_t" CC="gcc -std=c99" prefix=$MODULES_DIR/$MODULE_NAME/$VERSION/build install




# ERROR
# make prefix=$MODULES_DIR/$MODULE_NAME/$VERSION install
# This error is found:
# thirdparty/gumbo-parser/src/attribute.c:30:3: error: ‘for’ loop initial declarations are only allowed in C99 mode
#    for (unsigned int i = 0; i < attributes->length; ++i) {
#    ^
# thirdparty/gumbo-parser/src/attribute.c:30:3: note: use option -std=c99 or -std=gnu99 to compile your code
# make: *** [build/release/thirdparty/gumbo-parser/src/attribute.o] Error 1

# SOLUTION: include -std=c99 in compiile




# ERROR
# source/fitz/output.c: In function ‘file_truncate’:
# source/fitz/output.c:178:3: error: unknown type name ‘off_t’; did you mean ‘off64_t’?
#   178 |   off_t pos = ftello(file);
#       |   ^~~~~
#       |   off64_t
#       
#       
# https://stackoverflow.com/a/34853360/2367748
# SOLUTION: add XCFLAGS="-Doff_t=__off64_t" to compile line





# Symlink
# There is no program binary called "mupdf"
cd $MODULES_DIR/$MODULE_NAME/$VERSION/build/bin
ln -s mupdf-x11 mupdf



# NOTES
# When using mupdf-x11, I get the following error:
# ximage: disabling shared memory extension: BadAccess (attempt to access private resource denied)
#???


# man mupdf
 



# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<ENDOFMESSAGE
#%Module######################################################################

prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/bin"
prepend-path INCLUDE $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path CPATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path C_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path CPLUS_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path FPATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path LD_LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib
prepend-path LD_RUN_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib
prepend-path LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib
prepend-path MANPATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/share/man


ENDOFMESSAGE





# ---------------------------------------------------------------------
# Create the modulefile default version
# ---------------------------------------------------------------------


# Set the version
cat > .version <<ENDOFMESSAGE
#%Module
set ModulesVersion "$VERSION"

ENDOFMESSAGE






# ---------------------------------------------------------------------
# Update permissions (if you want to share the module)
# ---------------------------------------------------------------------


# Make all directories readable and executable
find $MODULES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rxs
find $MODULESFILES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rxs

# Make all files readable
find $MODULES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME -type f -executable -print0 | xargs -0 chmod a+rx
# Note: there are no executable files in the modulesfiles directory



