#!/bin/bash

# CV Compilation Script
# This script compiles the LaTeX CV and converts it to PNG

echo "🚀 Starting CV compilation..."

# Change to template_2 directory
cd template_2

# Compile LaTeX with XeLaTeX
echo "📝 Compiling LaTeX with XeLaTeX..."
xelatex main.tex

# Check if compilation was successful
if [ $? -eq 0 ]; then
    echo "✅ LaTeX compilation successful!"
    
    # Check if main.pdf was created
    if [ -f "main.pdf" ]; then
        echo "📄 PDF generated successfully!"
        
        # Convert PDF to PNG with all pages combined
        echo "🖼️ Converting PDF to PNG..."
        convert main.pdf -quality 90 -density 300 -append ../attachments/png/output.png
        
        if [ $? -eq 0 ]; then
            echo "✅ PNG conversion successful!"
            echo "📁 Output saved to: ../attachments/png/output.png"
            
            # Show file sizes
            echo "📊 File sizes:"
            ls -lh main.pdf
            ls -lh ../attachments/png/output.png
        else
            echo "❌ PNG conversion failed!"
            exit 1
        fi
    else
        echo "❌ PDF file not found after compilation!"
        exit 1
    fi
else
    echo "❌ LaTeX compilation failed!"
    exit 1
fi

echo "🎉 CV compilation and conversion complete!"
echo "💡 You can now view the PNG in: attachments/png/output.png"
