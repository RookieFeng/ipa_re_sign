#! /bin/bash 

# Program : 
#    This program re-sign an ipa with 'Apple Enterprise Certificate' 
# History : 
# 2019/07/05  GuoFeng	First release 

## TODO : check command result
echo "Start Signing"

# absolute path : 
work_path=$(dirname $0)
cd ${work_path}

# temp path
rm -rf tmp target
mkdir tmp target

CURRENT_PATH=$(pwd)
TMP_PATH="$CURRENT_PATH/tmp"
# IPA_PATH="$CURRENT_PATH/ipa"
SIGNINFO_PATH="$CURRENT_PATH/signInfo"
TARGET_PATH="$CURRENT_PATH/target"


## get codesigning certificate install in Mac
CERTIFICATE=$(security find-identity -v -p codesigning)
echo "$CERTIFICATE"
echo $'************************************* \nPlease select one certificate you would like to use (Only select content within double quotes)'

read CERT
/usr/libexec/PlistBuddy -c "Set :DistributionCertificateName $CERT" "$SIGNINFO_PATH/signInfo.plist"

# choose ipa file 
echo $'\n************************************* \nPlease drag in the ipa file'
read ORGIPA
/usr/libexec/PlistBuddy -c "Set :IpaPath $ORGIPA" "$SIGNINFO_PATH/signInfo.plist"

# choose mobileprovision file
echo $'\n*************************************\nPlease drag in the mobileprovision file'
read MobileProvisionPath
/usr/libexec/PlistBuddy -c "Set :MobileProvisionPath $MobileProvisionPath" "$SIGNINFO_PATH/signInfo.plist"

# input BundleID
echo $'\n*************************************\nPlease Input the BundleID'
read BundleID
/usr/libexec/PlistBuddy -c "Set :BundleID $BundleID" "$SIGNINFO_PATH/signInfo.plist"


APPBundleID=$(/usr/libexec/PlistBuddy -c 'Print :'BundleID'' $SIGNINFO_PATH/signInfo.plist)
APPCertificate=$(/usr/libexec/PlistBuddy -c 'Print :'DistributionCertificateName'' $SIGNINFO_PATH/signInfo.plist)
APPMobileProvision=$(/usr/libexec/PlistBuddy -c 'Print :'MobileProvisionPath'' $SIGNINFO_PATH/signInfo.plist)
IPA_PATH=$(/usr/libexec/PlistBuddy -c 'Print :'IpaPath'' $SIGNINFO_PATH/signInfo.plist)

echo -e "*************************************\n Ready ! \n BundleID : $APPBundleID \n Distribution certificate name : $APPCertificate \n mobileprovision file : $APPMobileProvision \n*************************************"
echo -e "Please wait for a litte while \nSigning ... "

# create Entitlements.plist file
# echo "start creating entitlements ..............." 
$(/usr/libexec/PlistBuddy -x -c "print :Entitlements " /dev/stdin <<< $(security cms -D -i $APPMobileProvision) > $TMP_PATH/entitlements.plist)

# echo "entitlements created ..............." 

# echo "unzip $IPA_PATH/*.ipa ............"

unzip -oqq "$IPA_PATH" -d "$TMP_PATH"

# echo "replace BundleID ..............."

PAYLOAD_PATH=$TMP_PATH/Payload

# TODO : use appropriate command to find the .app file 
# find  $PAYLOAD_PATH -name "*.app"

APP_NAME=$(ls $PAYLOAD_PATH)

# echo "app name : $APP_NAME"
chmod 666 $PAYLOAD_PATH/$APP_NAME/Info.plist

/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier ${APPBundleID}" "$PAYLOAD_PATH/$APP_NAME/Info.plist"

# # replace  mobileprovision 
# echo "replace mobileprovision file  ..............."
cp $APPMobileProvision $TMP_PATH/Payload/$APP_NAME/embedded.mobileprovision

# Set execution permissions --- maybe unnecessary
# UNIXFILE="$APP_NAME"
# # echo $UNIXFILE
# x=${UNIXFILE%*.app}
# # echo "x : $x"


# get value for key 'CFBundleExecutable' from Info.plist 
EXECFILE=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleExecutable' $PAYLOAD_PATH/$APP_NAME/Info.plist)
# echo "executable file : $EXECFILE"

# TODO -- checkout if necessary 
# chmod +x $TMP_PATH/Payload/$APP_NAME/$EXECFILE

# re_sign Frameworks
# echo "sign framework"
APP_PATH=$TMP_PATH/Payload/$APP_NAME
FRAMEWORKS_PATH=$APP_PATH/Frameworks

for  framework  in "$FRAMEWORKS_PATH/"*
do 
	# echo "FRAMEWORK : $framework"
	codesign -fs "$APPCertificate"  $framework 
	# TODO : check sign result 
	sleep 0.1   # Just sleep for a little while 
done

# #codesign 
codesign -fs "$APPCertificate" --no-strict --entitlements=$TMP_PATH/entitlements.plist $TMP_PATH/Payload/$APP_NAME


# zip
cd $TMP_PATH/

zip -ryq ../target/Resigned.ipa Payload/

echo -e "*************************************\n !!! APP signed !!! \n ipa path: $TARGET_PATH/Resigned.ipa\n*************************************"

# remove tmp 
rm -rf $TMP_PATH 