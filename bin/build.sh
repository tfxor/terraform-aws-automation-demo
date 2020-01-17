#!/usr/bin/env bash

aws --version > /dev/null 2>&1 || { echo >&2 "[ERROR]: aws is missing. aborting..."; exit 1; }
npm --version > /dev/null 2>&1 || { echo >&2 "[ERROR]: npm is missing. aborting..."; exit 1; }
terrahub --version > /dev/null 2>&1 || { echo >&2 "[ERROR]: terrahub is missing. aborting..."; exit 1; }

export NODE_PATH="$(npm root -g)"
export npm_config_unsafe_perm="true"

if [ "${CODEBUILD_WEBHOOK_EVENT}" == "PULL_REQUEST_MERGED" ]; then CICD_STATE="approve"; fi
if [ ! -z "${CODEBUILD_WEBHOOK_BASE_REF}" ]; then BRANCH_TO="${CODEBUILD_WEBHOOK_BASE_REF/refs\/heads\//}"; fi
if [ ! -z "${CODEBUILD_WEBHOOK_HEAD_REF}" ]; then BRANCH_FROM="${CODEBUILD_WEBHOOK_HEAD_REF/refs\/heads\//}"; fi
if [ -z "${BRANCH_TO}" ]; then BRANCH_TO="dev"; fi
if [ -z "${BRANCH_FROM}" ]; then BRANCH_FROM="dev"; fi

CICD_OPTS=""
if [ "${BRANCH_TO}" != "dev" ]; then CICD_OPTS="${CICD_OPTS} -e ${BRANCH_TO}"; fi
if [ "${BRANCH_TO}" != "${BRANCH_FROM}" ]; then CICD_OPTS="${CICD_OPTS} -g ${BRANCH_TO}..${BRANCH_FROM}"; fi
if [ "${CICD_STATE}" == "build" ]; then CICD_OPTS="${CICD_OPTS} -b"; fi
if [ "${CICD_STATE}" == "build&approve" ]; then CICD_OPTS="${CICD_OPTS} -b -a"; fi
if [ "${CICD_STATE}" == "approve" ]; then CICD_OPTS="${CICD_OPTS} -a"; fi
if [ "${CICD_STATE}" == "approve&destroy" ]; then CICD_OPTS="${CICD_OPTS} -a -d"; fi
if [ "${CICD_STATE}" == "destroy" ]; then CICD_OPTS="${CICD_OPTS} -d"; fi
if [ ! -z "${CICD_INCLUDE}" ]; then CICD_OPTS="${CICD_OPTS} -I \"^(${CICD_INCLUDE})\""; fi
if [ ! -z "${CICD_EXCLUDE}" ]; then CICD_OPTS="${CICD_OPTS} -X \"^(${CICD_EXCLUDE})\""; fi

echo "EXEC: aws sts get-caller-identity"
AWS_ACCOUNT_ID="$(aws sts get-caller-identity --output=text --query='Account')"
terrahub configure -c template.locals.account_id="${AWS_ACCOUNT_ID}"

echo "EXEC: terrahub run -y -p include ${CICD_OPTS}"
terrahub run -y -p include ${CICD_OPTS}
