# !/bin/bash

#
# 联系方式 :
# BY
# qiubaiying@gamil.com
# GitHub: https://github.com/qiubaiying/iOSAutoArchiveScript
# 原作者:jkpang GitHub: https://github.com/jkpang

#
# =============================== 该脚本在最新的 Ruby 2.4.0 下运行会出错 ====================
# =============================== 使用前请先切换旧的 Ruby 版本 =============================
# https://github.com/jkpang/PPAutoPackageScript/issues/1


# 使用方法:
# step1 : 将iOSAutoArchiveScript整个文件夹拖入到项目主目录,项目主目录,项目主目录~~~(重要的事情说3遍!😊😊😊)
# step2 : 打开iOSAutoArchiveScript.sh文件,修改 "项目自定义部分" 配置好项目参数
# step3 : 打开终端, cd到iOSAutoArchiveScript文件夹 (ps:在终端中先输入cd ,直接拖入iOSAutoArchiveScript文件夹,回车)
# step4 : 输入 sh iOSAutoArchiveScript.sh 命令,回车,开始执行此打包脚本

# ===============================项目自定义部分(自定义好下列参数后再执行该脚本)============================= #
# 计时
SECONDS=0
# 是否编译工作空间 (例:若是用Cocopods管理的.xcworkspace项目,赋值true;用Xcode默认创建的.xcodeproj,赋值false)
is_workspace="true"
# 指定项目的scheme名称
# (注意: 因为shell定义变量时,=号两边不能留空格,若scheme_name与info_plist_name有空格,脚本运行会失败,暂时还没有解决方法,知道的还请指教!)
scheme_name="you_scheme_name"
# 工程中Target对应的配置plist文件名称, Xcode默认的配置文件为Info.plist
info_plist_name="Info"
# 指定要打包编译的方式 : Release,Debug，或者自定义的编译方式
build_configuration="AdHoc"

# ===============================项目上传部分============================= #
# 上传到fir <https://fir.im>，
# 需要先安装fir的命令行工具 
# gem install fir-cli
# 是否上传到fir，是true 否false
is_fir="true"
# 在 fir 上的API Token
fir_token="you_fir_Token"

# ===============================自动打包部分(无特殊情况不用修改)============================= #

# 导出ipa所需要的plist文件路径 (默认为AdHocExportOptionsPlist.plist)
ExportOptionsPlistPath="./iOSAutoArchiveScript/AdHocExportOptionsPlist.plist"
# 返回上一级目录,进入项目工程目录
cd ..
# 获取项目名称
project_name=`find . -name *.xcodeproj | awk -F "[/.]" '{print $(NF-1)}'`
# 获取版本号,内部版本号,bundleID
InfoPlistPath="$project_name/$info_plist_name.plist"
bundle_version=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" $InfoPlistPath`
bundle_build_version=`/usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" $InfoPlistPath`
bundle_identifier=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $InfoPlistPath`


# 指定输出ipa路径
export_path=~/AutoArchive/$scheme_name-IPA
# 指定输出归档文件地址
export_archive_path="$export_path/$scheme_name.xcarchive"
# 指定输出ipa地址
export_ipa_path="$export_path"
# 指定输出ipa名称 : scheme_name + bundle_version
ipa_name="$scheme_name-v$bundle_version"


# AdHoc,AppStore,Enterprise三种打包方式的区别: http://blog.csdn.net/lwjok2007/article/details/46379945
echo "================请选择打包方式(输入序号,按回车即可)================"
echo "                1 AdHoc       内测        "
echo "                2 AppStore    上架        "
echo "                3 Enterprise  企业        "
echo "                4 Exit        退出        "
echo "================请选择打包方式(输入序号,按回车即可)================"
# 读取用户输入并存到变量里
read parameter
sleep 0.5
method="$parameter"

# 判读用户是否有输入
if [ -n "$method" ]
then
    if [ "$method" = "1" ] ; then
    ExportOptionsPlistPath="./iOSAutoArchiveScript/AdHocExportOptionsPlist.plist"
    elif [ "$method" = "2" ] ; then
    ExportOptionsPlistPath="./iOSAutoArchiveScript/AppStoreExportOptionsPlist.plist"
    elif [ "$method" = "3" ] ; then
    ExportOptionsPlistPath="./iOSAutoArchiveScript/EnterpriseExportOptionsPlist.plist"
    elif [ "$method" = "4" ] ; then
    echo "退出！"
    exit 1
    else
    echo "输入的参数无效，请重新选择!!!"
    exit 1
    fi
fi

echo "**************************删除旧编译文件与ipa...*********************************"
# 删除旧.xcarchive文件
rm -rf ~/AutoArchive/$scheme_name-IPA/$scheme_name.xcarchive
# 删除旧.xcarchive文件
rm -rf ~/AutoArchive/$scheme_name-IPA/$ipa_name.ipa

echo "**************************开始编译代码...*********************************"
# 指定输出文件目录不存在则创建
if [ -d "$export_path" ] ; then
echo $export_path
else
mkdir -pv $export_path
fi

# 判断编译的项目类型是workspace还是project
if $is_workspace ; then
# 编译前清理工程
xcodebuild clean -workspace ${project_name}.xcworkspace \
                 -scheme ${scheme_name} \
                 -configuration ${build_configuration}

xcodebuild archive -workspace ${project_name}.xcworkspace \
                   -scheme ${scheme_name} \
                   -configuration ${build_configuration} \
                   -archivePath ${export_archive_path}
else
# 编译前清理工程
xcodebuild clean -project ${project_name}.xcodeproj \
                 -scheme ${scheme_name} \
                 -configuration ${build_configuration}

xcodebuild archive -project ${project_name}.xcodeproj \
                   -scheme ${scheme_name} \
                   -configuration ${build_configuration} \
                   -archivePath ${export_archive_path}
fi

#  检查是否构建成功
#  xcarchive 实际是一个文件夹不是一个文件所以使用 -d 判断
if [ -d "$export_archive_path" ] ; then
echo " ✅  ✅  ✅  ✅  ✅  ✅  编译成功  ✅  ✅  ✅  ✅  ✅  ✅  "
else
echo " ❌  ❌  ❌  ❌  ❌  ❌  编译失败  ❌  ❌  ❌  ❌  ❌  ❌  "
exit 1
fi

echo "**************************开始导出ipa文件....*********************************"
# Xcode9需要加上 -allowProvisioningUpdates 
# 详情看:https://github.com/fastlane/fastlane/issues/9589
xcodebuild  -exportArchive \
            -archivePath ${export_archive_path} \
            -exportPath ${export_ipa_path} \
            -exportOptionsPlist ${ExportOptionsPlistPath} \
            -allowProvisioningUpdates
# 修改ipa文件名称
mv $export_ipa_path/$scheme_name.ipa $export_ipa_path/$ipa_name.ipa

# 检查文件是否存在
if [ -f "$export_ipa_path/$ipa_name.ipa" ] ; then
echo "🎉  🎉  🎉  🎉  🎉  🎉  ${ipa_name} 打包成功! 🎉  🎉  🎉  🎉  🎉  🎉  "
open $export_path
else
echo "❌  ❌  ❌  ❌  ❌  ❌  ${ipa_name} 打包失败! ❌  ❌  ❌  ❌  ❌  ❌  "
exit 1
fi

# 输出打包总用时
echo "打包总用时: ${SECONDS}s ~~~~~~~~~~~~~~~~"

# 上传
if $is_fir ; then
echo "**************************开始上传ipa文件....*********************************"
fir publish "$export_ipa_path/$ipa_name.ipa" -T ${fir_token}
echo "fir publish "$export_ipa_path/$ipa_name.ipa" -T ${fir_token}"
echo "总计用时:${SECONDS}"
else
exit 1
fi
