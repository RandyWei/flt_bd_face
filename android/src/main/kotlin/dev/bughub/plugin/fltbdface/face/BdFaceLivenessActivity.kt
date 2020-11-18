package dev.bughub.plugin.fltbdface.face

import android.Manifest
import android.annotation.TargetApi
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.widget.Toast
import com.baidu.idl.face.platform.ui.FaceLivenessActivity
import java.util.*

//
//class BdFaceLivenessActivity : FaceLivenessActivity() {
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        requestPermissions(99, Manifest.permission.CAMERA)
//        //人脸检测的活体动作
//    }
//
//    override fun onLivenessCompletion(status: FaceStatusEnum, message: String, base64ImageMap: HashMap<String, String>?) {
//        super.onLivenessCompletion(status, message, base64ImageMap)
//        if (status == FaceStatusEnum.OK && mIsCompletion) {
//            base64ImageMap?.let { baseImages ->
//                baseImages["bestImage0"]?.let {
//                    val data = Intent()
//                    data.putExtra("data", it)
//                    setResult(10001, data)
//                    finish()
////                    ApiBdFace().doFaceMatch(loginName, it, object : Network.OnResponseBaseListener {
////                        override fun onSuccess() {
////                            isFaceLived = true
////                            isFaceLivedBack = false
////                            toastResult.text = "人脸识别成功"
////                            Handler().postDelayed({ finish() }, 2000)
////                            setResult(Activity.RESULT_OK)
////                        }
////
////                        override fun onFailure(status: Int, message: String?) {
////                            isFaceLived = false
////                            isFaceLivedBack = true
////                            toastResult.text = "人脸识别失败$message"
////                            Handler().postDelayed({ finish() }, 3000)
////                        }
////
////                        override fun onError(message: String?) {
////                            isFaceLived = false
////                            isFaceLivedBack = true
////                            toastResult.text = "人脸识别失败$message"
////                            Handler().postDelayed({ finish() }, 3000)
////                        }
////                    })
//                }
//            }
//
//        } else if (status == FaceStatusEnum.Error_DetectTimeout ||
//                status == FaceStatusEnum.Error_LivenessTimeout ||
//                status == FaceStatusEnum.Error_Timeout) {
//            Toast.makeText(this, "采集超时", Toast.LENGTH_LONG).show()
//        }
//    }
//
//    private fun requestPermissions(requestCode: Int, permission: String?) {
//        if (permission != null && permission.isNotEmpty()) {
//            try {
//                if (Build.VERSION.SDK_INT >= 23) {
//                    // 检查是否有权限
//                    val hasPer = checkSelfPermission(permission)
//                    if (hasPer != PackageManager.PERMISSION_GRANTED) {
//                        // 是否应该显示权限请求
//                        // val isShould = shouldShowRequestPermissionRationale(permission)
//                        requestPermissions(arrayOf(permission), requestCode)
//                    }
//                } else {
//
//                }
//            } catch (ex: Exception) {
//                ex.printStackTrace()
//            }
//
//        }
//    }
//
//    @TargetApi(Build.VERSION_CODES.M)
//    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>,
//                                            grantResults: IntArray) {
//        var flag = false
//        for (i in permissions.indices) {
//            if (PackageManager.PERMISSION_GRANTED == grantResults[i]) {
//                flag = true
//            }
//        }
//        if (!flag) {
//            requestPermissions(99, Manifest.permission.CAMERA)
//        }
//    }
//}