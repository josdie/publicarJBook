Perfecto. Aquí tienes el **script completo mejorado**, que **compila el libro y lo publica en GitHub Pages**, todo en un solo paso:

---

## 📜 `publish.sh` (versión todo-en-uno)

```bash
#!/bin/bash

# CONFIGURACIÓN: edita estas líneas con tus datos
REPO_URL="https://github.com/TU_USUARIO/TU_REPO.git"  # <-- Cámbialo
BRANCH="gh-pages"
BUILD_DIR="_build/html"

# PARTE 1: Compilar el libro
echo "🛠️ Compilando el libro con Jupyter Book..."
jupyter-book build . || { echo "❌ Error al compilar el libro"; exit 1; }

# Verifica que el directorio generado existe
if [ ! -d "$BUILD_DIR" ]; then
    echo "❌ No se encontró el directorio $BUILD_DIR"
    exit 1
fi

# Guardar rama actual
CURRENT_BRANCH=$(git branch --show-current)

# PARTE 2: Crear rama huérfana y copiar archivos compilados
echo "📁 Preparando rama '$BRANCH' para publicación..."
git checkout --orphan "$BRANCH"
git rm -rf . > /dev/null 2>&1

# Copiar el contenido compilado
cp -r $BUILD_DIR/* .

# Añadir archivo para desactivar Jekyll
touch .nojekyll

# Publicar
git add .
git commit -m "🚀 Publicación automática del libro Jupyter Book"
git push -u "$REPO_URL" "$BRANCH" --force

# Volver a la rama original
git checkout "$CURRENT_BRANCH"

echo "✅ Libro publicado con éxito en:"
echo "   🌐 https://$(echo "$REPO_URL" | sed -E 's|https://github.com/([^/]+)/([^\.]+)\.git|\1.github.io/\2|')/"
```

---

## ✅ Instrucciones para usarlo

1. Guarda el archivo como `publish.sh` en la raíz de tu libro.

2. Dale permisos de ejecución:

   ```bash
   chmod +x publish.sh
   ```

3. Asegúrate de tener el repo inicializado y el remoto añadido:

   ```bash
   git init
   git remote add origin https://github.com/TU_USUARIO/TU_REPO.git
   ```

4. Ejecuta el script:

   ```bash
   ./publish.sh
   ```

---

Este script se encarga de todo: **compila**, **borra lo anterior**, **sube los archivos a `gh-pages`** y te da la **URL final** para compartir tu libro.

¿Quieres que también cree el repositorio automáticamente si no existe aún?
