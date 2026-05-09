##############  Chinese  ##############

### 目录
- EZOpenSDK:静态库SDK。
- EZOpenSDKDemo：示例代码工程，Demo运行步骤如下:
    1.使用Xcode打开demo工程
    2.删除目录中红色的文件(shell、EZOpenSDK)
    3.将EZOpenSDK拖入demo工程(勾选Copy items if needed)
    4.bundle id和证书改成自己的
    5.见注意事项第1点
- README.text：集成必读文档，一些说明及注意事项。
- ReleaseNotes.text：发布说明。

### 注意事项
1.Demo工程中在EZOpenSDKDemo.entitlements中配置了com.apple.developer.networking.multicast权限，某些iOS系统在局域网设备搜索的时候需要用到此权限。如果你的证书中没有申请该权限，可以把该上述的配置删掉，保证demo能正常运行。
2.如使用海外版本Demo，请将PrefixHeader.pch文件中宏定义设置为1。
3.请务必按照官网的集成步骤来集成。很多开发者反馈集成编译不通过或者程序崩溃，都是因为未看文档或者不按步骤操作导致的。
4.集成SDK时，请确保com.hri.hpc.mobile.ios.player.metallib和openssl库 资源文件已经加入到你的 XCode 项目工程中，否则会导致程序崩溃。(openssl版本号为1.1.1 v，如果项目中有其他版本的openssl或者其他三方SDK中内置了其他版本的openssl，可能会在使用某些功能的时候导致程序崩溃，请做好openssl库的适配，或者谨慎升级EZOpenSDK。动态库中已经内置openssl，使用动态库不会有上述崩溃问题)
5.优先参照EZOpenSDKDemo中的功能代码，官网中的代码更新可能有延迟或缺失。
6.SDK支持的最低系统版本为iOS 11。

### 常用文档链接
集成文档：https://open.ys7.com/help/43
错误码文档：https://open.ys7.com/help/37
发布日志文档：https://open.ys7.com/help/40
Demo apk使用指南：https://open.ys7.com/bbs/article/108
SDK常见问题指南：https://open.ys7.com/bbs/article/98

### 问题反馈
请先查看【错误码文档】和【SDK常见问题指南】能否解决你的问题。
如果未解决，请先自行运行Demo，确保问题能在Demo上复现。如不能复现，请参考Demo实现；
如能复现，请先填写【工单】并提供以下信息：
问题详细描述+官网demo (不是客户App) 启动至问题复现过程的完整日志（Ctrl+A, Ctrl+C复制出来）



##############  English  ##############

### Catalogue
- EZOpenSDK:Static library.
- EZOpenSDKDemo:Sample code project. The steps to run the demo are as follows:
    1. Open the demo project using Xcode
    2. Delete the red files in the directory (shell, EZOpenSDK)
    3. Drag the EZOpenSDK into the demo project (check Copy items if needed)
    4. Change the bundle ID and certificate to your own
    5. See point 1 of the precautions
- README.text:Integration required document, some descriptions and precautions.
- ReleaseNotes.text:Release notes.

### Descriptions and precautions
1.In the demo project, com.apple.developer.networking.multicast permission has been configured in EZOpenSDKDemo.Entitlements. Some iOS systems require this permission when searching for LAN devices. If you do not apply for this permission in your certificate, you can delete the above configuration to ensure that the demo can run normally.
2.If you are using an overseas version demo, please set the macro definition in the PrefixHeader.pch file to 1.
3.Please follow the integration steps on the official website. Many developers reported that the integration compilation failed or the program crashed because they did not read the document or did not follow the steps.
4.When integrating the SDK, please ensure that the com.hri.hpc.mobile.ios.player.metallib and OpenSSL library resource file has been added to your Xcode project, otherwise the program will crash.(The OpenSSL version number is 1.1.1u. If there are other versions of OpenSSL in the project or other versions of OpenSSL are built in other third-party SDKs, the program may crash when using some functions. Please adapt the OpenSSL library or carefully upgrade the ezopensdk. Openssl has been built into the dynamic library, and use the dynamic library will not cause the above crash problem)
5.The function code in ezopensdkdemo is preferred. The code update in the official website may be delayed or missing.
6.The minimum system version supported by the SDK is iOS 11.

### Common document links
Integrated document：https://open.ys7.com/help/en/491
ErrorCode document：https://open.ys7.com/help/37
ReleaseNotes document：https://open.ys7.com/help/40
Demo apk Usage guide：https://open.ys7.com/bbs/article/108
SDK common question guide：https://open.ys7.com/bbs/article/98

### Problem feedback
Please first review the 'Error Code Document' and 'SDK FAQ Guide' to see if they can solve your problem.
If the issue is not resolved, please run the demo yourself first to ensure that the problem can be reproduced on the demo. If it cannot be reproduced, please refer to the demo implementation;
If it can be reproduced, please fill out the 'Work Order' first and provide the following information:
Detailed description of the problem+complete log of the problem reproduction process from the launch of the official website demo (not the customer app) (Ctrl+A, Ctrl+C copied out)
