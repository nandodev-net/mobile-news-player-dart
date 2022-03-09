
#  Noticias Sin Filtro - Aplicación

Noticias Sin Filtro es una aplicación de noticias que permite a los usuarios leer diversos artículos periodísticos venezolanos utilizando una conexión VPN preconfigurada, sin necesidad de que los usuarios realicen una configuración adicional en sus teléfonos. Esto permite evadir la censura y los bloqueos locales, al mismo tiempo que protege la identidad de los usuarios.

Para realizar la conexión VPN se utiliza la librería de Psyphon https://github.com/Psiphon-Labs/psiphon-tunnel-core

## Contenido
[Instalación del Proyecto](#instalación)  
[Documentación Librería Psiphon](#psiphon)  
[Conexión Código Plataforma y Flutter](#plataforma)  
- [Conexión VPN con Method Channel](#methodChannel)
- [Embebido de vista nativa con Platform View](#platformView)

<a name="instalación"></a>
## Instalación del Proyecto

Requisitos para ejecutar el proyecto  :
- **Android Studio** (La versión utilizada para el desarrollo fue [Android Studio Bumblebee (2021.1.1)](https://android-developers.googleblog.com/2022/01/android-studio-bumblebee-202111-stable.html), pero en teoría cualquier versión reciente de Android Studio debería ser compatible ). Para ejecutar en el emulador se debe crear un [AVD](https://developer.android.com/studio/run/managing-avds) con algún Android SDK válido (ver la versión mínima en el argumento `minSdkVersion` del archivo`android>app>build.gradle`).
- **XCode**
-  [Flutter](https://docs.flutter.dev/get-started/install), la correcta instalación se verifica utilizando el comando `flutter doctor`

Luego de tener instalados los requisitos, se debe abrir el proyecto en XCode o Android Studio. En el archivo `pubspec.yaml` se encuentran todas las dependencias con sus respectivas versiones, si el IDE no las descarga por defecto se debe ejecutar el comando `pub get`

Además de las dependencias de Flutter, se tiene una dependencia asociada a cada plataforma por separado: la librería de Psiphon. Se debe asegurar que los gestores de dependencias de Android (Gradle) y de iOS las descarguen correctamente. En caso de que no sea así se debe abrir el proyecto Android o iOS por separado y "refrescar" la descarga de la dependencia en el IDE.

Como en cualquier proyecto de Flutter el entrypoint se hace a través de `lib>main.dart`

<a name="psiphon"></a>
## Lo que se conoce sobre la librería Psiphon

La librería a utilizar es de uso interno a la empresa Psiphon y se tiene poca información sobre los métodos de la misma. Sin embargo, se asume cierto comportamiento de la misma luego de observación del [código de ejemplo](https://github.com/Psiphon-Labs/psiphon-tunnel-core/tree/master/MobileLibrary/Android/SampleApps), la definición de  [Psiphon Tunnel](https://github.com/Psiphon-Labs/psiphon-tunnel-core/blob/83a68bcb5a470928b87c3b91fbe972ab8eb981e5/MobileLibrary/Android/PsiphonTunnel/PsiphonTunnel.java) , la definición de [Psiphon Manager](https://github.com/zhlgh603/psiphon/blob/master/Android/app/src/main/java/com/psiphon3/psiphonlibrary/TunnelManager.java) y de la [implementación](https://github.com/Psiphon-Inc/psiphon-android) de la librería por parte del equipo Psiphon.


### Para Android (en Java)

Para importar la librería se utiliza: ```import ca.psiphon.PsiphonTunnel;```

La actividad donde se coloca debe implementar la interface `PsiphonTunnel.HostService`

Cuando se crea la actividad se debe inicializar el tunel de Psiphon de la siguiente manera:
`mPsiphonTunnel = PsiphonTunnel.newPsiphonTunnel(this);`. Así se configura  `mPsiphoneTunnel` . Sin embargo, para inicializarlo se debe llamar a `mPsiphonTunnel.startTunneling("");`. Se cree que es posible elegir que servidor o región se debe utilizar pero no se tiene seguridad sobre qué tipo de parámetros se deben pasar al método para ello.

El método `mPsiphonTunnel.startTunneling("");` crea una conexión o "tunel" entre el dispositivo y los servidores VPN. Ésto lo hace a partir de enlazar un puerto local con el servidor VPN. Es importante saber que éste no es siempre un mismo puerto, Psiphon lo elige aparentemente al azar.

Toda petición que desee utilizar el servicio de VPN debe enrutar la petición HTTP a ese puerto local con el túnel. Es decir, ese puerto local es un proxy que permite la conexión con el servidor VPN

Además,  `mPsiphonTunnel.startTunneling("");`es un método asíncrono, eso quiere decir que retorna inmediatamente sin esperar a que termine la configuración. Si se llama luego de haber creado una conexión, realiza una desconexión del servidor actual y conecta de nuevo a otro servidor.

Para que éste método funciones se debe cargar la configuración a través del método `getPsiphonConfig( )` , este método va a apuntar hacia un recurso (`R`) que tiene el archivo de configuración de Psiphon
```Java
@Override

public String getPsiphonConfig() {

try {

JSONObject config = new JSONObject(

readInputStreamToString(

getResources().openRawResource(R.raw.psiphon_config)));

return config.toString();

} catch (IOException e) {

logMessage("error loading Psiphon config: " + e.getMessage());

} catch (JSONException e) {

logMessage("error loading Psiphon config: " + e.getMessage());

}

return "";

}

// Esta otras funciones lo único que hacen es convertir el stream de bytes en un formato legible
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
```

Luego cuando se desee terminar el tunel de conexión se debe llamar al método
`  mPsiphonTunnel.stop();`, el cual elimina el tunel VPN generado


El resto de los métodos en el [archivo de ejemplo](https://github.com/Psiphon-Labs/psiphon-tunnel-core/blob/master/MobileLibrary/Android/SampleApps/TunneledWebView/app/src/main/java/ca/psiphon/tunneledwebview/MainActivity.java)   son "*callbacks*" que son llamados cuando la conexión pasa a cierto estado. Entre éstos *callbacks* los más importantes son:
-  `onListeningHttpProxyPort(int port )`:  se llama cuando Psiphone ya ha elegido un puerto local HTTP como puerto proxy.  Esta función es una de las más importantes ya que es usada para capturar el puerto que actuará como proxy VPN

```Java
@Override
public void onListeningHttpProxyPort(int port) {

logMessage("local HTTP proxy listening on port: " + Integer.toString(port));

setHttpProxyPort(port);

}

// ésta otra función es un simple setter
private void setHttpProxyPort(int port) {
mLocalHttpProxyPort.set(port);

}

```
- `onConnected( )`: se llama cuando se ha establecido un tunel VPN  correctamente y se ha terminado todo el proceso interno de Psiphon de elegir un servidor y conectarlo al puerto local.
- `onBytesTransferred( )`: se dispara cuando se empieza a intercambiar información a través del tunel VPN, permite comprobar que efectivamente se está utilizando el VPN
- `onConnecting( )`: se dispara cuando empieza el proceso de conexión.
- `onExiting()`: se dispara cuando empieza el proceso de desconexión


El resto de los callbacks sirve para proporcionar información sobre varios detalles del VPN (región cliente, regiones disponibles, etc)

<a name="plataforma"></a>
## Conexión código "Plataforma" - Flutter

Existen dos momentos particulares en los que se deben utilizar los métodos nativos de iOS y Android. El primero para realizar levantar la conexión VPN del Psiphon y el segundo para hacer el redireccionamiento de la conexión del webview al puerto proxy conectado el VPN.


La secuencia de interacción de la aplicación luce algo así:


**Para levantar conexión VPN**
![Secuencia de Levantamiento de Conexión](/docs/images/image1.jpeg "Secuencia de Levantamiento de Conexión")
**Para desconectar el VPN:**
![Secuencia de Desconexión](/docs/images/image2.jpeg "Secuencia de Desconexión")
**Para mostrar la webview Nativa:**
![Webview Nativa](/docs/images/image2.jpeg "Webview Nativa")

A continuación se explicará cada secuencia con un poco más de detalle:

<a name="methodChannel"></a>
###  VPN Connection Platform Channel
Como la librería Psiphon no está disponible para flutter, se debe hacer uso de código específico de Android y iOS. Para ello se usa la herramienta de flutter conocida como [Platform Channels](https://docs.flutter.dev/development/platform-integration/platform-channels). Se recomienda observar [éste video](https://www.youtube.com/watch?v=RYH2YVUsNW4) para comprender mejor su funcionamiento

Los Platform Channels permiten al código de Flutter interactuar con métodos nativos y regresar el resultado al código de flutter. En éste caso se define un method channel llamado `vpn_connection`

```Java
final MethodChannel _VPNconnectionMethodChannel = MethodChannel("noticias_sin_filtro/vpn_connection");
```

A través de éste method channel se exponen dos métodos `connect` y `disconnect`.  El método `connect` se encarga de inicial el túnel Psiphon y garantiza la conexión, éste método devuelve un número de puerto. Éste puerto local debe ser utilizado como proxy para las peticiones HTTP subsecuentes. Éstos métodos pueden ser invocados de la siguiente manera:

```dart
String proxyPort = await _VPNconnectionMethodChannel.invokeMethod("connect");
```
```dart
String result = await _VPNconnectionMethodChannel.invokeMethod("disconnect");
```

A nivel de soporte nativo se desarrolla el manejador de éstos métodos. Al iniciar la aplicación se llama al método `connect`

#### Manejador de Method Channel en  Android.
El manejador del *method channel* está localizado en la actividad principal.

```Java
// Implementing method Channel to receive message from Flutter UI  
MethodChannel vpnConnectionMethodChannel = new MethodChannel(messenger, "noticias_sin_filtro/vpn_connection");  
vpnConnectionMethodChannel.setMethodCallHandler((MethodCall call, MethodChannel.Result result) -> {  
  
    // checking the message received by Dart  
  if (call.method.equals("connect")) { //connect with VPN  
  methodChannelResult = result; //storing result to call it after callbacks  
  this.connect();  
  
  } else if (call.method.equals("disconnect")) {  
        psiphonTunnel.stop();  
  result.success("Disconnected");  
  }  
    else {  
        result.notImplemented();  
  }  
});
```
Para regresar el resultado del method channel se hace uso de una instancia de  MethodChannel.Result. Sin embargo, como el método de conexión es asíncrono, se guarda el MethodChannel.Result como un atributo de la clase y es disparado nuevamente cuando se ejecuta el método callback `onConnected`, es en éste método donde se envía el puerto local hacia el código Flutter

```Java
@Override  
public void onConnected() {  
    Log.i(TAG, "Connected!");  
 if(methodChannelResult != null) {  
        methodChannelResult.success(String.valueOf(localHTTPProxyPort.get()));  
  }  
}
```
#### Manejador de Method Channel en iOS

Por hacer

<a name="platformView"></a>
###  Webview with Platform View

El [plugin de webview de flutter](https://pub.dev/packages/webview_flutter) no permite crear un proxy dinámico. Por ello se ha recurrido a utilizar la webview nativa de Android y iOS con la [configuración de proxy](https://raw.githubusercontent.com/Psiphon-Labs/psiphon-tunnel-core/master/MobileLibrary/Android/SampleApps/TunneledWebView/app/src/main/java/ca/psiphon/tunneledwebview/WebViewProxySettings.java) que realizó el equipo de Psiphon en su [aplicación de ejemplo](https://github.com/Psiphon-Labs/psiphon-tunnel-core/tree/master/MobileLibrary/Android/SampleApps).

Para inyectar la vista nativa se hace uso de lo que se conoce como [Platform Views](https://docs.flutter.dev/development/platform-integration/platform-views). Ésto permite inyectar la vista nativa como un widget de flutter. Existen dos maneras de hacerlo pero se optó por utilizar "*Hybrid composition*" que permite conservar el manejo del teclado, gestos y la accesibilidad en las vistas inyectadas.

Cuando se le da click a un item de noticia (`list_item)` desde el listView de noticias, se ingresa en el widget `WebviewWrapper`. Éste widget sin estado envuelve la vista nativa y la muestra, agregandole un appbar y detalles posteriores

```Dart
class WebviewWrapper extends StatelessWidget {  
  const WebviewWrapper({Key? key, required this.url, this.port = "" }) : super(key: key);  
 final String url;  
 final String port;  
  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        title: const Text('Webview Interna'),  
  ),  
  body: NativeWebViewPlatform(url: url, port: port)  
    );  
  }
```

Los widget pasan el puerto proxy por el constructor desde el widget de conexión. La clase `native_webview.dart` tiene la configuración del [PlatformViewLink](https://api.flutter.dev/flutter/widgets/PlatformViewLink-class.html) y pasa el puerto a la vista nativa a través de el Map `creationParams`
```dart
Map<String, dynamic> creationParams = <String, dynamic> {"url": url, "port": port};
```

#### Renderizado de la vista en Android

La vista es registrada como un Plugin en el archivo `NativeWebviewPlugin.java` y se crea una factory de la misma en `NativeWebviewFactory.java`. En la actividad principal se registra la vista nativa usando el Flutter Engine.
```java
flutterEngine  
        .getPlatformViewsController()  
        .getRegistry()  
        .registerViewFactory("<platform-webview>", new NativeWebviewFactory());
```

En el archivo `NativeWebview.java` se encuentra el código como tal de la actividad. La función `getParams` se utiliza para tomar los parámetros que vienen desde el código Flutter, luego se inicializa el webview con su configuración correspondiente y se utiliza la clase `WebviewProxySettings` que fue tomada de la [aplicación ejemplo de Psiphon](https://raw.githubusercontent.com/Psiphon-Labs/psiphon-tunnel-core/master/MobileLibrary/Android/SampleApps/TunneledWebView/app/src/main/java/ca/psiphon/tunneledwebview/WebViewProxySettings.java) para configurar el proxy de la webview

```Java
// start the native Webview  
webview = (WebView) new WebView(context);  
WebSettings webSettings = webview.getSettings();  
webSettings.setJavaScriptEnabled(true);  
webview.setWebViewClient(new WebViewClient());  
  
if(!port.equals("")) {  
    WebViewProxySettings.setLocalProxy(this.getView().getContext(), Integer.parseInt(port));  
}  
  
  
webview.loadUrl(url);
```

#### Renderizado de la vista en iOS

Por hacer
