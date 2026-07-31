# OptiGest móvil (Flutter nativo)

Este proyecto porta a Flutter las principales áreas de OptiGest60: inicio de
sesión, panel de control, gestión de activos, gestión de personal, registro de
activos y personal, y accesos a asignaciones, catálogos, mantenimiento e
historial administrativo.

No usa `WebView` ni `webview_flutter`. El error de
`error.isForMainFrame` queda eliminado junto con esa dependencia.

## Importante: conexión a datos

El proyecto de NetBeans recibido es JSP/Servlet y sus rutas (`/Iniciar`,
`/GuardarActivo`, etc.) devuelven páginas HTML; no contiene una API REST/JSON.
Por seguridad una aplicación Android no debe conectarse directamente a MySQL:
la URL, usuario y contraseña se podrían extraer del APK.

La interfaz Flutter funciona hoy con datos iniciales y altas temporales en
memoria. Para que guarde y consulte los mismos datos de Railway se debe exponer
una API autenticada en el servidor Java, por ejemplo:

```
POST /api/v1/auth/login
GET  /api/v1/activos
POST /api/v1/activos
GET  /api/v1/personal
POST /api/v1/personal
```

Luego se reemplaza el estado temporal por peticiones HTTPS a esa API. No hay que
modificar ni publicar las credenciales de MySQL en Flutter.

## Ejecutar

```bash
flutter pub get
flutter run
```

Para el APK:

```bash
flutter build apk --release
```
