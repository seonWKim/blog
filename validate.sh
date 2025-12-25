#!/bin/bash

# Blog Build Validation Script
# This script validates that your Jekyll blog compiles without errors

set -e  # Exit on any error

echo "🔍 Validating blog build..."
echo ""

# Check if bundle is installed
if ! command -v bundle &> /dev/null; then
    echo "❌ Error: bundler is not installed"
    echo "Please follow SETUP.md to install Ruby and Bundler"
    exit 1
fi

# Check if dependencies are installed
if [ ! -d "vendor/bundle" ] && [ ! -d ".bundle" ]; then
    echo "📦 Installing dependencies..."
    bundle install
    echo ""
fi

# Run Jekyll build with strict mode
echo "🏗️  Building site..."
JEKYLL_ENV=production bundle exec jekyll build --strict_front_matter

# Check if build was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful! Your blog is ready to deploy."
    echo ""
    echo "📊 Build stats:"
    echo "   - Output directory: _site/"
    if [ -d "_site" ]; then
        file_count=$(find _site -type f | wc -l | tr -d ' ')
        size=$(du -sh _site | cut -f1)
        echo "   - Files generated: $file_count"
        echo "   - Total size: $size"
    fi
    exit 0
else
    echo ""
    echo "❌ Build failed! Please fix the errors above before pushing."
    exit 1
fi
