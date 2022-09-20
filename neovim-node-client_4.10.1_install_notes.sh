#!/bin/bash

# 2022-08-03

# https://github.com/neovim/node-client




# If not a slurm job, set THREADS to 1
export THREADS=$([ ! -z ${SLURM_CPUS_PER_TASK+x} ] && echo ${SLURM_CPUS_PER_TASK} || echo 1)


MODULE_NAME=neovim-node-client
VERSION=4.10.1
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------



mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION




module purge
#module load /home/lmnp/knut0297/software/modulesfiles/python3/3.7.10
module load /home/lmnp/knut0297/software/modulesfiles/node/14.15.4




# The --global-style argument will cause npm to install the package into your local 
# node_modules folder with the same layout it uses with the global node_modules folder. 
# Only your direct dependencies will show in node_modules and everything they depend on 
# will be flattened in their node_modules folders. This obviously will eliminate some deduping.


 # commit Dec 13, 2021   4b088ee



npm install --global-style neovim@4.10.1


# npm WARN saveError ENOENT: no such file or directory, open '/panfs/jay/groups/3/lmnp/knut0297/software/modules/neovim-node-client/4.10.1/package.json'
# npm notice created a lockfile as package-lock.json. You should commit this file.
# npm WARN enoent ENOENT: no such file or directory, open '/panfs/jay/groups/3/lmnp/knut0297/software/modules/neovim-node-client/4.10.1/package.json'
# npm WARN 4.10.1 No description
# npm WARN 4.10.1 No repository field.
# npm WARN 4.10.1 No README data
# npm WARN 4.10.1 No license field.
# 
# + neovim@4.10.1
# added 34 packages from 24 contributors and audited 34 packages in 13.716s
# 
# 2 packages are looking for funding
#   run `npm fund` for details
# 
# found 0 vulnerabilities
# 
# 
# 
#    ╭───────────────────────────────────────────────────────────────╮
#    │                                                               │
#    │      New major version of npm available! 6.14.10 → 8.7.0      │
#    │   Changelog: https://github.com/npm/cli/releases/tag/v8.7.0   │
#    │               Run npm install -g npm to update!               │
#    │                                                               │
#    ╰───────────────────────────────────────────────────────────────╯
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




