#!/bin/bash

# Tool to convert markdown into unix man pages


MODULE_NAME=ronn-ng
VERSION=0.10.1.pre1
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------

mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# git clone --recursive git://github.com/apjanke/ronn-ng
# # Archive the code 
# tar cvzf ronn-ng.tar.gz ronn-ng
# 
# # Checkout the newest commit (May 6, 2021)
# cd ronn-ng
# git checkout 5c3da40
# git reset --hard

module purge
module load ruby/2.7.0
BIN_DIR="$MODULES_DIR/$MODULE_NAME/$VERSION/.gem/bin"
CURR_GEM_PATH_DIR="/panfs/roc/msisoft/ruby/2.7.0/lib/ruby/gems/2.7.0"

export PATH="$BIN_DIR:$PATH"
export GEM_HOME="$MODULES_DIR/$MODULE_NAME/$VERSION/.gem"
export GEM_SPEC_CACHE="$GEM_HOME/specs"
export GEM_PATH="$GEM_HOME:$CURR_GEM_PATH_DIR"



mkdir -p $BIN_DIR
mkdir -p $GEM_HOME
mkdir -p $GEM_SPEC_CACHE




# Check ruby gems environment paths
gem env

# Find available versions
gem list $MODULE_NAME --remote --all --pre


gem install --install-dir "$GEM_HOME" --bindir "$BIN_DIR" --version "0.10.1.pre1" $MODULE_NAME






# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME





cat > $VERSION <<EOF
#%Module######################################################################

module load ruby/2.7.0
prepend-path PATH "$BIN_DIR"
prepend-path GEM_HOME "$GEM_HOME"
prepend-path GEM_SPEC_CACHE "$GEM_SPEC_CACHE"
prepend-path GEM_PATH "$CURR_GEM_PATH_DIR"
prepend-path GEM_PATH "$GEM_HOME"

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


# Make all files readable; directories readable and executable
chmod a+rxs $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r
chmod a+rxs $MODULESFILES_DIR/$MODULE_NAME
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that were already executable for the user, readable and executable for all
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -executable -print0 | xargs -0 chmod a+rx




# ---------------------------------------------------------------------
# EXAMPLE usage
# ---------------------------------------------------------------------

# ronn my_program.1.ronn



