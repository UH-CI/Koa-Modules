#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

oldcwd=`pwd`

module load lmod
spider  -o spider-json  ${MODULEPATH} | python  -mjson.tool  > ${DIR}/modules.json
cd   ${DIR}
python parse.py

mv data.json ../data.json
cd ..

GIT_SSH_COMMAND="ssh -i ${DIR}/id_rsa" git pull --no-edit
git add data.json
git commit -m "`date` modules updated"
GIT_SSH_COMMAND="ssh -i ${DIR}/id_rsa" git push

cd ${oldcwd}
exit 0
