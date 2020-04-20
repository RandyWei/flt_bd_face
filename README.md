# 百度人脸采集SDK Flutter版本

Baidu&#x27;s face recognition SDK encapsulates the flutter version, calls native SDK and interface operations, and returns data to flutter

## 安装

```
//pub方式
dependencies:
  flt_bd_face: ^0.0.4

//导入方式
dependencies:
  flt_video_player:
    git:
      url: https://github.com/RandyWei/flt_bd_face.git
```

### Android
android/app/build.gradle配置如下
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
