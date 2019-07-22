# ipa _re_sign  

[中文介绍](https://github.com/RookieFeng/ipa_re_sign/blob/master/README_CH)

This shell script re_sign an ipa using Apple Enterprise Certificate .

------

## *Preparation*

_1_ ipa file you would like to re_sign

_2_ Apple Enterprise Distribution Certificate   <u>double click then will found in keychain</u>

*3* Distribution mobileprovision file  <u>*.mobileprovision</u>

*4* New BundleID in accordance with the mobile provision file in [^3]

------

## Usage 

*1*  drag 'Resign_en.sh' to command line tool

*2* according to the prompt message, select the distribution certificate  you would like to use. Only select content within double quotes   Eg. iPhone Distribution : ****.co .,LTD.

_3_ drag the ipa file to command line tool 

*4* drag the mobileprovision file to command line tool 

*5* input the new BundleID 

*6* Done !  (if no error occurs 😂) 

------

## Check Dependency

Including but not limited to the following

*1* check codesign ,

*2* check security ,

*3*  /usr/libexec/PlistBuddy 
