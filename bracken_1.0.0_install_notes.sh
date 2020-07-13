# 2017-10-16

# Bracken
# https://github.com/jenniferlu717/Bracken
# Bayesian Reestimation of Abundance with KrakEN


MODULE_NAME=bracken
VERSION=1.0.0
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION





wget https://github.com/jenniferlu717/Bracken/archive/1.0.0.tar.gz

tar -zxvf 1.0.0.tar.gz

# The scripts are in the top level folder. Create a bin and move them there.
cd Bracken-1.0.0
mkdir bin
cd bin
ln -s ../count-kmer-abundances.pl count-kmer-abundances.pl
ln -s ../est_abundance.py est_abundance.py
ln -s ../generate_kmer_distribution.py generate_kmer_distribution.py





# Update permissions
# add executable to world for binaries
chmod -R a+r $MODULES_DIR/$MODULE_NAME/$VERSION
chmod a+x $MODULES_DIR/$MODULE_NAME/$VERSION/Bracken-1.0.0/count-kmer-abundances.pl
chmod a+x $MODULES_DIR/$MODULE_NAME/$VERSION/Bracken-1.0.0/est_abundance.py
chmod a+x $MODULES_DIR/$MODULE_NAME/$VERSION/Bracken-1.0.0/generate_kmer_distribution.py










#######################################################################
# Create the modulefile
#######################################################################

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<'ENDOFMESSAGE'
#%Module######################################################################

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds bracken to your path."
}

# NOTE: 
# The following items are added to the PATH in order (top to bottom of file). Thus, when you
# prepend the path with a new item, each item afterwards also gets prepended. Thus, the last 
# item in this file will be the "first" item in your PATH list, and will be the default program.


# Create a variable for this module's bin location
set BASEDIR "/home/lmnp/knut0297/software/modules/bracken/1.0.0/Bracken-1.0.0/bin"



# ---------------------------------------------------------------------	
# Add items to PATH
# ---------------------------------------------------------------------

prepend-path PATH $BASEDIR
# This software relies on perl modules, currently installed on MSI systems.
module load perl/modules



ENDOFMESSAGE



