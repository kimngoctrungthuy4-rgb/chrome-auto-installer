#!/bin/bash

# Google Chrome Installation Script for Ubuntu/Debian
# This script handles Chrome installation on Debian-based systems using APT

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}[Ubuntu/Debian - APT]${NC} Bắt đầu cài đặt Google Chrome..."

# Update package list
echo -e "${BLUE}[*]${NC} Cập nhật danh sách gói..."
sudo apt-get update

# Install dependencies
echo -e "${BLUE}[*]${NC} Cài đặt các gói phụ thuộc..."
sudo apt-get install -y wget gnupg ca-certificates

# Create keyring directory if it doesn't exist
sudo mkdir -p /usr/share/keyrings

# Add Google's GPG key using modern and secure method (No apt-key)
echo -e "${BLUE}[*]${NC} Thêm GPG key bảo mật của Google..."
wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor | sudo tee /usr/share/keyrings/google-chrome.gpg > /dev/null

# Add Google Chrome repository with signed-by protection
echo -e "${BLUE}[*]${NC} Thêm kho lưu trữ Google Chrome (signed-by)..."
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null

# Update package list again
echo -e "${BLUE}[*]${NC} Cập nhật danh sách gói mới..."
sudo apt-get update

# Install Google Chrome
echo -e "${BLUE}[*]${NC} Cài đặt Google Chrome..."
sudo apt-get install -y google-chrome-stable

echo -e "${GREEN}[✓]${NC} Cài đặt hoàn tất! Bạn có thể chạy: google-chrome"

