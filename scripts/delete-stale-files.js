#!/usr/bin/env node

/**
 * Cross-platform script to delete stale files listed in .stale_files
 * Works on Windows, macOS, and Linux
 * 
 * This script is designed to run during npm preinstall lifecycle
 * to clean up obsolete files before dependencies are installed.
 */

const fs = require('fs');
const path = require('path');

// Configuration
const STALE_FILES_NAME = 'stale_files';

// Determine the root directory (project root)
const rootDir = path.resolve(__dirname, '..');
const staleFilesPath = path.join(rootDir, STALE_FILES_NAME);

/**
 * Validates if a path is within the project root directory
 * @param {string} targetPath - Absolute path to validate
 * @param {string} rootPath - Root directory path
 * @returns {boolean} - True if path is within root, false otherwise
 */
function isPathWithinRoot(targetPath, rootPath) {
  const relative = path.relative(rootPath, targetPath);
  return !relative.startsWith('..') && !path.isAbsolute(relative);
}

/**
 * Safely delete a file or directory
 * @param {string} filePath - Absolute path to the file/directory
 * @param {string} rootPath - Root directory path for validation
 * @returns {boolean} - True if deleted successfully, false otherwise
 */
function deleteFileOrDirectory(filePath, rootPath) {
  try {
    // Validate path is within project root (security check)
    if (!isPathWithinRoot(filePath, rootPath)) {
      console.log(`⊘ Skipped (outside project): ${filePath}`);
      return false;
    }

    // Check if file/directory exists
    if (!fs.existsSync(filePath)) {
      console.log(`⊘ Not found (skipped): ${filePath}`);
      return false;
    }

    const stats = fs.statSync(filePath);
    
    if (stats.isDirectory()) {
      // Remove directory recursively
      fs.rmSync(filePath, { recursive: true, force: true });
      console.log(`✓ Deleted directory: ${filePath}`);
    } else {
      // Remove file
      fs.unlinkSync(filePath);
      console.log(`✓ Deleted file: ${filePath}`);
    }
    return true;
  } catch (error) {
    // Catch any errors but continue without throwing
    console.log(`⊘ Could not delete (skipped): ${filePath} - ${error.message}`);
    return false;
  }
}

/**
 * Parse and validate file paths from .stale_files content
 * @param {string} content - Raw content from .stale_files
 * @returns {string[]} - Array of valid file paths
 */
function parseStaleFiles(content) {
  return content
    .split(/\r?\n/) // Handle both Unix and Windows line endings
    .map(line => line.trim())
    .filter(line => line.length > 0); // Filter out empty lines
}

/**
 * Main function to process and delete stale files
 * @returns {void}
 */
function deleteStaleFiles() {
  console.log('🧹 Starting stale files cleanup...\n');

  // Verify we're running in a valid project root
  if (!fs.existsSync(rootDir)) {
    console.warn(`⚠ Warning: Project root directory not found: ${rootDir}`);
    console.log('Skipping stale files cleanup.\n');
    return;
  }

  // Check if .stale_files exists
  if (!fs.existsSync(staleFilesPath)) {
    console.log(`⚠ No ${STALE_FILES_NAME} found. Nothing to clean up.`);
    return;
  }

  let content;
  try {
    // Read the .stale_files content
    content = fs.readFileSync(staleFilesPath, 'utf8');
  } catch (error) {
    console.warn(`⚠ Warning: Could not read ${STALE_FILES_NAME}:`, error.message);
    console.log('Skipping stale files cleanup.\n');
    return;
  }

  const files = parseStaleFiles(content);

  if (files.length === 0) {
    console.log(`⚠ No files listed in ${STALE_FILES_NAME}. Nothing to clean up.`);
    return;
  }

  console.log(`Found ${files.length} file(s)/directory(ies) to process:\n`);

  let deletedCount = 0;
  let skippedCount = 0;

  // Process each file
  files.forEach(file => {
    const absolutePath = path.join(rootDir, file);
    const deleted = deleteFileOrDirectory(absolutePath, rootDir);
    
    if (deleted) {
      deletedCount++;
    } else {
      skippedCount++;
    }
  });

  // Summary
  console.log('\n==================================================');
  console.log('📊 Cleanup Summary:');
  console.log(`   ✓ Deleted: ${deletedCount}`);
  console.log(`   ⊘ Skipped: ${skippedCount}`);
  console.log('==================================================\n');
}

// Main execution
if (require.main === module) {
  deleteStaleFiles();
}
