# 百度人脸采集SDK Flutter版本

Baidu&#x27;s face recognition SDK encapsulates the flutter version, calls native SDK and interface operations, and returns data to flutter

## 声明

插件是基于百度云人脸离线采集有活体动作版SDK(https://ai.baidu.com/ai-doc/FACE/Ek37c1q2g)进行封装的

在使用插件之前要自行在百度云注册账号，并完成一系列配置之后，阅读 Android:https://ai.baidu.com/ai-doc/FACE/Mk37c1pue#22-%E5%87%86%E5%A4%87%E5%B7%A5%E4%BD%9C iOS:https://ai.baidu.com/ai-doc/FACE/pk37c1qan#221-%E7%94%B3%E8%AF%B7license 文档申请license


## 安装

```
//pub方式
暂无

//导入方式
dependencies:
  flt_video_player:
    git:
      url: https://github.com/RandyWei/flt_bd_face.git
```

### Android

在百度云后台将 安卓-License文件下载后放置于android/app/src/main/assets下，如果没有该目录创建即可

android/app/build.gradle配置如下（以下只保留了本插件需要的配置，忽略了其他）
```
android {

    ....

    //将签名配置完整
    signingConfigs {
        Release {
            keyAlias 'keyAlias'
            keyPassword 'keyPassword'
            storeFile file('storeFile')
            storePassword 'storePassword'
        }
    }

    ....

    buildTypes {
        release {
            signingConfig signingConfigs.Release
            //开启混淆。新版Flutter默认将混淆打开了，所以要配置混淆规则，否则release版本会有问题
            useProguard true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
        debug {
            signingConfig signingConfigs.Release
        }
    }
}
```

混淆规则,也可以直接copy example中的规则文件

```
-keep class com.baidu.** {*;}
-keep class vi.com.** {*;}
-dontwarn com.baidu.**
```

### iOS

使用Xcode打开ios项目

- 将[com.baidu.idl.face.faceSDK.bundle]()和[com.baidu.idl.face.model.bundle]()文件添加到项目中

- 在百度云后台将 iOS-License文件(idl-license.face-ios)下载后添加到项目中