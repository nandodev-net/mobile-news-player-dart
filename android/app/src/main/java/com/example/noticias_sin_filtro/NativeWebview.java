package com.example.noticias_sin_filtro;
import android.content.Context;
import android.graphics.Color;
import android.util.Log;
import android.view.View;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.platform.PlatformView;
import java.util.Map;

public class NativeWebview implements PlatformView{
    @NonNull private final WebView webview;
    private static final String TAG = "Native Webview Activity";
    private String port;
    private String url;

    NativeWebview(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams) {
        getParams(creationParams);
        Log.i(TAG, "url=" + url);
        Log.i(TAG, "port= "+port);

        // start the native Webview
        webview = (WebView) new WebView(context);
        WebSettings webSettings = webview.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webview.setWebViewClient(new WebViewClient());

        if(!port.equals("")) {
            WebViewProxySettings.setLocalProxy(this.getView().getContext(), Integer.parseInt(port));
        }


        webview.loadUrl(url);

    }

    @NonNull
    @Override
    public View getView() {
        return webview;
    }

    @Override
    public void dispose() {}


    private void getParams(Map<String,Object> params) {
        for ( Map.Entry<String,Object> param: params.entrySet()) {

            if(param.getKey().equals("url")){
                url = (String) param.getValue();
            }

            if(param.getKey().equals("port")){
                port = (String) param.getValue();
            }

           // Log.i(TAG, "param="+ param.getKey()+" value="+ param.getValue());
        }
    }
}
