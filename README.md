
#  Noticias Sin Filtro - Aplicación

Noticias Sin Filtro es una aplicación de noticias que permite a los usuarios leer diversos artículos periodísticos venezolanos utilizando una conexión VPN preconfigurada, sin necesidad de que los usuarios realicen una configuración adicional en sus teléfonos. Esto permite evadir la censura y los bloqueos locales, al mismo tiempo que protege la identidad de los usuarios.

Para realizar la conexión VPN se utiliza la librería de Psyphon https://github.com/Psiphon-Labs/psiphon-tunnel-core


# Instalación del Proyecto

Requisitos para ejecutar el proyecto  :
- **Android Studio** (La versión utilizada para el desarrollo fue [Android Studio Bumblebee (2021.1.1)](https://android-developers.googleblog.com/2022/01/android-studio-bumblebee-202111-stable.html), pero en teoría cualquier versión reciente de Android Studio debería ser compatible ). Para ejecutar en el emulador se debe crear un [AVD](https://developer.android.com/studio/run/managing-avds) con algún Android SDK válido (ver la versión mínima en el argumento `minSdkVersion` del archivo`android>app>build.gradle`).
- **XCode**
-  [Flutter](https://docs.flutter.dev/get-started/install), la correcta instalación se verifica utilizando el comando `flutter doctor`

Luego de tener instalados los requisitos, se debe abrir el proyecto en XCode o Android Studio. En el archivo `pubspec.yaml` se encuentran todas las dependencias con sus respectivas versiones, si el IDE no las descarga por defecto se debe ejecutar el comando `pub get`

Además de las dependencias de Flutter, se tiene una dependencia asociada a cada plataforma por separado: la librería de Psiphon. Se debe asegurar que los gestores de dependencias de Android (Gradle) y de iOS las descarguen correctamente. En caso de que no sea así se debe abrir el proyecto Android o iOS por separado y "refrescar" la descarga de la dependencia en el IDE.

# Lo que se conoce sobre la librería Psiphon

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

// Esta otras funciones lo único que hace es convertir el stream de bytes en un formato legible
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


# Conexión código "Plataforma" - Flutter

-platform channel para agarrar el puerto
- platform views
- webview flutter no da soporte nativo
