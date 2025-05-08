# 📄 `generate_book_structure.py`

Aquí tienes la **versión definitiva y automática** del script `generate_book_structure.py` que:

* Genera `_toc.yml` con jerarquía
* Genera `index.md` con tabla de capítulos si no existe
* Genera `_config.yml` básico si no existe

```python
import os
import yaml

BOOK_ROOT = "."
TOC_FILE = "_toc.yml"
INDEX_FILE = "index.md"
CONFIG_FILE = "_config.yml"

def list_md_files(path):
    items = []
    for root, dirs, files in os.walk(path):
        dirs[:] = [d for d in dirs if not d.startswith('.') and d != "_build"]

        rel_root = os.path.relpath(root, BOOK_ROOT)
        if rel_root == ".":
            rel_root = ""

        md_files = [f for f in files if f.endswith(".md") and not f.startswith(".")]
        md_files.sort()

        sections = []
        for f in md_files:
            full_path = os.path.join(rel_root, f).replace("\\", "/")
            file_no_ext = full_path[:-3]
            if f.lower() in ["index.md", "readme.md"] and rel_root == "":
                continue
            sections.append({"file": file_no_ext})

        if sections:
            items.append((rel_root, sections))

    return items

def generate_index(chapter_titles):
    if os.path.exists(INDEX_FILE):
        print(f"ℹ️ '{INDEX_FILE}' ya existe, no se sobrescribirá.")
        return

    with open(INDEX_FILE, "w", encoding="utf-8") as f:
        f.write("# Bienvenido al libro 📘\n\n")
        f.write("## Tabla de capítulos\n\n")
        for path, title in chapter_titles:
            link = f"[{title}]({path}/index.md)" if path else f"[{title}](index.md)"
            f.write(f"- {link}\n")

    print(f"✅ '{INDEX_FILE}' creado.")

def generate_config():
    if os.path.exists(CONFIG_FILE):
        print(f"ℹ️ '{CONFIG_FILE}' ya existe, no se sobrescribirá.")
        return

    config = {
        "title": "Mi Libro con Jupyter Book",
        "author": "Autor Desconocido",
        "language": "es",
        "logo": "",
        "only_build_toc_files": True
    }

    with open(CONFIG_FILE, "w", encoding="utf-8") as f:
        yaml.dump(config, f, sort_keys=False)

    print(f"✅ '{CONFIG_FILE}' generado.")

def generate_toc():
    toc = {"format": "jb-book", "root": "index", "sections": []}
    folder_structure = list_md_files(BOOK_ROOT)
    chapter_titles = []

    for folder, files in folder_structure:
        if folder == "":
            toc["sections"].extend(files)
        else:
            chapter_file = os.path.join(folder, "index.md")
            if os.path.exists(chapter_file):
                toc["sections"].append({
                    "file": f"{folder}/index",
                    "sections": files
                })
                chapter_titles.append((folder, os.path.basename(folder).capitalize()))
            else:
                first = files[0]
                toc["sections"].append({
                    "file": first["file"],
                    "sections": files[1:]
                })

    with open(os.path.join(BOOK_ROOT, TOC_FILE), "w", encoding="utf-8") as f:
        yaml.dump(toc, f, sort_keys=False)

    print(f"✅ '{TOC_FILE}' generado.")
    generate_index(chapter_titles)

if __name__ == "__main__":
    generate_toc()
    generate_config()
```

---

:::{rubric} 🚀 ¿Cómo usarlo?

1. Guarda el script como `generate_book_structure.py` en la raíz de tu libro.

2. Instala `pyyaml` si aún no lo tienes:

   ```bash
   pip install pyyaml
   ```

3. Ejecútalo:

   ```bash
   python generate_book_structure.py
   ```

Y listo: tu libro tendrá estructura, portada y configuración básica.

---

¿Quieres que este script también cree carpetas vacías para capítulos si no existen, como `capitulo1/index.md` si lo defines tú antes?
