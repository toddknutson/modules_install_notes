# 2017-10-16


# Kraken-HLL software 
# https://github.com/fbreitwieser/kraken-hll
# nucleotide based kmer taxonomer, with the Hyper Log Log algorithm for finding unique kmers
# This is a fork from the normal Kraken tool



MODULE_NAME=krakenu
VERSION=0.10.5-beta_2017-10-16
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# This install from the git repo had 29 commits since the last version release.
git clone https://github.com/fbreitwieser/kraken-hll.git


# Note the version of G++ compiler
g++ -dumpversion
# 4.4.7

# YOU MUST USE NEWER VERSION OF GCC
module load gcc/7.2.0
g++ -dumpversion


cd kraken-hll
mkdir bin
./install_kraken.sh bin



# 
# To make things easier for you, you may want to copy/symlink the following
# files into a directory in your PATH:
#   /panfs/roc/groups/0/lmnp/knut0297/software/modules/krakenu/0.10.5-beta_2017-10-16/kraken-hll/bin/krakenu
#   /panfs/roc/groups/0/lmnp/knut0297/software/modules/krakenu/0.10.5-beta_2017-10-16/kraken-hll/bin/krakenu-add_to_library.sh
#   /panfs/roc/groups/0/lmnp/knut0297/software/modules/krakenu/0.10.5-beta_2017-10-16/kraken-hll/bin/krakenu-build
#   /panfs/roc/groups/0/lmnp/knut0297/software/modules/krakenu/0.10.5-beta_2017-10-16/kraken-hll/bin/krakenu-build_db.sh
#   /panfs/roc/groups/0/lmnp/knut0297/software/modules/krakenu/0.10.5-beta_2017-10-16/kraken-hll/bin/krakenu-check_for_jellyfish.sh
#   /panfs/roc/groups/0/lmnp/knut0297/software/modules/krakenu/0.10.5-beta_2017-10-16/kraken-hll/bin/krakenu-clean_db.sh
#   /panfs/roc/groups/0/lmnp/knut0297/software/modules/krakenu/0.10.5-beta_2017-10-16/kraken-hll/bin/krakenu-cp_into_tempfile.pl
#   /panfs/roc/groups/0/lmnp/knut0297/software/modules/krakenu/0.10.5-beta_2017-10-16/kraken-hll/bin/krakenu-download
#   /panfs/roc/groups/0/lmnp/knut0297/software/modules/krakenu/0.10.5-beta_2017-10-16/kraken-hll/bin/krakenu-filter
#   /panfs/roc/groups/0/lmnp/knut0297/software/modules/krakenu/0.10.5-beta_2017-10-16/kraken-hll/bin/krakenu-mpa-report
#   /panfs/roc/groups/0/lmnp/knut0297/software/modules/krakenu/0.10.5-beta_2017-10-16/kraken-hll/bin/krakenu-read_merger.pl
#   /panfs/roc/groups/0/lmnp/knut0297/software/modules/krakenu/0.10.5-beta_2017-10-16/kraken-hll/bin/krakenu-report
#   /panfs/roc/groups/0/lmnp/knut0297/software/modules/krakenu/0.10.5-beta_2017-10-16/kraken-hll/bin/krakenu-shrink_db.sh
#   /panfs/roc/groups/0/lmnp/knut0297/software/modules/krakenu/0.10.5-beta_2017-10-16/kraken-hll/bin/krakenu-standard_installation.sh
#   /panfs/roc/groups/0/lmnp/knut0297/software/modules/krakenu/0.10.5-beta_2017-10-16/kraken-hll/bin/krakenu-translate
#   /panfs/roc/groups/0/lmnp/knut0297/software/modules/krakenu/0.10.5-beta_2017-10-16/kraken-hll/bin/krakenu-upgrade_db.sh
#   /panfs/roc/groups/0/lmnp/knut0297/software/modules/krakenu/0.10.5-beta_2017-10-16/kraken-hll/bin/krakenu-verify_gi_numbers.pl
# 









# Update permissions
chmod -R a+r $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME -type d -exec chmod a+x {} \;
chmod -R a+x $MODULES_DIR/$MODULE_NAME/$VERSION/kraken-hll/bin





#######################################################################
# Create the modulefile
#######################################################################

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<'ENDOFMESSAGE'
#%Module######################################################################

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds krakenu (kraken-hll) to your path."
}

# NOTE: 
# The following items are added to the PATH in order (top to bottom of file). Thus, when you
# prepend the path with a new item, each item afterwards also gets prepended. Thus, the last 
# item in this file will be the "first" item in your PATH list, and will be the default program.


# Create a variable for this module's bin location
set BASEDIR "/panfs/roc/groups/0/lmnp/knut0297/software/modules/krakenu/0.10.5-beta_2017-10-16/kraken-hll/bin"

# ---------------------------------------------------------------------	
# Add items to PATH
# ---------------------------------------------------------------------

prepend-path PATH $BASEDIR





ENDOFMESSAGE





