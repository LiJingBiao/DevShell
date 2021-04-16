 #!bin/bash

pro_schema=TLauncher #应用名称

versionName=$1

bundleVersion="$(date +%y%m%d%H%M)"

Production_PROVISIONNING_PROFILE=e723eeed-e542-466f-8215-93a27f74e0f1

BUNDLE_ID=com.systoon.phoenix

basepath=$(cd `dirname $0`; pwd)

pro_project=${pro_schema}.xcodeproj

TARGET_SDK=iphoneos11.3


ipaRelName="$pro_schema"_rel.ipa

buildPath_rel="$pro_schema"_rel

PROJECT_BUILD_DIR="$basepath/$buildPath_rel.build"

xcodebuild clean

./invalidate_pod_use_framework.sh

rm -rf "./$buildPath_rel.build/"

/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${versionName}" "$basepath/$pro_schema/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $bundleVersion" "$basepath/$pro_schema/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier ${BUNDLE_ID}" "$basepath/$pro_schema/Info.plist"

xcodebuild archive -workspace $basepath/$pro_schema.xcworkspace -scheme "$pro_schema" -configuration Release clean archive -archivePath ${PROJECT_BUILD_DIR}'/'${pro_schema}'.xcarchive' #DEVELOPMENT_TEAM=$DEVELOPMENT_TEAM

xcodebuild -exportArchive -archivePath ${PROJECT_BUILD_DIR}'/'$pro_schema'.xcarchive' -exportPath ${PROJECT_BUILD_DIR} -exportOptionsPlist exportOptionsEnterprisePhoenix.plist  PROVISIONING_PROFILE=$Production_PROVISIONNING_PROFILE


rm -rf build/


git -c core.quotepath=false -c log.showSignature=false rm --cached -f -- "$basepath/$pro_schema/Info.plist"
git -c core.quotepath=false -c log.showSignature=false checkout HEAD -- "$basepath/$pro_schema/Info.plist"



echo "打包完毕"


echo "打包完毕,开始上传pgyer"
#
curl -F "file=@$PROJECT_BUILD_DIR/TLauncher.ipa" -F '_api_key=b901e5e58539480d95f6316c489accfc' -F "buildInstallType=1" https://www.pgyer.com/apiv2/app/upload
#
echo "上传pgyer完毕"
