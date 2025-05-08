# `publish.sh` — Script para publicar en GitHub Pages

Aquí tienes un **script Bash** que automatiza todo el proceso de compilación y publicación del libro Jupyter Book en la rama `gh-pages` de GitHub; guárdalo en el directorio raíz de tu libro como `publish.sh` y dale permisos de ejecución con `chmod +x publish.sh`.

```bash
#!/bin/bash

# CONFIGURA ESTAS VARIABLES
REPO_URL="https://github.com/TU_USUARIO/TU_REPO.git"
BUILD_DIR="_build/html"
BRANCH="gh-pages"

# Verificación inicial
if [ ! -d "$BUILD_DIR" ]; then
    echo "Directorio $BUILD_DIR no existe. ¿Ejecutaste 'jupyter-book build .'?"
    exit 1
fi

echo "✅ Compilación detectada. Publicando en GitHub Pages..."

# Guardar rama actual
CURRENT_BRANCH=$(git branch --show-current)

# Crear rama gh-pages huérfana (sin historial)
git checkout --orphan $BRANCH

# Eliminar archivos anteriores
git rm -rf . > /dev/null 2>&1

# Copiar archivos HTML compilados al root del repositorio
cp -r $BUILD_DIR/* .

# Evitar que GitHub intente usar Jekyll
touch .nojekyll

# Hacer commit y subir
git add .
git commit -m "🔄 Publicación automática del libro Jupyter Book"
git push -u $REPO_URL $BRANCH --force

# Volver a la rama original
git checkout "$CURRENT_BRANCH"

echo "🌐 Publicado correctamente en https://TU_USUARIO.github.io/TU_REPO/"
```

---

## ✅ Cómo usarlo

1. Sustituye `TU_USUARIO` y `TU_REPO` en el script con los valores reales de tu cuenta y repositorio.

2. Asegúrate de haber corrido antes:

   ```bash
   jupyter-book build .
   git init
   git remote add origin https://github.com/TU_USUARIO/TU_REPO.git
   ```

3. Ejecuta:

   ```bash
   ./publish.sh
   ```

---

¿Quieres que el mismo script construya el libro automáticamente antes de publicarlo, o prefieres hacerlo en dos pasos (compilar y luego publicar)?
