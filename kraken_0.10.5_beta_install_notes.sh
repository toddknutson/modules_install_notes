# 2017-10-16


# Kraken software 
# https://github.com/DerrickWood/kraken
# nucleotide based kmer taxonomer


MODULE_NAME=kraken
VERSION=0.10.5-beta
MODULES_DIR=/home/lmnp/knut0297/software/modules
MODULESFILES_DIR=/home/lmnp/knut0297/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# This install from the git repo had 29 commits since the last version release.
git clone https://github.com/DerrickWood/kraken.git

cd kraken
mkdir bin
./install_kraken.sh bin



# Update permissions
chmod -R a+r $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME -type d -exec chmod a+x {} \;
chmod -R a+x $MODULES_DIR/$MODULE_NAME/$VERSION/kraken/bin






#######################################################################
# Create the modulefile
#######################################################################

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<'ENDOFMESSAGE'
#%Module######################################################################

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds kraken to your path."
}

# NOTE: 
# The following items are added to the PATH in order (top to bottom of file). Thus, when you
# prepend the path with a new item, each item afterwards also gets prepended. Thus, the last 
# item in this file will be the "first" item in your PATH list, and will be the default program.


# Create a variable for this module's bin location
set BASEDIR "/home/lmnp/knut0297/software/modules/kraken/0.10.5-beta/kraken/bin"
prepend-path PATH $BASEDIR

# Update the Perl5 path
set perlpath "/home/lmnp/knut0297/software/modules/kraken/0.10.5-beta/kraken/bin"
prepend-path PERL5LIB $perlpath

# Set a environment variable
setenv KRAKEN_DIR /home/lmnp/knut0297/software/modules/kraken/0.10.5-beta/kraken/bin





ENDOFMESSAGE





