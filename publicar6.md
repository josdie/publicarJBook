# 🛠️ Opción automática: script para generar `_toc.yml`


Aquí tienes un **script en Python** que recorre los archivos `.md` del directorio (exceptuando `README.md` o `index.md` si ya existe) y genera una tabla de contenidos válida:

---

## 📄 `generate_toc.py`

```python
import os
import yaml

# Configura el archivo de salida
toc_file = "_toc.yml"
book_root = "."

# Detecta archivos Markdown válidos
md_files = [f for f in os.listdir(book_root)
            if f.endswith(".md") and f not in ("README.md", "index.md")]

# Ordena alfabéticamente para consistencia
md_files.sort()

# Crea la estructura del TOC
toc = [{"file": "index"}]  # Página inicial (puede ser index.md o README.md)

for f in md_files:
    name = os.path.splitext(f)[0]
    toc.append({"file": name})

# Guarda en _toc.yml
with open(os.path.join(book_root, toc_file), "w") as f:
    yaml.dump({"format": "jb-book", "root": "index", "sections": toc[1:]}, f, sort_keys=False)

print(f"✅ Archivo '{toc_file}' generado con {len(md_files)} secciones.")
```

---

## ✅ Cómo usarlo

1. Guarda ese script como `generate_toc.py` en la raíz de tu libro.

2. Asegúrate de tener instalado `pyyaml` si aún no lo tienes:

   ```bash
   pip install pyyaml
   ```

3. Ejecuta el script:

   ```bash
   python generate_toc.py
   ```

Esto generará un archivo `_toc.yml` que puedes usar directamente con `jupyter-book build`.

---

## 📝 Nota

Este script supone una estructura plana (sin subcarpetas). Si tienes carpetas con `.md`, puedo darte una versión que las incluya jerárquicamente.

¿Tu libro tiene subdirectorios que también quieres incluir en la tabla de contenidos?
