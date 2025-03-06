#!/bin/bash

. $HOME/.bash_profile

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

oldcwd=`pwd`

export MODULEPATH=/usr/share/lmod/lmod/modulefiles/Core
module load lmod
export MODULEPATH=/opt/apps/modules/all

spider  -o spider-json  ${MODULEPATH} | python  -mjson.tool  > ${DIR}/modules.json
cd   ${DIR}
python parse.py
touch ../data.json
# https://stackoverflow.com/questions/12900538/fastest-way-to-tell-if-two-files-have-the-same-contents-in-unix-linux
if cmp --silent -- "../data.json" "data.json"; then
    cd ${DIR}
else
    mv data.json ../data.json
    cd ..

    GIT_SSH_COMMAND="ssh -i ${DIR}/.ssh/id_ed25519" git pull --no-edit
    git add data.json
    git commit -m "`date` modules updated"
    GIT_SSH_COMMAND="ssh -i ${DIR}/.ssh/id_ed25519" git push
fi


    rm ${DIR}/data.json
    rm ${DIR}/modules.json
cd ${oldcwd}
exit 0
