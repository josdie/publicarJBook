# 📄 `generate_toc.py` (versión jerárquica con subdirectorios)

Aquí tienes una versión mejorada del script `generate_toc.py` que **recorre subdirectorios recursivamente** y genera una jerarquía de capítulos y secciones en `_toc.yml` basada en la estructura de carpetas y archivos `.md`.

```python
import os
import yaml

BOOK_ROOT = "."
TOC_FILE = "_toc.yml"

def list_md_files(path):
    """Devuelve los archivos .md en un directorio, ignorando _build, hidden, index.md duplicado."""
    items = []
    for root, dirs, files in os.walk(path):
        # Ignorar carpetas ocultas y _build
        dirs[:] = [d for d in dirs if not d.startswith('.') and d != "_build"]

        rel_root = os.path.relpath(root, BOOK_ROOT)
        if rel_root == ".":
            rel_root = ""

        md_files = [f for f in files if f.endswith(".md") and not f.startswith(".")]
        md_files.sort()

        sections = []
        for f in md_files:
            full_path = os.path.join(rel_root, f).replace("\\", "/")
            file_no_ext = full_path[:-3]  # Quitar ".md"
            if f.lower() in ["index.md", "readme.md"] and rel_root == "":
                continue  # ya se añadirá como raíz
            sections.append({"file": file_no_ext})

        if sections:
            items.append((rel_root, sections))

    return items

def generate_toc():
    toc = {"format": "jb-book", "root": "index", "sections": []}

    folder_structure = list_md_files(BOOK_ROOT)

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
            else:
                # Si no hay index.md, tomar el primero como archivo principal
                first = files[0]
                toc["sections"].append({
                    "file": first["file"],
                    "sections": files[1:]
                })

    with open(os.path.join(BOOK_ROOT, TOC_FILE), "w") as f:
        yaml.dump(toc, f, sort_keys=False)

    print(f"✅ '{TOC_FILE}' generado con estructura jerárquica.")

if __name__ == "__main__":
    generate_toc()
```

---

### ✅ Cómo usarlo

1. Guarda el script como `generate_toc.py` en la raíz del proyecto.
2. Asegúrate de que todos los capítulos (subdirectorios) tengan un `index.md`, si quieres que aparezcan como secciones principales.
3. Ejecuta el script:

```bash
python generate_toc.py
```

Generará un `_toc.yml` con capítulos y subcapítulos correctamente enlazados, usando la estructura de carpetas.

---

¿Quieres que el script también genere un `index.md` si no existe, con una tabla de enlaces automáticos a todos los capítulos?
