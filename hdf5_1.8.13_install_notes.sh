#!/bin/bash

# 2021-01-15


#######################################################################
# 
#######################################################################



# This library is needed for the installation of "hdf5" R package, which is needed for "Seurat".


MODULE_NAME=hdf5
VERSION=1.8.13
VERSION_SHORT=1.8
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/build
cd $MODULES_DIR/$MODULE_NAME/$VERSION

wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-$VERSION_SHORT/hdf5-$VERSION/src/hdf5-$VERSION.tar.gz


tar xvzf hdf5-$VERSION.tar.gz
cd $MODULES_DIR/$MODULE_NAME/$VERSION/hdf5-$VERSION

module purge
module load gcc/7.2.0



./configure --prefix $MODULES_DIR/$MODULE_NAME/$VERSION/build --enable-fortran --enable-cxx




# ------------------
#                Compilation Mode: production
#                      C Compiler: /panfs/roc/msisoft/gcc/7.2.0/bin/gcc ( gcc (GCC) 7.2.0)
#                          CFLAGS:
#                       H5_CFLAGS:   -ansi -pedantic -Wall -W -Wundef -Wshadow -Wpointer-arith -Wbad-function-cast -Wcast-qual -Wcast-align -Wwrite-strings -Wconversion -Waggregate-return -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wredundant-decls -Wnested-externs -Winline -O -fomit-frame-pointer -finline-functions
#                       AM_CFLAGS:
#                        CPPFLAGS:
#                     H5_CPPFLAGS: -D_POSIX_C_SOURCE=199506L   -DNDEBUG -UH5_DEBUG_API
#                     AM_CPPFLAGS: -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_BSD_SOURCE
#                Shared C Library: yes
#                Static C Library: yes
#   Statically Linked Executables: no
#                         LDFLAGS:
#                      H5_LDFLAGS:
#                      AM_LDFLAGS:
#                 Extra libraries:  -lz -ldl -lm
#                        Archiver: ar
#                          Ranlib: ranlib
#               Debugged Packages:
#                     API Tracing: no
# 
# Languages:
# ----------
#                         Fortran: yes
#                Fortran Compiler: /panfs/roc/msisoft/gcc/7.2.0/bin/gfortran ( GNU Fortran (GCC) 7.2.0)
#           Fortran 2003 Compiler: no
#                   Fortran Flags:
#                H5 Fortran Flags:
#                AM Fortran Flags:
#          Shared Fortran Library: yes
#          Static Fortran Library: yes
# 
#                             C++: yes
#                    C++ Compiler: /panfs/roc/msisoft/gcc/7.2.0/bin/g++ ( g++ (GCC) 7.2.0)
#                       C++ Flags:
#                    H5 C++ Flags:
#                    AM C++ Flags:
#              Shared C++ Library: yes
#              Static C++ Library: yes
# 
# Features:
# ---------
#                   Parallel HDF5: no
#              High Level library: yes
#                    Threadsafety: no
#             Default API Mapping: v18
#  With Deprecated Public Symbols: yes
#          I/O filters (external): deflate(zlib)
#          I/O filters (internal): shuffle,fletcher32,nbit,scaleoffset
#                             MPE: no
#                      Direct VFD: no
#                         dmalloc: no
# Clear file buffers before write: yes
#            Using memory checker: no
#          Function Stack Tracing: no
#       Strict File Format Checks: no
#    Optimization Instrumentation: no
#        Large File Support (LFS): yes
#        
 
       

make
make check
make install





# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME


cat > $VERSION <<EOF
#%Module######################################################################

prepend-path PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/bin
prepend-path INCLUDE $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path CPATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path C_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path CPLUS_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path FPATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path LD_LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib
prepend-path LD_RUN_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib
prepend-path LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib


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
find $MODULES_DIR/$MODULE_NAME -maxdepth 0 -type d -print0 | xargs -0 chmod a+rxs,go-w
find $MODULES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs,go-w
find $MODULESFILES_DIR/$MODULE_NAME -maxdepth 0 -type d -print0 | xargs -0 chmod a+rxs,go-w
find $MODULESFILES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs,go-w

# Make all files readable
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r,go-w
find $MODULESFILES_DIR/$MODULE1_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r,go-w

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -executable -print0 | xargs -0 chmod a+rx,go-w
# Note: there are no executable files in the modulesfiles directory



