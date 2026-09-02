# OptiGest Mobile

Aplicación Flutter con inicio de sesión contra `MobileApiServlet` de OptiGest72 (`/api/login`).

Incluye vistas para activos, personal y asignaciones. Cada vista consulta sus datos al abrirse y permite filtrar o solicitar el listado completo. No utiliza datos de prueba.

## Contrato del API

Además de `POST /api/login`, el servidor desplegado debe publicar estas rutas JSON:

- `GET /api/activos`
- `GET /api/personal`
- `GET /api/asignaciones`

Para filtrar, la aplicación añade `campo` y `valor`, por ejemplo:
`GET /api/activos?campo=codigo&valor=ACT-001`.

Cada ruta puede responder directamente una lista JSON o un objeto que contenga la lista en `data`, `items`, `results`, `activos`, `personal`, `asignaciones` o `records`.

Si el inicio de sesión devuelve `token`, `accessToken` o `access_token`, la aplicación lo envía automáticamente como `Authorization: Bearer <token>` en esas consultas.

Para Flutter Web, el backend también debe aceptar CORS desde el dominio donde se publica la aplicación. Si no envía `Access-Control-Allow-Origin`, el navegador bloquea la consulta aunque la URL sea correcta.

## Ejecutar

```powershell
flutter pub get
flutter run
```

La URL del servidor está en `lib/main.dart`, en la constante `baseUrl`.
