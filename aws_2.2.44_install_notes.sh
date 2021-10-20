#!/bin/bash

# 2021-10-11


# https://github.com/aws/aws-cli/tree/v2
# https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst

MODULE_NAME=aws
VERSION=2.2.44
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.2.44.zip" -o "awscliv2-${VERSION}.zip"
unzip "awscliv2-${VERSION}.zip"

INSTALL_DIR=$MODULES_DIR/$MODULE_NAME/$VERSION/install
BIN_DIR=$MODULES_DIR/$MODULE_NAME/$VERSION/bin

mkdir -p $INSTALL_DIR
mkdir -p $BIN_DIR


module purge


cd $MODULES_DIR/$MODULE_NAME/$VERSION/aws

./install -i $INSTALL_DIR -b $BIN_DIR


 



# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOF
#%Module######################################################################

prepend-path PATH "$BIN_DIR"

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
# Configure
# ---------------------------------------------------------------------

# Each individual user will need to set up their own ~/.aws/credentials and ~/.aws/config 
# files. This can be done using the "aws configure" command.

# Notes:
# https://computingforgeeks.com/configure-aws-s3-cli-for-ceph-object-gateway-storage/

# Set up "ceph" config
module purge
module load aws/2.2.44
aws configure set --profile ceph aws_access_key_id "$(s3info keys --machine-output | awk '{print $1}')"
aws configure set --profile ceph aws_secret_access_key "$(s3info keys --machine-output | awk '{print $2}')"
aws configure set --profile ceph region "us-east-1"
aws configure set --profile ceph output "json"
# Note, the following currently does not actually impact the connection. Leaving here for easy
# identification of the actual endpoint url for the "ceph" profile
aws configure set --profile ceph endpoint-url "https://s3.msi.umn.edu"




# ---------------------------------------------------------------------
# Test connection
# ---------------------------------------------------------------------


module purge
module load aws/2.2.44
# Create a unique bucket
aws --profile ceph --endpoint-url "https://s3.msi.umn.edu" s3 mb "s3://$(echo ${USER}_testbucket_aws_config_$(date +"%m-%d-%y-%s"))"



# Specifying the "--endpoint-url URL" on the command line is required for non-standard URLs.
# However, the "region" and "json" values can get picked up from the ~/.aws/config
# https://github.com/aws/aws-cli/issues/1270
# Creating an alias can help
alias awsceph="aws --profile ceph --endpoint-url https://s3.msi.umn.edu --region us-east-1 --output json"

# NOTE: the aws api does not like underscores (they are allowed in ceph, but the api methods
# detect them and error. So just do not use them, if you plan to use the aws api). However,
# it seems like enabling bucket versions using the python boto3 api, does not care about underscores.
my_test_bucket=$(echo ${USER}-testbucket-aws-config-$(date +"%m-%d-%y-%s"))
awsceph s3 mb "s3://$my_test_bucket"


# Test other api methods
awsceph s3api put-bucket-versioning --bucket "$my_test_bucket" --versioning-configuration Status=Enabled
awsceph s3api get-bucket-versioning --bucket "$my_test_bucket"





