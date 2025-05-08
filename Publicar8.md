# 📄 `generate_toc.py`

Aquí tienes una **versión definitiva del script `generate_toc.py`** que:

* Genera `_toc.yml` con soporte para subdirectorios (estructura jerárquica)
* Crea automáticamente un `index.md` si no existe, con una tabla de enlaces a todos los capítulos detectados

---

```python
import os
import yaml

BOOK_ROOT = "."
TOC_FILE = "_toc.yml"
INDEX_FILE = "index.md"

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

    print(f"✅ '{INDEX_FILE}' creado con enlaces a capítulos.")

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

    with open(os.path.join(BOOK_ROOT, TOC_FILE), "w") as f:
        yaml.dump(toc, f, sort_keys=False)

    print(f"✅ '{TOC_FILE}' generado.")
    generate_index(chapter_titles)

if __name__ == "__main__":
    generate_toc()
```

---

## ✅ ¿Qué hace este script?

1. Escanea el directorio y subdirectorios buscando `.md`.
2. Crea `_toc.yml` con capítulos y subcapítulos jerárquicos.
3. Si no existe `index.md`, lo crea con una tabla de enlaces a los capítulos principales.

---

¿Quieres que también genere automáticamente `_config.yml` si no existe?
