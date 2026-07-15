#!/bin/bash

# Google Chrome Installation Script for Fedora/CentOS/RHEL
# This script handles Chrome installation on Red Hat-based systems using YUM/DNF

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}[Fedora/CentOS/RHEL - RPM]${NC} Bắt đầu cài đặt Google Chrome..."

# Install dependencies
echo -e "${BLUE}[*]${NC} Cài đặt các gói phụ thuộc..."
sudo yum install -y wget

# Add Google Chrome repository
echo -e "${BLUE}[*]${NC} Thêm kho lưu trữ Google Chrome..."
sudo tee /etc/yum.repos.d/google-chrome.repo > /dev/null << EOF
[google-chrome]
name=google-chrome - \$basearch
baseurl=http://dl.google.com/linux/chrome/rpm/stable/\$basearch
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF

# Install Google Chrome
echo -e "${BLUE}[*]${NC} Cài đặt Google Chrome..."
if command -v dnf &> /dev/null; then
    sudo dnf install -y google-chrome-stable
else
    sudo yum install -y google-chrome-stable
fi

echo -e "${GREEN}[✓]${NC} Cài đặt hoàn tất! Bạn có thể chạy: google-chrome"
