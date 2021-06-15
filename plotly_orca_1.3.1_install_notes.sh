#!/bin/bash

# 2021-05-20

# https://github.com/plotly/orca
# This tool can be used to create static images from plotly objects

# This "plotly orca" is not to be confused with another MSI module, called "orca", that 
# corresponds to this software: https://www.kofo.mpg.de/en/research/services/orca



MODULE_NAME=plotly_orca
VERSION=1.3.1
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


module use /home/lmnp/knut0297/software/modulesfiles
module purge
module load node/14.15.4




# The --global-style argument will cause npm to install the package into your local 
# node_modules folder with the same layout it uses with the global node_modules folder. 
# Only your direct dependencies will show in node_modules and everything they depend on 
# will be flattened in their node_modules folders. This obviously will eliminate some deduping.

# git commit c68d3df
# March 26, 2020

cd $MODULES_DIR/$MODULE_NAME/$VERSION
npm install --global-style electron@6.1.4 orca@1.3.1



# npm WARN deprecated request@2.88.2: request has been deprecated, see https://github.com/request/request/issues/3142
# npm WARN deprecated har-validator@5.1.5: this library is no longer supported
# npm WARN deprecated left-pad@1.3.0: use String.prototype.padStart()
# npm WARN deprecated request-promise-native@1.0.9: request-promise-native has been deprecated because it extends the now deprecated request package, see https://github.com/request/request/issues/3142
# 
# > electron@6.1.4 postinstall /panfs/roc/groups/0/lmnp/knut0297/software/modules/plotly_orca/1.3.1/node_modules/electron
# > node install.js
# 
# npm WARN saveError ENOENT: no such file or directory, open '/panfs/roc/groups/0/lmnp/knut0297/software/modules/plotly_orca/1.3.1/package.json'
# npm notice created a lockfile as package-lock.json. You should commit this file.
# npm WARN enoent ENOENT: no such file or directory, open '/panfs/roc/groups/0/lmnp/knut0297/software/modules/plotly_orca/1.3.1/package.json'
# npm WARN 1.3.1 No description
# npm WARN 1.3.1 No repository field.
# npm WARN 1.3.1 No README data
# npm WARN 1.3.1 No license field.
# 
# + orca@1.3.1
# + electron@6.1.4
# added 288 packages from 312 contributors and audited 288 packages in 27.075s
# 
# 10 packages are looking for funding
#   run `npm fund` for details
# 
# found 1 moderate severity vulnerability
#   run `npm audit fix` to fix them, or `npm audit` for details






# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOF
#%Module######################################################################

module load node/14.15.4
prepend-path PATH $MODULES_DIR/$MODULE_NAME/$VERSION/node_modules/.bin


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
find $MODULES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs
find $MODULESFILES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs

# Make all files readable
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -executable -print0 | xargs -0 chmod a+rx
# Note: there are no executable files in the modulesfiles directory


