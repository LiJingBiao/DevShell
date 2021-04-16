#!/usr/bin/env bash

git pull

pro_schema=TLauncher #应用名称

relVersion=7.0.0
bundleVersion="$(date +%y%m%d%H%M)"



Production_PROVISIONNING_PROFILE=821907f3-34e5-4125-8a1a-9f6d17be4862

#############################共用参数  #############################

basepath=$(cd `dirname $0`; pwd)

pro_project=${pro_schema}.xcodeproj

TARGET_SDK=iphoneos11.3


#############################个性化参数参数  #############################

#############################测试包  #############################
ipaRelName="$pro_schema"_rel.ipa

buildPath_rel="$pro_schema"_rel

PROJECT_BUILD_DIR="$basepath/$buildPath_rel.build"

xcodebuild clean

rm -rf "./$buildPath_rel.build/"


/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $relVersion" "$basepath/$pro_schema/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $bundleVersion" "$basepath/$pro_schema/Info.plist"

xcodebuild archive -workspace $basepath/$pro_schema.xcworkspace -scheme "$pro_schema" -configuration Release clean archive -archivePath ${PROJECT_BUILD_DIR}'/'${pro_schema}'.xcarchive'

xcodebuild -exportArchive -archivePath ${PROJECT_BUILD_DIR}'/'$pro_schema'.xcarchive' -exportPath ${PROJECT_BUILD_DIR} -exportOptionsPlist exportOptionsEnterprise.plist  PROVISIONING_PROFILE=$Production_PROVISIONNING_PROFILE


rm -rf build/

git -c core.quotepath=false -c log.showSignature=false rm --cached -f -- "$basepath/$pro_schema/Info.plist"
git -c core.quotepath=false -c log.showSignature=false checkout HEAD -- "$basepath/$pro_schema/Info.plist"


echo
echo "打包完毕,开始上传pgyer"

curl -F "file=@$PROJECT_BUILD_DIR/TLauncher.ipa" -F '_api_key=b901e5e58539480d95f6316c489accfc' -F "buildInstallType=1" https://www.pgyer.com/apiv2/app/upload

rm -rf "./$buildPath_rel.build/"

echo
echo "打包上传完毕"

exit