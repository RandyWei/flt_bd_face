package com.baidu.idl.face.platform.ui;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;

import com.baidu.idl.face.platform.FaceSDKManager;
import com.baidu.idl.face.platform.ui.utils.IntentUtils;
import com.baidu.idl.face.platform.ui.widget.CircleImageView;
import com.baidu.idl.face.platform.utils.Base64Utils;
import com.baidu.idl.face.platform.utils.DensityUtils;

import dev.bughub.plugin.fltbdface.R;

/**
 * 采集成功页面
 * Created by v_liujialu01 on 2020/4/1.
 */

public class CollectionSuccessActivity extends Activity {
    private static final String TAG = CollectionSuccessActivity.class.getSimpleName();

    private CircleImageView mCircleHead;
    protected String mDestroyType;
    private ImageView mImageCircle;
    private ImageView mImageStar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_collect_success);
        initView();
        initData();
    }

    private void initView() {
        mCircleHead = (CircleImageView) findViewById(R.id.circle_head);
        mImageCircle = (ImageView) findViewById(R.id.image_circle);
        mImageStar = (ImageView) findViewById(R.id.image_star);
    }

    private void initData() {
        Intent intent = getIntent();
        if (intent != null) {
            mDestroyType = intent.getStringExtra("destroyType");
            String bmpStr = IntentUtils.getInstance().getBitmap();
            if (TextUtils.isEmpty(bmpStr)) {
                return;
            }
            Bitmap bmp = base64ToBitmap(bmpStr);
            bmp = FaceSDKManager.getInstance().scaleImage(bmp,
                    DensityUtils.dip2px(getApplicationContext(), 97),
                    DensityUtils.dip2px(getApplicationContext(), 97));
            mCircleHead.setImageBitmap(bmp);
        }

//        Handler handler = new Handler();
//        handler.postDelayed(new Runnable() {
//            @Override
//            public void run() {
//                mImageCircle.setVisibility(View.VISIBLE);
//                mImageStar.setVisibility(View.VISIBLE);
//            }
//        }, 500);
    }

    // 回到首页
    public void onReturnHome(View v) {

    }

    // 重新采集
    public void onRecollect(View v) {
        finish();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        IntentUtils.getInstance().release();
    }

    private Bitmap base64ToBitmap(String base64Data) {
        byte[] bytes = Base64Utils.decode(base64Data, Base64Utils.NO_WRAP);
        return BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
    }
}
