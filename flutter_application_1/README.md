# OptiGest Mobile

Aplicación Flutter con inicio de sesión contra `MobileApiServlet` de OptiGest72 (`/api/login`).

Incluye vistas de filtro para activos, personal y asignaciones. No presenta registros ni utiliza datos de prueba: el `MobileApiServlet` recibido solamente expone el inicio de sesión. Para que las búsquedas devuelvan resultados, el backend debe publicar endpoints JSON autenticados para esas tres consultas.

## Ejecutar

```powershell
flutter pub get
flutter run
```

La URL del servidor está en `lib/main.dart`, en la constante `baseUrl`.
