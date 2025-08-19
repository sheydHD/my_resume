# Dynamic README Generation Scripts

This directory contains scripts for automatically generating and updating the main README.md file.

## 🚀 How It Works

### 1. **GitHub Actions Workflow** (`.github/workflows/update-readme.yml`)
- **Triggers**: Automatically runs when PNG files in `attachments/output/` or PDFs are pushed to the `master` branch
- **Actions**: 
  - **Completely removes** existing README.md
  - Sets up Python environment
  - Runs the README generation script to create a **completely fresh** README
  - Commits and pushes changes back to the repository

### 2. **Main Script** (`generate_readme.py`)
- **Purpose**: Generates a **completely clean and minimal** README with only CV pages
- **Features**:
  - **Always starts fresh** - no existing content is preserved
  - Automatically detects PNG files in `attachments/output/`
  - Generates appropriate descriptions for each CV page
  - Creates a **naked, minimal** README with just the CV pages
  - Sorts pages in correct numerical order

### 3. **Test Script** (`test_readme_generation.py`)
- **Purpose**: Test the README generation locally before pushing
- **Usage**: Run from repository root to verify everything works

## 📋 Requirements

- **Python 3.7+** (uses only standard library modules)
- **GitHub Actions** enabled for the repository
- **Write permissions** for the GitHub Actions bot

## 🔧 Usage

### Local Testing
```bash
# From repository root
python3 scripts/test_readme_generation.py
```

### Manual Generation
```bash
# From repository root
python3 scripts/generate_readme.py
```

### Automatic Generation
The README is automatically updated whenever you:
1. Push changes to PNG files in `attachments/output/`
2. Push changes to PDF files in `template_2/out/`
3. Push to the `master` branch

## 📁 File Structure

```
scripts/
├── generate_readme.py      # Main generation script
├── test_readme_generation.py # Local testing script
├── requirements.txt         # Dependencies (none required)
└── README.md              # This file
```

## 🔄 Workflow

1. **You make changes** to your CV LaTeX files
2. **You compile** the PDF and generate PNG previews in `attachments/output/`
3. **You push** the changes to GitHub
4. **GitHub Actions** automatically detects the PNG/PDF changes
5. **Existing README is completely removed** for fresh start
6. **The script runs** and generates a **completely new** README.md
7. **Changes are committed** and pushed back to your repository
8. **Your README is always 100% fresh** with the latest CV content

## 🎯 Benefits

- **Always Fresh**: README is completely regenerated every time
- **No Manual Updates**: Set it and forget it
- **Completely Clean**: Only shows CV pages, absolutely nothing else
- **100% Dynamic**: No static content ever preserved
- **Time Saving**: No need to manually update documentation
- **Error Prevention**: Automated process reduces human error

## 🚨 Troubleshooting

### GitHub Actions Not Running
- Check if Actions are enabled in your repository settings
- Verify the workflow file is in `.github/workflows/`
- Ensure you're pushing to the `master` branch

### README Not Updating
- Check GitHub Actions logs for errors
- Verify PNG files are in `attachments/output/` directory
- Ensure the script has write permissions

### Local Testing Issues
- Make sure you're running from the repository root
- Check Python version (3.7+ required)
- Verify all script files are present
