#!/bin/sh
#
# GH_PAT: a github personal access token
# VALUES: a key value list (e.g. foo=bar,baz=qux)
# VALUES_FILE: a file path of helm values.yaml
# DRY_RUN: set if run without remote changes
# GIT_MESSAGE: a commit message

set -ex

git clone https://${GH_PAT}@github.com/nokamoto/demo20-apps-config.git

cd demo20-apps-config

app

git diff

if [ -z "${DRY_RUN}" ]
then
    git config --local user.email "nokamoto.engr@gmail.com"
    git config --local user.name "nokamoto"
    git add .
    git commit -m "${GIT_MESSAGE}"
    git push origin master
fi
