# ipa_re_sign
使用企业证书 对 ipa 进行重签名. 
如果有任何问题,请在issues 中提问.

## 在重签名之前, 准备好如下内容: 
 1. 需要签名的 ipa文件. 
 2. 企业发布证书 (双击后,可在 Mac自带应用‘钥匙串’中查看到). 
 3. 发布描述文件 “*.mobileprovision” .  
 4. 与第‘3’项中描述文件对应的 应用 bundleID .

## 脚本使用
 1. 为脚本设置执行权限  例如 : chmod +x ./Resign_en.sh 
 2. 打开命令行 ‘终端’ 将 Resign.sh 拖入 回车
 3. 按照提示, 选取发布证书 ‘只选取括号内部分 eg.  iPhone Developer: ***********.co ., LTD. ’ 回车
 4. 将ipa 文件拖入命令行 回车
 5. 将 描述文件 ‘*.mobileprovision’ 文件拖入命令行. 回车
 6. 输入新的 BundleID 回车
 7. 如果电脑环境没有问题, 打包能够顺利完成.

## 检查Mac环境: (包括但不限于以下三项)
 1. 命令行输入 whereis codesign
 输出  ‘/usr/bin/codesign’ 表示 OK
 2. 命令行输入 whereis security 
 输出  ‘/usr/bin/security’ 表示 OK
 3. 命令行输入 ls /usr/libexec/PlistBuddy
 输出  ‘usr/libexec/PlistBuddy’ 表示 OK

