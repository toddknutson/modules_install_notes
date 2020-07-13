# 2017-06-19


# Software "hmm_parse" was developed by Ben Zimring

# Manually upload the source code from Ben to the below location
cd /panfs/roc/groups/0/lmnp/knut0297/software/modules/hmm_parse/1.0

chmod -R a+r /panfs/roc/groups/0/lmnp/knut0297/software/modules/hmm_parse
chmod a+x /panfs/roc/groups/0/lmnp/knut0297/software/modules/hmm_parse
chmod a+r /panfs/roc/groups/0/lmnp/knut0297/software/install_notes/hmm_parse_install_notes
chmod a+x /panfs/roc/groups/0/lmnp/knut0297/software/modules/hmm_parse/*/*.py


# ---------------------------------------------------------------------
# Add hash bang to files
# ---------------------------------------------------------------------

sed -i '1s/^/#!\/panfs\/roc\/msisoft\/python3\/3.4-conda\/bin\/python3\n/' /home/vdl/public/vdltools/1.0/scripts/dev_by_others/hmm_parse/FASTQ.py
sed -i '1s/^/#!\/panfs\/roc\/msisoft\/python3\/3.4-conda\/bin\/python3\n/' /home/vdl/public/vdltools/1.0/scripts/dev_by_others/hmm_parse/hmm_parse.py
sed -i '1s/^/#!\/panfs\/roc\/msisoft\/python3\/3.4-conda\/bin\/python3\n/' /home/vdl/public/vdltools/1.0/scripts/dev_by_others/hmm_parse/MarkovTable.py




# Todd edited the source code 2017-06-21
# Changed the working directory from where the fast files are located, to the current
# working directory when calling the script.



# 2017-08-15
# Todd updated the files, because Ben updated the script to change the working directory from where the fast files are located, to the current
# working directory when calling the script. Ben did this nicely, so I used his code. 




MODULE_NAME=hmm_parse
VERSION=1.0
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Create the modulefile
#######################################################################

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<'ENDOFMESSAGE'
#%Module######################################################################

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds hmm_parse to your path."
}

# NOTE: 
# The following items are added to the PATH in order (top to bottom of file). Thus, when you
# prepend the path with a new item, each item afterwards also gets prepended. Thus, the last 
# item in this file will be the "first" item in your PATH list, and will be the default program.


# Create a variable for this module's bin location
set BASEDIR "/panfs/roc/groups/0/lmnp/knut0297/software/modules/hmm_parse/1.0"
prepend-path PATH $BASEDIR




ENDOFMESSAGE






# Set the version
cat > .version <<'ENDOFMESSAGE'
#%Module
set ModulesVersion "1.0"

ENDOFMESSAGE




