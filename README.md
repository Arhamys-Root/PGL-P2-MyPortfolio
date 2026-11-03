# nocheislas

A new Flutter project.

## CRUD de elementos

Desde el Drawer, abre **Mis elementos**. Puedes añadir elementos con nombre,
descripción breve y categoría y borrarlos. El contador se actualiza
con la lista y cada categoría muestra una imagen local (ocio nocturno o
videojuegos). El formulario valida los campos obligatorios.

El botón **Borrar todos** permite vaciar la lista tras confirmar en un modal.
Cancelar conserva los elementos. El botón se desactiva cuando la lista está vacía.

Los elementos se guardan en memoria mientras la pantalla permanece abierta;
al salir de ella o reiniciar la aplicación la lista se vacía.

Validación: `flutter analyze` y `flutter test`.

## Capturas de pantalla

Capturas de la aplicación funcionando en el emulador Android.

### Elementos: lista vacía

![Lista vacía con contador a cero](assets/images/elements_empty.png)

### Formulario para añadir un elemento

![Diálogo con nombre, descripción breve y selector de categoría](assets/images/elements_form.png)

### Lista dinámica de elementos

![Elemento añadido con imagen de categoría, botón de borrado y contador actualizado](assets/images/elements_list.png)

### Inicio

![Pantalla de inicio](assets/images/welcome_photo.png)

### Perfil

![Pantalla de perfil](assets/images/perfil_photo.png)

### Hobbies

![Pantalla de hobbies](assets/images/hobbies_photo.png)
