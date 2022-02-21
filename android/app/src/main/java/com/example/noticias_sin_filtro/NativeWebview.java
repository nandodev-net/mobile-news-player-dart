package com.example.noticias_sin_filtro;
import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.platform.PlatformView;
import java.util.Map;

public class NativeWebview implements PlatformView{
    @NonNull private final WebView webview;

    NativeWebview(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams) {

        webview = (WebView) new WebView(context);
        WebSettings webSettings = webview.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webview.loadUrl("https://whatismyipaddress.com/");
    }

    @NonNull
    @Override
    public View getView() {
        return webview;
    }

    @Override
    public void dispose() {}
}
