package dev.bughub.plugin.fltbdface.face;

import android.os.Bundle;
import android.view.View;

import com.baidu.idl.face.platform.ui.CollectionSuccessActivity;

/**
 * 采集成功页面
 * Created by v_liujialu01 on 2020/4/1.
 */

public class CollectionSuccessExpActivity extends CollectionSuccessActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    // 回到首页
    public void onReturnHome(View v) {
        super.onReturnHome(v);
        if ("FaceLivenessExpActivity".equals(mDestroyType)) {
//            ExampleApplication.destroyActivity("FaceLivenessExpActivity");
        }
        if ("FaceDetectExpActivity".equals(mDestroyType)) {
//            ExampleApplication.destroyActivity("FaceDetectExpActivity");
        }
        finish();
    }
}
