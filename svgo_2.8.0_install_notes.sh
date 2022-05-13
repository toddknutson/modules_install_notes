#!/bin/bash

# 2022-04-25

# Optimize svg images to save storage space (i.e. load time). 
# https://github.com/svg/svgo



# If not a slurm job, set THREADS to 1
export THREADS=$([ ! -z ${SLURM_CPUS_PER_TASK+x} ] && echo ${SLURM_CPUS_PER_TASK} || echo 1)


MODULE_NAME=svgo
VERSION=2.8.0
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------



mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



module use /home/lmnp/knut0297/software/modulesfiles
module purge
module load /home/lmnp/knut0297/software/modulesfiles/node/14.15.4




# The --global-style argument will cause npm to install the package into your local 
# node_modules folder with the same layout it uses with the global node_modules folder. 
# Only your direct dependencies will show in node_modules and everything they depend on 
# will be flattened in their node_modules folders. This obviously will eliminate some deduping.


# commit
# Nov 02, 2021
# v2.8.0
# b37d90e

cd $MODULES_DIR/$MODULE_NAME/$VERSION
npm install --global-style svgo@2.8.0


# 
# npm WARN saveError ENOENT: no such file or directory, open '/panfs/jay/groups/3/lmnp/knut0297/software/modules/svgo/2.8.0/package.json'
# npm notice created a lockfile as package-lock.json. You should commit this file.
# npm WARN enoent ENOENT: no such file or directory, open '/panfs/jay/groups/3/lmnp/knut0297/software/modules/svgo/2.8.0/package.json'
# npm WARN 2.8.0 No description
# npm WARN 2.8.0 No repository field.
# npm WARN 2.8.0 No README data
# npm WARN 2.8.0 No license field.
# 
# + svgo@2.8.0
# added 18 packages from 53 contributors and audited 18 packages in 3.783s
# 
# 8 packages are looking for funding
#   run `npm fund` for details
# 
# found 0 vulnerabilities
# 










# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME





cat > $VERSION <<EOF
#%Module######################################################################

module load /home/lmnp/knut0297/software/modulesfiles/node/14.15.4
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


# Make all files readable; directories readable and executable
chmod a+rxs $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r
chmod a+rxs $MODULESFILES_DIR/$MODULE_NAME
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that were already executable for the user, readable and executable for all
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -executable -print0 | xargs -0 chmod a+rx




