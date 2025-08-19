#!/bin/bash

# CV Compilation Pipeline Script
# This script compiles the LaTeX CV, converts to PNG images, and generates README

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if directory exists
directory_exists() {
    [ -d "$1" ]
}

# Function to create directory if it doesn't exist
create_directory() {
    if [ ! -d "$1" ]; then
        print_status "Creating directory: $1"
        mkdir -p "$1"
    fi
}

# Function to check dependencies
check_dependencies() {
    print_status "Checking dependencies..."
    
    # Check for LaTeX
    if ! command_exists pdflatex; then
        print_error "pdflatex not found. Please install a LaTeX distribution."
        print_status "For Ubuntu/Debian: sudo apt-get install texlive-full"
        print_status "For macOS: brew install --cask mactex"
        print_status "For Windows: Install MiKTeX or TeX Live"
        exit 1
    fi
    
    # Check for ImageMagick
    if ! command_exists convert; then
        print_error "ImageMagick not found. Please install ImageMagick."
        print_status "For Ubuntu/Debian: sudo apt-get install imagemagick"
        print_status "For macOS: brew install imagemagick"
        print_status "For Windows: Download from https://imagemagick.org/"
        exit 1
    fi
    
    # Check for Python
    if ! command_exists python3; then
        print_error "Python 3 not found. Please install Python 3.7+."
        print_status "For Ubuntu/Debian: sudo apt-get install python3"
        print_status "For macOS: brew install python3"
        print_status "For Windows: Download from https://python.org/"
        exit 1
    fi
    
    print_success "All dependencies are available"
}

# Function to compile LaTeX
compile_latex() {
    print_status "Compiling LaTeX CV..."
    
    cd template_2
    
    # Clean previous build artifacts
    print_status "Cleaning previous build artifacts..."
    rm -f *.aux *.fdb_latexmk *.fls *.log *.out *.synctex.gz *.xdv
    
    # Compile with XeLaTeX
    print_status "Running XeLaTeX compilation..."
    if xelatex -interaction=nonstopmode main.tex; then
        print_success "LaTeX compilation completed successfully"
    else
        print_error "LaTeX compilation failed"
        exit 1
    fi
    
    # Check if PDF was created
    if [ ! -f "main.pdf" ]; then
        print_error "PDF file was not created"
        exit 1
    fi
    
    print_success "PDF generated: main.pdf"
    cd ..
}

# Function to convert PDF to PNG images
convert_to_png() {
    print_status "Converting PDF to PNG images..."
    
    # Create output directory if it doesn't exist
    create_directory "attachments/output"
    
    # Check if PDF exists
    if [ ! -f "template_2/main.pdf" ]; then
        print_error "PDF file not found. Please compile LaTeX first."
        exit 1
    fi
    
    # Convert each page to PNG
    print_status "Converting PDF pages to PNG..."
    if convert template_2/main.pdf -background white -alpha remove -alpha off -quality 90 -density 300 attachments/output/output-page-%d.png; then
        print_success "PDF to PNG conversion completed"
    else
        print_error "PDF to PNG conversion failed"
        exit 1
    fi
    
    # Create combined version
    print_status "Creating combined PNG image..."
    if convert template_2/main.pdf -background white -alpha remove -alpha off -quality 90 -density 300 -append attachments/output/output-combined.png; then
        print_success "Combined PNG created"
    else
        print_error "Combined PNG creation failed"
        exit 1
    fi
    
    # Count generated PNG files
    png_count=$(ls -1 attachments/output/output-page-*.png 2>/dev/null | wc -l)
    print_success "Generated $png_count PNG page files"
}

# Function to generate README
generate_readme() {
    print_status "Generating README.md..."
    
    # Remove existing README to ensure complete regeneration
    if [ -f "README.md" ]; then
        print_status "Removing existing README.md for complete regeneration"
        rm -f README.md
    fi
    
    if python3 scripts/generate_readme.py; then
        print_success "README.md generated successfully"
    else
        print_error "README generation failed"
        exit 1
    fi
}

# Function to show summary
show_summary() {
    print_status "Compilation Summary:"
    echo "----------------------------------------"
    
    # Check PDF
    if [ -f "template_2/main.pdf" ]; then
        pdf_size=$(du -h template_2/main.pdf | cut -f1)
        print_success "PDF: template_2/main.pdf ($pdf_size)"
    else
        print_error "PDF: Not found"
    fi
    
    # Check PNG files
    if directory_exists "attachments/output"; then
        png_files=$(ls -1 attachments/output/output-page-*.png 2>/dev/null | wc -l)
        if [ "$png_files" -gt 0 ]; then
            print_success "PNG files: $png_files pages in attachments/output/"
        else
            print_warning "PNG files: None found"
        fi
    else
        print_warning "PNG files: Directory not found"
    fi
    
    # Check README
    if [ -f "README.md" ]; then
        readme_size=$(du -h README.md | cut -f1)
        print_success "README: README.md ($readme_size)"
    else
        print_error "README: Not found"
    fi
    
    echo "----------------------------------------"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -c, --clean    Clean build artifacts before compilation"
    echo "  -p, --pdf-only Compile only LaTeX (skip PNG conversion and README generation)"
    echo "  -r, --readme   Generate only README (skip LaTeX compilation and PNG conversion)"
    echo ""
    echo "Examples:"
    echo "  $0              # Full pipeline: LaTeX → PNG → README"
    echo "  $0 --pdf-only   # Only compile LaTeX"
    echo "  $0 --readme     # Only generate README"
    echo "  $0 --clean      # Clean and run full pipeline"
}

# Function to clean build artifacts
clean_build() {
    print_status "Cleaning build artifacts..."
    
    # Clean LaTeX artifacts
    if directory_exists "template_2"; then
        cd template_2
        rm -f *.aux *.fdb_latexmk *.fls *.log *.out *.synctex.gz *.xdv
        cd ..
        print_success "LaTeX artifacts cleaned"
    fi
    
    # Clean PNG files
    if directory_exists "attachments/output"; then
        rm -f attachments/output/output-page-*.png attachments/output/output-combined.png
        print_success "PNG files cleaned"
    fi
    
    # Clean README
    if [ -f "README.md" ]; then
        rm -f README.md
        print_success "README.md cleaned"
    fi
}

# Main execution
main() {
    local pdf_only=false
    local readme_only=false
    local clean_build=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -c|--clean)
                clean_build=true
                shift
                ;;
            -p|--pdf-only)
                pdf_only=true
                shift
                ;;
            -r|--readme)
                readme_only=true
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Check for conflicting options
    if [ "$pdf_only" = true ] && [ "$readme_only" = true ]; then
        print_error "Cannot use --pdf-only and --readme together"
        exit 1
    fi
    
    echo "🚀 CV Compilation Pipeline"
    echo "=========================="
    echo ""
    
    # Check dependencies
    check_dependencies
    
    # Clean if requested
    if [ "$clean_build" = true ]; then
        clean_build
        echo ""
    fi
    
    # Execute pipeline based on options
    if [ "$readme_only" = true ]; then
        print_status "README-only mode: Skipping LaTeX compilation and PNG conversion"
        generate_readme
    elif [ "$pdf_only" = true ]; then
        print_status "PDF-only mode: Skipping PNG conversion and README generation"
        compile_latex
    else
        print_status "Full pipeline mode: LaTeX → PNG → README"
        compile_latex
        convert_to_png
        generate_readme
    fi
    
    echo ""
    show_summary
    echo ""
    print_success "Pipeline completed successfully! 🎉"
}

# Run main function with all arguments
main "$@"
