#!/bin/bash

# 2020-08-24





MODULE_NAME=pandaseq
VERSION=2.7
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



module purge
module load gcc/7.2.0
module load /home/lmnp/knut0297/software/modulesfiles/libtool/2.4.6
module load /home/lmnp/knut0297/software/modulesfiles/zlib/1.2.11
module load /home/lmnp/knut0297/software/modulesfiles/bzip2/1.0.6



wget https://github.com/neufeld/pandaseq/archive/v2.7.zip
mv v2.7.zip pandaseq-2.7.zip
unzip -d . pandaseq-2.7.zip



cd pandaseq-2.7

./autogen.sh
./configure CFLAGS='-g -O2' CXXFLAGS='-g -O2' CPPFLAGS='-g -O2' --prefix=$MODULES_DIR/$MODULE_NAME/$VERSION
make
make install
    





# Libraries have been installed in:
#    /home/lmnp/knut0297/software/modules/pandaseq/2.7/lib/pandaseq5
# 
# If you ever happen to want to link against installed libraries
# in a given directory, LIBDIR, you must either use libtool, and
# specify the full pathname of the library, or use the '-LLIBDIR'
# flag during linking and do at least one of the following:
#    - add LIBDIR to the 'LD_LIBRARY_PATH' environment variable
#      during execution
#    - add LIBDIR to the 'LD_RUN_PATH' environment variable
#      during linking
#    - use the '-Wl,-rpath -Wl,LIBDIR' linker flag
#    - have your system administrator add LIBDIR to '/etc/ld.so.conf'
# 
# See any operating system documentation about shared libraries for
# more information, such as the ld(1) and ld.so(8) manual pages.






# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOF
#%Module######################################################################


# Create a help message for the module
# e.g. 
# module help <module_name>

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds $MODULE_NAME $VERSION executable to your path."
}


# Update the necessary shell environment variables to make the software work
prepend-path    PATH $MODULES_DIR/$MODULE_NAME/$VERSION/bin
prepend-path    LD_LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/lib
prepend-path    MANPATH $MODULES_DIR/$MODULE_NAME/$VERSION/share/man
prepend-path    CPATH $MODULES_DIR/$MODULE_NAME/$VERSION/include
prepend-path    C_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/include
prepend-path    CPLUS_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/include
prepend-path    FPATH $MODULES_DIR/$MODULE_NAME/$VERSION/include
prepend-path    INCLUDE $MODULES_DIR/$MODULE_NAME/$VERSION/include
prepend-path    CPATH $MODULES_DIR/$MODULE_NAME/$VERSION/include/pandaseq-2
prepend-path    C_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/include/pandaseq-2
prepend-path    CPLUS_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/include/pandaseq-2
prepend-path    FPATH $MODULES_DIR/$MODULE_NAME/$VERSION/include/pandaseq-2
prepend-path    INCLUDE $MODULES_DIR/$MODULE_NAME/$VERSION/include/pandaseq-2



EOF





# ---------------------------------------------------------------------
# Create the modulefile default version
# ---------------------------------------------------------------------


# Set the version
cat > .version <<EOF
#%Module
set ModulesVersion "$VERSION"

EOF






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



