#!/bin/sh

# we need to cd into the repo directory since the default working dir is its parent
cd $WORKING_DIRECTORY

if [ -z "$DATREE_TOKEN" ]; then
    echo "No account token configured, see https://github.com/datreeio/action-datree for instructions"
    exit 1
fi

if [ "$IS_HELM_CHART" = true ]; then
    helm datree test $INPUT_PATH $CLI_ARGUMENTS -- $HELM_ARGUMENTS
elif [ "$IS_KUSTOMIZATION" = true ]; then
    datree kustomize test $INPUT_PATH $CLI_ARGUMENTS -- $KUSTOMIZE_ARGUMENTS
else
    datree test $INPUT_PATH $CLI_ARGUMENTS  
fi