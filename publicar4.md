# Script completo

Aquí tienes el **script final y completo**, que:

1. **Crea el repositorio en GitHub** (si no existe).
2. **Inicializa Git y configura el remoto**.
3. **Compila tu libro con `jupyter-book`**.
4. **Publica el contenido en la rama `gh-pages`** de GitHub Pages.
5. **Muestra la URL pública de tu libro**.

---

## 📜 `publish_full.sh` — Todo en uno

```bash
#!/bin/bash

# CONFIGURA ESTAS VARIABLES
GITHUB_USER="TU_USUARIO"     # <-- Cámbialo
REPO_NAME="TU_REPO"          # <-- Cámbialo
PRIVATE=false                # true = repositorio privado

REPO_URL="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"
BUILD_DIR="_build/html"
BRANCH="gh-pages"

# Verifica si 'gh' (GitHub CLI) está instalado
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) no está instalado. Instálalo desde https://cli.github.com/"
    exit 1
fi

# Crear repositorio en GitHub si no existe
echo "🔍 Verificando existencia del repositorio $REPO_NAME en GitHub..."
if ! gh repo view "$GITHUB_USER/$REPO_NAME" &>/dev/null; then
    echo "📦 Repositorio no encontrado. Creando..."
    if $PRIVATE; then
        gh repo create "$REPO_NAME" --private --confirm
    else
        gh repo create "$REPO_NAME" --public --confirm
    fi
else
    echo "✅ Repositorio ya existe."
fi

# Inicializar git si no está inicializado
if [ ! -d .git ]; then
    echo "🔧 Inicializando repositorio Git local..."
    git init
    git remote add origin "$REPO_URL"
else
    echo "✅ Repositorio Git local ya existe."
fi

# Compilar el libro
echo "🛠️ Compilando el libro con Jupyter Book..."
jupyter-book build . || { echo "❌ Error al compilar el libro"; exit 1; }

if [ ! -d "$BUILD_DIR" ]; then
    echo "❌ No se encontró el directorio $BUILD_DIR"
    exit 1
fi

# Guardar rama actual
CURRENT_BRANCH=$(git branch --show-current || echo "main")

# Crear y limpiar rama gh-pages
echo "🚀 Publicando el libro en la rama '$BRANCH'..."
git checkout --orphan "$BRANCH"
git rm -rf . > /dev/null 2>&1
cp -r "$BUILD_DIR"/* .
touch .nojekyll

git add .
git commit -m "🚀 Publicación automática del libro Jupyter Book"
git push -u origin "$BRANCH" --force

# Volver a la rama anterior o crearla si no existía
git checkout "$CURRENT_BRANCH" 2>/dev/null || git checkout -b "$CURRENT_BRANCH"

# Mostrar URL final
echo ""
echo "🎉 ¡Tu libro ha sido publicado exitosamente!"
echo "🌐 URL: https://${GITHUB_USER}.github.io/${REPO_NAME}/"
```

---

:::{rubric} ✅ Cómo usarlo
:::

1. **Instala GitHub CLI** si no lo tienes: [https://cli.github.com/manual/installation](https://cli.github.com/manual/installation)

2. **Haz login en GitHub CLI** con:

   ```bash
   gh auth login
   ```

3. **Guarda el script como `publish_full.sh`** en tu directorio del libro.

4. Dale permisos de ejecución:

   ```bash
   chmod +x publish_full.sh
   ```

5. **Edita las variables `GITHUB_USER` y `REPO_NAME`** dentro del script.

6. Ejecuta:

   ```bash
   ./publish_full.sh
   ```

---

¿Quieres que te genere también un archivo `Makefile` para compilar y publicar desde la línea de comandos con `make`?
