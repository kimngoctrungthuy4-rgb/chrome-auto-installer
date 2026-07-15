#!/bin/bash

# Google Chrome Installation Script for Arch Linux/Manjaro
# This script handles Chrome installation on Arch-based systems using PACMAN

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}[Arch Linux - PACMAN]${NC} Bắt đầu cài đặt Google Chrome..."

# Update package database
echo -e "${BLUE}[*]${NC} Cập nhật cơ sở dữ liệu gói..."
sudo pacman -Sy

# Check for AUR helpers
echo -e "${BLUE}[*]${NC} Kiểm tra AUR helpers..."

if command -v yay &> /dev/null; then
    echo -e "${GREEN}[✓]${NC} Đã tìm thấy yay"
    echo -e "${BLUE}[*]${NC} Cài đặt Google Chrome từ AUR..."
    yay -S --noconfirm google-chrome
    echo -e "${GREEN}[✓]${NC} Cài đặt hoàn tất! Bạn có thể chạy: google-chrome"
    
elif command -v paru &> /dev/null; then
    echo -e "${GREEN}[✓]${NC} Đã tìm thấy paru"
    echo -e "${BLUE}[*]${NC} Cài đặt Google Chrome từ AUR..."
    paru -S --noconfirm google-chrome
    echo -e "${GREEN}[✓]${NC} Cài đặt hoàn tất! Bạn có thể chạy: google-chrome"
    
else
    echo -e "${YELLOW}[!]${NC} Không tìm thấy yay hoặc paru"
    echo -e "${YELLOW}[!]${NC} Để cài đặt Google Chrome, bạn cần một AUR helper"
    echo ""
    echo "Cách cài đặt yay:"
    echo "  git clone https://aur.archlinux.org/yay.git"
    echo "  cd yay"
    echo "  makepkg -si"
    echo ""
    echo "Hoặc cài đặt Chromium từ kho chính thức:"
    echo "  sudo pacman -S chromium"
    exit 1
fi
