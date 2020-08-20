#!/bin/bash


# 2020-08-05
#######################################################################
# INSTALLED ONLY STRATUS -- where I have sudo capability
#######################################################################


# https://mupdf.com
# https://artifex.com/products/mupdf/


MODULE_NAME=mupdf
VERSION=1.17.0_20200805
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
# Install dependencies
# ---------------------------------------------------------------------


sudo yum install mesa-libGL-devel
sudo yum install mesa-libGLU-devel
sudo yum install libXcursor-devel
sudo yum install libXrandr-devel
sudo yum install libXinerama-devel
sudo yum install libXinerama-devel




# Fix an error that will occur during compilation
# https://melp.nl/2013/11/building-opengl-sdk-compile-error-x11-extensions-xinput-h/
cd /usr/include/X11/extensions && sudo ln -s XI.h XInput.h




# ---------------------------------------------------------------------
# Compile
# ---------------------------------------------------------------------

# make prefix=$MODULES_DIR/$MODULE_NAME/$VERSION install
# This error is found:
# thirdparty/gumbo-parser/src/attribute.c:30:3: error: ‘for’ loop initial declarations are only allowed in C99 mode
#    for (unsigned int i = 0; i < attributes->length; ++i) {
#    ^
# thirdparty/gumbo-parser/src/attribute.c:30:3: note: use option -std=c99 or -std=gnu99 to compile your code
# make: *** [build/release/thirdparty/gumbo-parser/src/attribute.o] Error 1

# SOLUTION: include -std=c99 in compiile


cd $MODULES_DIR/$MODULE_NAME/$VERSION/mupdf
make CC="gcc -std=c99" prefix=$MODULES_DIR/$MODULE_NAME/$VERSION install
 



# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<ENDOFMESSAGE
#%Module######################################################################


# Create a help message for the module
# e.g. 
# module help <module_name>

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds $MODULE_NAME $VERSION to your path."
}


# Update the necessary shell environment variables to make the software work
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/bin"



ENDOFMESSAGE





# ---------------------------------------------------------------------
# Create the modulefile default version
# ---------------------------------------------------------------------


# Set the version
cat > .version <<ENDOFMESSAGE
#%Module
set ModulesVersion "$VERSION"

ENDOFMESSAGE





# 
# 
# # ---------------------------------------------------------------------
# # Update permissions (if you want to share the module)
# # ---------------------------------------------------------------------
# 
# 
# # Make all directories readable and executable
# find $MODULES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rx
# find $MODULESFILES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rx
# 
# # Make all files readable
# find $MODULES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r
# find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r
# 
# # Make all files, that are already executable, readable and executable
# find $MODULES_DIR/$MODULE_NAME -type f -executable -print0 | xargs -0 chmod a+rx
# # Note: there are no executable files in the modulesfiles directory
# 
# 
# 
# 



