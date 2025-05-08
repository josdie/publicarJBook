# Publicar Jupyter Book en GitHub Pages

Paso a paso para subir tu Jupyter Book a GitHub Pages:

:::{rubric} 1. 🧱 Asegúrate de tener estos requisitos
:::

* Cuenta en GitHub.
* Git instalado en tu máquina.
* Tu libro de Jupyter Book funcionando localmente.

---

:::{rubric} 2. 📁 Crea el repositorio en GitHub
:::

1. Entra en [https://github.com](https://github.com) y haz clic en **"New repository"**.
2. Ponle un nombre, por ejemplo: `mi-libro-jupyter`.
3. Marca la opción **"Public"**.
4. NO marques "Initialize with a README".
5. Crea el repositorio.

---

:::{rubric} 3. 🖥️ Conecta tu libro local con GitHub
:::

En tu terminal:

```bash
cd ruta/al/directorio/de/tu/libro
git init
git remote add origin https://github.com/tu_usuario/mi-libro-jupyter.git
```

Agrega un archivo `.gitignore` con esto (si no lo tienes ya):

```bash
_build/
```

---

:::{rubric} 4. 🏗️ Construye el libro
:::

```bash
jupyter-book build .
```

Esto creará los archivos HTML en `_build/html/`.

---

:::{rubric} 5. 🚀 Sube el contenido a GitHub Pages
:::

Usamos la rama `gh-pages` (GitHub Pages puede servir directamente desde esta rama).

```bash
git checkout --orphan gh-pages
rm -rf *
cp -r _build/html/* .
touch .nojekyll  # importante para que GitHub no intente usar Jekyll
git add .
git commit -m "Publicar libro con Jupyter Book"
git push -u origin gh-pages --force
```

---

:::{rubric} 6. 🌍 Activa GitHub Pages
:::

1. En GitHub, ve a tu repositorio → **Settings** → **Pages**.
2. En “Source”, elige:

   * Branch: `gh-pages`
   * Folder: `/ (root)`
3. Espera unos segundos y aparecerá una URL como:

   ```
   https://tu_usuario.github.io/mi-libro-jupyter/
   ```

---

:::{rubric} ✅ ¡Listo!
:::

Tu libro ya está en línea con GitHub Pages.

---

¿Quieres que te prepare un script automatizado para esto o un `Makefile` que lo haga todo con un solo comando?
