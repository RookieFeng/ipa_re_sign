#! /bin/bash 

#测试 哈哈哈哈哈
#什么情况
# Program : 
#    This program re-sign an ipa with 'Apple Enterprise Certificate' 
# History : 
# 2019/07/05  GuoFeng	First release 

## TODO : 检查签名 命令返回结果 
echo "开始签名"

# 绝对路径: 
work_path=$(dirname $0)
cd ${work_path}

# 设置临时路径
rm -rf tmp target
mkdir tmp target

# 路径设置
CURRENT_PATH=$(pwd)
TMP_PATH="$CURRENT_PATH/tmp"
# IPA_PATH="$CURRENT_PATH/ipa"
SIGNINFO_PATH="$CURRENT_PATH/signInfo"
TARGET_PATH="$CURRENT_PATH/target"


# #读取本地 证书信息
CERTIFICATE=$(security find-identity -v -p codesigning)
echo "$CERTIFICATE"
echo $'************************************* \n请从以上选项中，选择您将用于签名的证书名称（只选择引号中内容)'

read CERT
/usr/libexec/PlistBuddy -c "Set :DistributionCertificateName $CERT" "$SIGNINFO_PATH/signInfo.plist"

# 选择 ipa 文件
echo $'\n************************************* \n请将您要签名的ipa文件拖入此处'
read ORGIPA
/usr/libexec/PlistBuddy -c "Set :IpaPath $ORGIPA" "$SIGNINFO_PATH/signInfo.plist"

# 选择 mobileprovision 文件
echo $'\n*************************************\n请将后缀为'.mobileprovision' 的描述文件拖入此处'
read MobileProvisionPath
/usr/libexec/PlistBuddy -c "Set :MobileProvisionPath $MobileProvisionPath" "$SIGNINFO_PATH/signInfo.plist"

# 选择 BundleID
echo $'\n*************************************\n请输入应用 BundleID'
read BundleID
/usr/libexec/PlistBuddy -c "Set :BundleID $BundleID" "$SIGNINFO_PATH/signInfo.plist"


APPBundleID=$(/usr/libexec/PlistBuddy -c 'Print :'BundleID'' $SIGNINFO_PATH/signInfo.plist)
APPCertificate=$(/usr/libexec/PlistBuddy -c 'Print :'DistributionCertificateName'' $SIGNINFO_PATH/signInfo.plist)
APPMobileProvision=$(/usr/libexec/PlistBuddy -c 'Print :'MobileProvisionPath'' $SIGNINFO_PATH/signInfo.plist)
IPA_PATH=$(/usr/libexec/PlistBuddy -c 'Print :'IpaPath'' $SIGNINFO_PATH/signInfo.plist)

echo -e "*************************************\n 输入信息 完成 \n BundleID : $APPBundleID \n 发布证书名称 : $APPCertificate \n 描述文件 : $APPMobileProvision \n*************************************"
echo "签名执行中, 请等待"

# 创建 Entitlements.plist 文件
# echo "开始 创建 entitlements ..............." 
$(/usr/libexec/PlistBuddy -x -c "print :Entitlements " /dev/stdin <<< $(security cms -D -i $APPMobileProvision) > $TMP_PATH/entitlements.plist)

# echo "创建 entitlements 结束 ..............." 

# echo "解压 $IPA_PATH/*.ipa ............"

unzip -oqq "$IPA_PATH" -d "$TMP_PATH"

# echo "替换BundleID ..............."

PAYLOAD_PATH=$TMP_PATH/Payload

# TODO : find 命令查找
# find  $PAYLOAD_PATH -name "*.app"

APP_NAME=$(ls $PAYLOAD_PATH)

# echo "应用名称: $APP_NAME"
chmod 666 $PAYLOAD_PATH/$APP_NAME/Info.plist

/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier ${APPBundleID}" "$PAYLOAD_PATH/$APP_NAME/Info.plist"

# # 更换 mobileprovision 
# echo "替换描述文件 ..............."
cp $APPMobileProvision $TMP_PATH/Payload/$APP_NAME/embedded.mobileprovision

# # # 设置执行权限  貌似没用
# UNIXFILE="$APP_NAME"
# # echo $UNIXFILE
# x=${UNIXFILE%*.app}
# # echo "x : $x"


# 从info.plist 取出执行文件: CFBundleExecutable
EXECFILE=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleExecutable' $PAYLOAD_PATH/$APP_NAME/Info.plist)
# echo "可执行文件 : $EXECFILE"

# TODO -- 测试此项不做处理
# chmod +x $TMP_PATH/Payload/$APP_NAME/$EXECFILE

# chmod +x $TMP_PATH/Payload/$APP_NAME/sqlite3

# sleep 1

##重签 Frameworks
# echo "签名framework"
APP_PATH=$TMP_PATH/Payload/$APP_NAME
FRAMEWORKS_PATH=$APP_PATH/Frameworks

for  framework  in "$FRAMEWORKS_PATH/"*
do 
	# echo "FRAMEWORK : $framework"
	codesign -fs "$APPCertificate"  $framework 
	# TODO : 检查签名结果
	sleep 0.1
done

# #codesign 
codesign -fs "$APPCertificate" --no-strict --entitlements=$TMP_PATH/entitlements.plist $TMP_PATH/Payload/$APP_NAME


# # 压缩
cd $TMP_PATH/

zip -ryq ../target/Resigned.ipa Payload/

echo -e "*************************************\n !!!APP 签名完成!!! \n ipa文件路径: $TARGET_PATH/Resigned.ipa\n*************************************"

# # 移除tmp 
rm -rf $TMP_PATH 


