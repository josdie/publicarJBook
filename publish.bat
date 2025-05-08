#!/bin/bash

# CONFIGURA ESTAS VARIABLES
REPO_URL="https://github.com/josdie/publicarJBook.git"
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

echo "🌐 Publicado correctamente en https://josdie.github.io/publicarJBook/"