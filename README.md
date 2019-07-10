# ipa _re_sign 

This shell script re_sign an ipa using Apple Enterprise Certificate .

------

## *Preparation*

_1_  ipa file you would like to re_sign

_2_  Apple Enterprise Distribution Certificate [^double click then will found in keychain]

*3*  Distribution mobileprovision file 

*4*  New BundleID in accordance with the mobile provision file in [^3]

------

## *Usage* 

*1*  drag 'Resign.sh' to command line tool

*2*  according to the prompt message, select the distribution certificate which you would like to. Only select the part inside quotes  Eg. <u>iPhone Distribution : ********.co .,LTD.</u>

_3_  drag the ipa file to command line tool 

*4*  drag the mobileprovision file to command line tool 

*5*  input the new BundleID 

*6*  Done !

------

## *Check Dependency*

Including but not limited to the following

*1*  codesign ,

*2*  security ,

*3*  /usr/libexec/PlistBuddy 

_4_ Apple 'wwdr'

# 中文
# ipa_重签名
使用企业证书 对 ipa 进行重签名. 
如果有任何问题,请在issues 中提问.

## 在重签名之前, 准备好如下内容: 
 1. 需要签名的 ipa文件. 
 2. 企业发布证书 (双击后,可在 Mac自带应用‘钥匙串’中查看到). 
 3. 发布描述文件 “*.mobileprovision” .  
 4. 与第‘3’项中描述文件对应的 应用 bundleID .

## 脚本使用
 1. 打开命令行 ‘终端’ 将 Resign.sh 拖入 回车
 2. 按照提示, 选取发布证书 ‘只选取括号内部分 eg.  iPhone Developer: ***********.co ., LTD. ’ 回车
 3. 将ipa 文件拖入命令行 回车
 4. 将 描述文件 ‘*.mobileprovision’ 文件拖入命令行. 回车
 5. 输入新的 BundleID 回车
 6. 如果电脑环境没有问题, 打包能够顺利完成.

## 检查Mac环境: (包括但不限于以下三项)
 1. 命令行输入 whereis codesign
 输出  ‘/usr/bin/codesign’ 表示 OK
 2. 命令行输入 whereis security 
 输出  ‘/usr/bin/security’ 表示 OK
 3. 命令行输入 ls /usr/libexec/PlistBuddy
 输出  ‘usr/libexec/PlistBuddy’ 表示 OK

