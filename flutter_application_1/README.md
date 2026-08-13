# OptiGest móvil

Port de OptiGest a Flutter, sin WebView.

## Funcionalidades

- Inicio de sesión con validación de campos.
- Panel de indicadores y búsqueda de activos y personal.
- Registro de activos y colaboradores con prevención de duplicados.
- Asignación y devolución de activos; solo se pueden asignar activos disponibles.
- Registro y finalización de mantenimientos; al finalizar, el activo vuelve a estar disponible.
- Catálogos de categorías, roles, proveedores y estados.

Los datos actuales son locales y de demostración. La versión Java incluye solo el inicio de sesión JSON (`/api/login`); para sincronizar todos los módulos hace falta ampliar esa API REST. No se deben incluir credenciales de MySQL en la aplicación móvil.

## Ejecutar

```bash
flutter pub get
flutter run
```

Para generar Android:

```bash
flutter build apk --release
```
