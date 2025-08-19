# CV Compilation Script

The `compile.sh` script automates the entire CV compilation pipeline locally.

## 🚀 Quick Start

```bash
# From repository root
./scripts/compile.sh
```

## 📋 What It Does

The script performs the complete pipeline:

1. **LaTeX Compilation** - Compiles `template_2/main.tex` to PDF
2. **PNG Conversion** - Converts PDF pages to PNG images in `attachments/output/`
3. **README Generation** - Creates/updates `README.md` with the new images

## 🔧 Options

```bash
./scripts/compile.sh [OPTIONS]
```

| Option | Description |
|--------|-------------|
| `-h, --help` | Show help message |
| `-c, --clean` | Clean build artifacts before compilation |
| `-p, --pdf-only` | Only compile LaTeX (skip PNG & README) |
| `-r, --readme` | Only generate README (skip LaTeX & PNG) |

## 📖 Examples

```bash
# Full pipeline (default)
./scripts/compile.sh

# Clean build and run full pipeline
./scripts/compile.sh --clean

# Only compile LaTeX to PDF
./scripts/compile.sh --pdf-only

# Only generate README
./scripts/compile.sh --readme
```

## 📁 Output Files

After successful compilation:

- **PDF**: `template_2/main.pdf`
- **PNG Pages**: `attachments/output/output-page-0.png`, `output-page-1.png`, etc.
- **Combined PNG**: `attachments/output/output-combined.png`
- **README**: `README.md` (auto-generated)

## ⚠️ Requirements

The script checks for these dependencies:

- **LaTeX**: `xelatex` (XeLaTeX compiler)
- **ImageMagick**: `convert` command
- **Python**: `python3` (for README generation)

## 🚨 Troubleshooting

### LaTeX Compilation Fails
- Check LaTeX syntax in your `.tex` files
- Ensure all required packages are installed
- Check for missing files or incorrect paths

### PNG Conversion Fails
- Verify ImageMagick is installed
- Check if PDF was generated successfully
- Ensure write permissions in `attachments/output/`

### README Generation Fails
- Verify Python 3 is installed
- Check if PNG files exist in `attachments/output/`
- Ensure the script has read/write permissions

## 🔄 Integration with GitHub Actions

This local script mirrors the GitHub Actions workflow:
- **`build-cv.yml`** - Compiles LaTeX and generates PNGs
- **`update-readme.yml`** - Generates README when PNGs change

Use the local script for development and testing, then push to trigger the automated workflow.
