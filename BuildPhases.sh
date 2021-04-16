#!/bin/bash
#设置build version
SetBuildVersion(){
  if [[ "$CONFIGURATION" != "Debug" ]]; then
    build_version=$(date +%y%m%d%H%M)
    echo "build_version${build_version}"
    /usr/libexec/PlistBuddy -c "Set CFBundleVersion ${build_version}" ${INFOPLIST_FILE}
fi
}
#获取README.md命令执行
UpdateLibrary(){
  awk '/^TN/{ cmd=$0; system(cmd) }' ${SRCROOT}/../README.md
}
