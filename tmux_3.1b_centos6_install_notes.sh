#!/bin/bash

# 2020-07-24


#######################################################################
# NOTE:
#######################################################################

# The MSI login nodes are running CentOS6, but compute nodes are running centOS7. 

# This library is needed to run tmux -- and tmux needs to be launched on the
# MSI login nodes, which are still running CentOS6. When I compile the library
# it depends on a version of GLIB that is only available on CentOS6 -- so
# this code was run on the first MSI login nodes.

# Next, I will compile tmux on these CentOS6 login nodes as well.



# tmux needs to be launched on the login nodes -- so it must be compiled against OS6
# I was getting these kinds of errors:
# /home/lmnp/knut0297/software/modules/tmux/3.1b/bin/tmux: /lib64/libc.so.6: version `GLIBC_2.14' not found (required by /home/lmnp/knut0297/software/modules/tmux/3.1b/bin/tmux)

# According to Nick D., this error is caused by a program being compiled against different OS versions. See:
# https://rt.msi.umn.edu/Ticket/Display.html?id=143571



# lmnp@login02 ~  $ lsb_release -a
# LSB Version:	:base-4.0-amd64:base-4.0-ia32:base-4.0-noarch:core-4.0-amd64:core-4.0-ia32:core-4.0-noarch:graphics-4.0-amd64:graphics-4.0-ia32:graphics-4.0-noarch:printing-4.0-amd64:printing-4.0-ia32:printing-4.0-noarch
# Distributor ID:	CentOS
# Description:	CentOS release 6.10 (Final)
# Release:	6.10
# Codename:	Final





MODULE_NAME=tmux
VERSION=3.1b_centos6
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



wget https://github.com/tmux/tmux/releases/download/3.1b/tmux-3.1b.tar.gz


tar xzvf tmux-3.1b.tar.gz
cd tmux-3.1b


# modules don't work on the login nodes. Thus, manually export these variables
# during the linking process.
# module load libevent/2.1.12_centos6
export PATH="/home/lmnp/knut0297/software/modules/libevent/2.1.12_centos6/bin:$PATH"
export LIBRARY_PATH="/home/lmnp/knut0297/software/modules/libevent/2.1.12_centos6/lib:$LIBRARY_PATH"
export LD_LIBRARY_PATH="/home/lmnp/knut0297/software/modules/libevent/2.1.12_centos6/lib:$LD_LIBRARY_PATH"
export C_INCLUDE_PATH="/home/lmnp/knut0297/software/modules/libevent/2.1.12_centos6/include:$C_INCLUDE_PATH"
export CPLUS_INCLUDE_PATH="/home/lmnp/knut0297/software/modules/libevent/2.1.12_centos6/include:$CPLUS_INCLUDE_PATH"
export PKG_CONFIG_PATH="/home/lmnp/knut0297/software/modules/libevent/2.1.12_centos6/lib/pkgconfig:$PKG_CONFIG_PATH"



PKG_CONFIG_PATH=/home/lmnp/knut0297/software/modules/libevent/2.1.12_centos6/lib/pkgconfig ./configure --prefix=$MODULES_DIR/$MODULE_NAME/$VERSION
make
make install





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
module load /home/lmnp/knut0297/software/modulesfiles/libevent/2.1.12_centos6
prepend-path PATH $MODULES_DIR/$MODULE_NAME/$VERSION/bin
prepend-path LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/lib
prepend-path LD_LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/lib
prepend-path C_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/include
prepend-path CPLUS_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/include
prepend-path PKG_CONFIG_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/lib/pkgconfig

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






# ---------------------------------------------------------------------
# For Todd only: Update my .bashrc with current version
# ---------------------------------------------------------------------

# DO this once, then use the conditional below to update
echo 'export PATH="/home/lmnp/knut0297/software/modules/tmux/3.1b_centos6/bin:$PATH"' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH="/home/lmnp/knut0297/software/modules/libevent/2.1.12_centos6/lib:$LD_LIBRARY_PATH"' >> ~/.bashrc



