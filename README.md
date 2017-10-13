# iOSAutoArchiveScript

> 本脚本修改自:<https://github.com/jkpang/PPAutoPackageScript>,十分感谢该作者！

~~## 注意：不能使用 ruby 2.4.0 运行该脚本~~


该脚本在最新的 `Ruby 2.4.0` 下运行会出错（在 macOS 10.12.3 或是 10.12.4 下会编译失败，系统更新到 macOS 10.12.5 后，一切正常）



若是编译错误（一般是在导出 .ipa 包这一步），请先切换旧的 Ruby 版本再进行编译,

查看的自己 ruby 版本

	$ ruby -v
	
	ruby 2.3.3p222
	
切换 ruby 版本

 如 `2.3.3`
 
	$ rvm install 2.3.3 --disable-binary
	$ rvm use 2.3.3 --default 

## 使用方法

1. ~~切换 ruby 版本 `小于 2.4.0`~~

2. 将 **iOSAutoArchiveScript 文件夹** 拖入到项目 **主目录！**

3. 打开 `iOSAutoArchiveScript.sh` 文件,修改 **项目自定义部分参数**，一般只需要修改两个参数 `scheme_name` 和 `build_configuration`

4. 打开终端, cd 到 **iOSAutoArchiveScript文件夹**，运行脚本

    	$ sh iOSAutoArchiveScript.sh


最终会在桌面生成：

![](https://ww3.sinaimg.cn/large/006tNc79gy1ff27d438voj30f70avmyc.jpg)

## 上传到 Fir

添加了将ipa包上传到 [Fir](https://fir.im/) 的功能

要使用fir的上传功能，需要安装fir的命令行工具

	gem install fir-cli

修改配置

	is_fir="true"
	fir_token="FirAPIToken"
`FirAPIToken` 在[官网](https://fir.im/)获取

![](https://ww4.sinaimg.cn/large/006tNc79gy1ff2878x1a8j304t07bt8r.jpg)

这样，导出 ipa包 成功时，就能顺带上传到 fir 了。

## 利用 自定义终端指令 简化打包过程

以zsh为例:

	open ~/.zshrc

添加自定义命令 `cd + sh`

	alias mybuild='cd 项目地址/iOSAutoArchiveScript/ &&  sh 项目地址/iOSAutoArchiveScript/iOSAutoArchiveScript.sh'
	
这样打开终端输入`mybuild`，就可以轻松实现一键打包上传了
