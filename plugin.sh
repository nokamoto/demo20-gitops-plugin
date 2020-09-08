#!/bin/sh
#
# GH_PAT: a github personal access token
# DRY_RUN: set if run without remote changes
#
# tag rewrite mode:
# VALUES: a key value list (e.g. foo=bar,baz=qux)
# VALUES_FILE: a file path of helm values.yaml
# GIT_MESSAGE: a commit message
#
# merge mode:
# GIT_BRANCH: a target git branch
# GIT_SHA: a merged commit

set -ex

git clone https://${GH_PAT}@github.com/nokamoto/demo20-apps-config.git

cd demo20-apps-config

git config --local user.email "nokamoto.engr@gmail.com"
git config --local user.name "nokamoto"

if [ -n "${GIT_BRANCH}" ]
then
    git fetch
    git checkout $GIT_BRANCH
    git merge $GIT_SHA

    if [ -z "${DRY_RUN}" ]
    then
        git push origin $GIT_BRANCH
    fi
else
    app

    git diff

    if [ -z "${DRY_RUN}" ]
    then
        git add .
        git commit -m "${GIT_MESSAGE}"
        git push origin master
    fi
fi
