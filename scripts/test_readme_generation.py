#!/usr/bin/env python3
"""
Test script for README generation.
Run this to test the README generation locally before pushing.
"""

import sys
import os
from pathlib import Path

# Add the scripts directory to the path
sys.path.insert(0, str(Path(__file__).parent))

try:
    from generate_readme import main, generate_readme_content
    
    print("🧪 Testing README generation...")
    
    # Test content generation
    content = generate_readme_content()
    print(f"📝 Generated content length: {len(content)} characters")
    
    # Test if content contains expected sections
    expected_sections = [
        "## 📄 CV Pages",
        "## 📁 Repository Structure", 
        "## 🔄 Auto-Update"
    ]
    
    for section in expected_sections:
        if section in content:
            print(f"✅ Found section: {section}")
        else:
            print(f"❌ Missing section: {section}")
    
    # Test main function
    print("\n🔄 Testing main function...")
    main()
    
    # Check if README.md was created
    if Path("README.md").exists():
        print("✅ README.md created successfully!")
        
        # Read and show first few lines
        with open("README.md", "r", encoding="utf-8") as f:
            first_lines = f.readlines()[:10]
            print("\n📖 First 10 lines of generated README:")
            for i, line in enumerate(first_lines, 1):
                print(f"{i:2d}: {line.rstrip()}")
    else:
        print("❌ README.md was not created!")
        
except ImportError as e:
    print(f"❌ Import error: {e}")
    print("Make sure you're running this from the repository root directory")
except Exception as e:
    print(f"❌ Error during testing: {e}")
    import traceback
    traceback.print_exc()
