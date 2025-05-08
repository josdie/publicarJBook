# Archivo `Makefile`

Aquí tienes un **archivo `Makefile`** que te permite compilar y publicar tu Jupyter Book con comandos simples como `make build` y `make publish`. Guárdalo en el directorio raíz de tu proyecto:

```makefile
# Configura tu usuario y repositorio de GitHub
GITHUB_USER = TU_USUARIO
REPO_NAME = TU_REPO
REPO_URL = https://github.com/$(GITHUB_USER)/$(REPO_NAME).git
BUILD_DIR = _build/html
BRANCH = gh-pages

# Objetivo por defecto
all: build

# Compilar el libro
build:
	jupyter-book build .

# Publicar en GitHub Pages
publish: build
	@echo "🌐 Publicando el libro..."
	@git checkout --orphan $(BRANCH)
	@rm -rf * .[^.]*
	@cp -r $(BUILD_DIR)/* .
	@touch .nojekyll
	@git add .
	@git commit -m "🚀 Publicación automática del libro Jupyter Book"
	@git push -u $(REPO_URL) $(BRANCH) --force
	@git checkout main || git checkout -b main
	@echo "✅ Publicado en: https://$(GITHUB_USER).github.io/$(REPO_NAME)/"

# Limpiar la carpeta de construcción
clean:
	rm -rf _build

# Crear repositorio remoto si no existe (requiere gh)
create-repo:
	gh repo create $(REPO_NAME) --public --confirm
	@git init
	@git remote add origin $(REPO_URL)

.PHONY: all build publish clean create-repo
```

---

## ✅ Cómo usarlo

1. Sustituye `TU_USUARIO` y `TU_REPO` por tus datos reales.
2. Asegúrate de tener `jupyter-book`, `git`, y `gh` instalados y configurados.
3. Luego puedes ejecutar:

```bash
make build       # Compila el libro
make publish     # Compila y publica en gh-pages
make clean       # Elimina la carpeta _build
make create-repo # (Opcional) Crea el repositorio remoto con GitHub CLI
```

---

¿Te gustaría que agregue soporte para entornos virtuales (con `venv` o `conda`) también en el `Makefile`?
