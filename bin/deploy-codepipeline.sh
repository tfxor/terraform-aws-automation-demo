#!/usr/bin/env bash

aws --version > /dev/null 2>&1 || { echo >&2 "aws is missing. aborting..."; exit 1; }
npm --version > /dev/null 2>&1 || { echo >&2 "npm is missing. aborting..."; exit 1; }
export NODE_PATH="$(npm root -g)"

if [ -z "${BRANCH_FROM}" ]; then BRANCH_FROM = "dev"; fi
if [ -z "${BRANCH_TO}" ]; then BRANCH_TO = "dev"; fi
if [ "${BRANCH_TO}" != "dev" ]; then THUB_ENV="-e ${BRANCH_TO}"; fi
if [ "${THUB_STATE}" == "approved" ]; then THUB_APPLY="-a"; fi

git --version > /dev/null 2>&1 || { echo >&2 "git is missing. aborting..."; exit 1; }
git checkout $BRANCH_TO
git checkout $BRANCH_FROM

terrahub --version > /dev/null 2>&1 || { echo >&2 "terrahub is missing. aborting..."; exit 1; }
AWS_ACCOUNT_ID="$(aws sts get-caller-identity --output=text --query='Account')"
terrahub configure -c template.locals.account_id="${AWS_ACCOUNT_ID}"

echo "terrahub run -y -b ${THUB_APPLY} ${THUB_ENV}"
terrahub run -y -b ${THUB_APPLY} ${THUB_ENV}

echo "Execution successful: from ${BRANCH_FROM} into ${BRANCH_TO}"
