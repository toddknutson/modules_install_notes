#!/bin/bash

# 2020-04-14


#######################################################################
# SUCCESS -- no html/xml docs -- only man pages
#######################################################################






MODULE_NAME=git
VERSION=2.26.0
MODULES_DIR=/home/lmnp/knut0297/software/modules
MODULESFILES_DIR=/home/lmnp/knut0297/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



# Get the tarball
wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-${VERSION}.tar.gz
wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-manpages-${VERSION}.tar.gz
# wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-htmldocs-${VERSION}.tar.gz




tar xzvf git-${VERSION}.tar.gz
tar xzvf git-manpages-${VERSION}.tar.gz
# tar xzvf git-htmldocs-${VERSION}.tar.gz




# Do not have any perl module loaded before running make configure
module purge
cd git-${VERSION}
make configure


module load gcc/7.2.0
module load zlib/1.2.11_gcc7.2.0
module load expat/2.1.0
module load python2/2.7.15_anaconda
module load asciidoc/8.6.9
module load xmlto/0.0.28
module load perl/5.26.1
module load perl/modules.centos7.5.26.1



./configure --prefix=$MODULES_DIR/$MODULE_NAME/$VERSION
make all
make install

# Skipped making docs -- did not run: make all doc
# https://stackoverflow.com/questions/13519203/git-compiling-documentation-git-add-xml-does-not-validate
# https://gist.github.com/t-mart/87c7b2f6eccead867ed524e2b6ca22c8


# Man pages
# Now there is a share dir, after above install
# Move the man files to the default man location
# https://askubuntu.com/questions/244809/how-do-i-manually-install-a-man-page-file
mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/share/man
mv $MODULES_DIR/$MODULE_NAME/$VERSION/man* $MODULES_DIR/$MODULE_NAME/$VERSION/share/man



# Git bash autocompletion
# https://git-scm.com/book/en/v1/Git-Basics-Tips-and-Tricks
# I can't figure out how to make this work inside a modulefile???
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash




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
        puts stderr "\tThis module adds git executable to your path."
}


# Update the necessary shell environment variables to make the software work
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/bin"
# Updating manpath is not necessary because man files are in default location for local software, relative to bin
# prepend-path MANPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/share/man"

# This is not ideal usage of a modulefile. You should not source bash scripts, because there is no
# way to unload them. Consider using "setenv" and "unsetenv" to remove all the git related bash functions that get added.
# Use the POSIX dot command to "source" the following script
# https://stackoverflow.com/questions/4732200/replacement-for-source-in-sh
# system "source /home/lmnp/knut0297/software/modules/git/${VERSION}/git-completion.bash"

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

# Find and replace with current $VERSION
sed -i "s|/home/lmnp/knut0297/software/modules/git/.*/|/home/lmnp/knut0297/software/modules/git/$VERSION/|g" /home/lmnp/knut0297/.bashrc




