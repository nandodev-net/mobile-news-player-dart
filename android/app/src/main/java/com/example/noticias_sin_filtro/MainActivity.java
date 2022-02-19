package com.example.noticias_sin_filtro;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import ca.psiphon.PsiphonTunnel;

//Note: most of the @override are callbacks from the Psiphon library
public class MainActivity extends FlutterActivity implements PsiphonTunnel.HostService {

    private PsiphonTunnel psiphonTunnel;
    private AtomicInteger localHTTPProxyPort;
    private static final String TAG = "Main Android Activity";
    private MethodChannel.Result methodChannelResult = null;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        BinaryMessenger messenger = flutterEngine.getDartExecutor().getBinaryMessenger();

        // Implementing method Channel to receive message from Dart UI
        MethodChannel vpnConnectionMethodChannel = new MethodChannel(messenger, "noticias_sin_filtro/vpn_connection");
        vpnConnectionMethodChannel.setMethodCallHandler((MethodCall call, MethodChannel.Result result) -> {

            // checking the message received by Dart
            if (call.method.equals("connect")) { //connect with VPN
                methodChannelResult = result; //storing result to call it after callbacks
                this.connect();
                //result.success("Hi");
            } else {
                result.notImplemented();
            }
        });
    }

    // Function that starts the Psiphon Tunnel
    public void connect() {
        localHTTPProxyPort = new AtomicInteger(0);
        psiphonTunnel = PsiphonTunnel.newPsiphonTunnel(this);
        try {
            psiphonTunnel.startTunneling("");
        } catch (PsiphonTunnel.Exception e) {
            Log.e(TAG, e.getMessage());
        }

    }

    // Functions defining PsiphonTunnel.HostService interface (App Name and Psiphon Config)
    @Override
    public String getAppName() {
        return "Noticias Sin Filtro";
    }

    @Override
    public String getPsiphonConfig() {
        try {
            JSONObject config = new JSONObject(
                    readInputStreamToString(
                            getResources().openRawResource(R.raw.psiphon_config)));

            return config.toString();

        } catch (IOException e) {
            Log.e(TAG, "error loading Psiphon config: " + e.getMessage());
        } catch (JSONException e) {
            Log.e(TAG, "error loading Psiphon config: " + e.getMessage());
        }
        return "";
    }


    // Functions to convert Psiphon config to a JSON Object
    private static String readInputStreamToString(InputStream inputStream) throws IOException {
        return new String(readInputStreamToBytes(inputStream), "UTF-8");
    }

    private static byte[] readInputStreamToBytes(InputStream inputStream) throws IOException {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        int readCount;
        byte[] buffer = new byte[16384];
        while ((readCount = inputStream.read(buffer, 0, buffer.length)) != -1) {
            outputStream.write(buffer, 0, readCount);
        }
        outputStream.flush();
        inputStream.close();
        return outputStream.toByteArray();
    }

    //connecting callbacks
    @Override
    public void onConnecting() {
        Log.i(TAG, "Connecting...");
    }

    @Override
    public void onConnected() {
        Log.i(TAG, "Connected!");
        if(methodChannelResult != null) {
            methodChannelResult.success(String.valueOf(localHTTPProxyPort.get()));
        }
    }

    // Set proxy port
    private void setHttpProxyPort(int port) {
        localHTTPProxyPort.set(port);
        Log.i(TAG, "HTTP proxy port: " + localHTTPProxyPort.get());
    }

    @Override
    public void onListeningHttpProxyPort(int port) {
        Log.i(TAG, "local HTTP proxy listening on port: " + Integer.toString(port));
        setHttpProxyPort(port);
    }

    // Log upstream proxy errors
    @Override
    public void onUpstreamProxyError(String message) {
        Log.e(TAG, "upstream proxy error: " + message);
    }

    // Log client region
    @Override
    public void onClientRegion(String region) {
        Log.v(TAG,"client region: " + region);
    }

    @Override
    public Context getContext() {
        return this;
    }

    @Override
    public Object getVpnService() {
        return null;
    }

    @Override
    public Object newVpnServiceBuilder() {
        return null;
    }

    @Override
    public void onDiagnosticMessage(String message) {
        Log.i(TAG, message);
    }

    @Override
    public void onAvailableEgressRegions(List<String> regions) {
        for (String region : regions) {
            Log.i(TAG,"available egress region: " + region);
        }
    }

    @Override
    public void onSocksProxyPortInUse(int port) {
        Log.i(TAG,"local SOCKS proxy port in use: " + Integer.toString(port));
    }

    @Override
    public void onHttpProxyPortInUse(int port) {
        Log.i(TAG,"local HTTP proxy port in use: " + Integer.toString(port));
    }

    @Override
    public void onListeningSocksProxyPort(int port) {
        Log.i(TAG,"local SOCKS proxy listening on port: " + Integer.toString(port));
    }

    // No idea what these functions do but it was on the example app lol
    @Override
    public void onHomepage(String url) {
        Log.i(TAG,"home page: " + url);
    }

    @Override
    public void onClientUpgradeDownloaded(String filename) {
        Log.i(TAG,"client upgrade downloaded");
    }

    @Override
    public void onUntunneledAddress(String address) {
        Log.i(TAG,"untunneled address: " + address);
    }

    @Override
    public void onBytesTransferred(long sent, long received) {
        Log.i(TAG,"bytes sent: " + Long.toString(sent));
        Log.i(TAG,"bytes received: " + Long.toString(received));
    }

    @Override
    public void onStartedWaitingForNetworkConnectivity() {
        Log.i(TAG,"waiting for network connectivity...");
    }

    @Override
    public void onStoppedWaitingForNetworkConnectivity() {
        Log.i(TAG,"finished waiting for network connectivity...");
    }

    @Override
    public void onExiting() {
        Log.i(TAG, "Exiting..");
    }

}