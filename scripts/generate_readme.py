#!/usr/bin/env python3
"""
Dynamic README generator for CV repository.
Generates a completely clean README with only CV pages.
"""

import os
import glob
import re
from pathlib import Path

def get_output_png_files():
    """Get all PNG files from the attachments/output directory."""
    output_dir = Path("attachments/output")
    if not output_dir.exists():
        return []
    
    png_files = list(output_dir.glob("*.png"))
    # Sort by name to ensure consistent order
    png_files.sort()
    return png_files

def generate_page_description(filename):
    """Generate a description for each CV page based on filename."""
    base_name = filename.stem
    
    # Map filenames to descriptions
    descriptions = {
        "output-page-0": "Personal Information & Summary",
        "output-page-1": "Skills & Work Experience", 
        "output-page-2": "Languages, Education & Interests",
        "output-page-3": "Publications & Personal Projects",
        "output-page-4": "Additional Information",
        "output-page-5": "Extended Details"
    }
    
    # Try to match with known patterns
    for pattern, desc in descriptions.items():
        if base_name.startswith(pattern):
            return desc
    
    # For other files, generate a generic description
    if "page" in base_name:
        page_num = re.search(r'page-(\d+)', base_name)
        if page_num:
            return f"CV Page {int(page_num.group(1)) + 1}"
    
    return "CV Content"

def generate_readme_content():
    """Generate the completely minimal README content."""
    
    # Start with completely clean content
    content = """# Antoni Dudij - CV/Resume

<div align="center">

## 📄 CV Pages

"""
    
    # Add PNG images from output directory
    png_files = get_output_png_files()
    
    # Filter for output-page files and sort them
    page_files = [f for f in png_files if "output-page" in f.name]
    page_files.sort(key=lambda x: int(re.search(r'page-(\d+)', x.name).group(1)) if re.search(r'page-(\d+)', x.name) else 0)
    
    for png_file in page_files:
        relative_path = png_file.relative_to(Path("."))
        description = generate_page_description(png_file)
        content += f"![{description}]({relative_path})\n"
        content += f"*{description}*\n\n"
    
    # Close the div
    content += """</div>
"""
    
    return content

def main():
    """Main function to generate and write README."""
    print("🔄 Generating clean README.md...")
    
    # Generate content
    content = generate_readme_content()
    
    # Write to README.md (this completely overwrites any existing content)
    with open("README.md", "w", encoding="utf-8") as f:
        f.write(content)
    
    print("✅ README.md generated successfully!")
    print(f"📊 Found {len(get_output_png_files())} PNG files in attachments/output/")

if __name__ == "__main__":
    main()
