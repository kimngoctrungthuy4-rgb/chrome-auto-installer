#!/bin/bash

###############################################################################
# Chrome Auto Installer for Linux
# Automatically detects Linux distribution and installs Google Chrome
# Supports: Ubuntu/Debian (apt), Fedora/CentOS/RHEL (rpm), Arch/Manjaro/CachyOS (pacman)
###############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Check if running as root (for apt/yum operations)
check_root_for_pacman() {
    if [[ $EUID -eq 0 ]]; then
        print_warning "Script không nên chạy với sudo trên Arch-based distros (yay/paru sẽ tự hỏi password)"
        print_info "Vui lòng chạy lại KHÔNG có sudo: ./install-chrome.sh"
        exit 1
    fi
}

check_root_for_apt_rpm() {
    if [[ $EUID -ne 0 ]]; then
        print_error "Script này phải chạy với quyền root (sudo) cho apt/yum"
        exit 1
    fi
}

# Check if Chrome is already installed
check_chrome_installed() {
    if command -v google-chrome &> /dev/null; then
        CHROME_VERSION=$(google-chrome --version)
        print_success "Google Chrome đã cài sẵn!"
        print_info "$CHROME_VERSION"
        return 0
    fi
    return 1
}

# Prompt user for action
prompt_user() {
    local message=$1
    local response
    
    while true; do
        read -p "$(echo -e ${BLUE}$message${NC})" response
        case "$response" in
            [Yy])
                return 0
                ;;
            [Nn])
                return 1
                ;;
            *)
                print_warning "Vui lòng nhập Y hoặc N"
                ;;
        esac
    done
}

# Detect Linux distribution
detect_distro() {
    print_info "Đang phát hiện bản phân phối Linux..."
    
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        DISTRO_VERSION=$VERSION_ID
    elif [ -f /etc/redhat-release ]; then
        DISTRO="rhel"
    elif [ -f /etc/debian_version ]; then
        DISTRO="debian"
    else
        print_error "Không thể phát hiện bản phân phối Linux"
        exit 1
    fi
    
    print_success "Phát hiện: $DISTRO (Version: $DISTRO_VERSION)"
}

# Install Chrome on Ubuntu/Debian (APT)
install_chrome_apt() {
    check_root_for_apt_rpm
    
    print_info "Cài đặt Google Chrome trên Ubuntu/Debian..."
    
    # Update package list
    print_info "Cập nhật danh sách gói..."
    apt-get update
    
    # Install dependencies
    print_info "Cài đặt các gói phụ thuộc..."
    apt-get install -y wget gnupg
    
    # Add Google Chrome repository
    print_info "Thêm kho lưu trữ Google Chrome..."
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list
    
    # Update package list again
    print_info "Cập nhật danh sách gói..."
    apt-get update
    
    # Install Google Chrome
    print_info "Cài đặt Google Chrome..."
    apt-get install -y google-chrome-stable
    
    print_success "Google Chrome đã được cài đặt thành công!"
}

# Install Chrome on Fedora/CentOS/RHEL (RPM)
install_chrome_rpm() {
    check_root_for_apt_rpm
    
    print_info "Cài đặt Google Chrome trên Fedora/CentOS/RHEL..."
    
    # Install dependencies
    print_info "Cài đặt các gói phụ thuộc..."
    yum install -y wget
    
    # Add Google Chrome repository
    print_info "Thêm kho lưu trữ Google Chrome..."
    cat > /etc/yum.repos.d/google-chrome.repo << EOF
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF
    
    # Install Google Chrome
    print_info "Cài đặt Google Chrome..."
    yum install -y google-chrome-stable
    
    print_success "Google Chrome đã được cài đặt thành công!"
}

# Install Chrome on Arch Linux / Manjaro / CachyOS (PACMAN)
install_chrome_pacman() {
    check_root_for_pacman
    
    print_info "Cài đặt Google Chrome trên $DISTRO (Arch-based)..."
    
    # Update package database
    print_info "Cập nhật cơ sở dữ liệu gói..."
    sudo pacman -Sy
    
    # Install Google Chrome from AUR using yay or makepkg
    print_info "Kiểm tra xem yay có được cài đặt không..."
    
    if command -v yay &> /dev/null; then
        print_info "Sử dụng yay để cài đặt Google Chrome..."
        print_info "yay sẽ hỏi password nếu cần..."
        yay -S --noconfirm google-chrome
    elif command -v paru &> /dev/null; then
        print_info "Sử dụng paru để cài đặt Google Chrome..."
        print_info "paru sẽ hỏi password nếu cần..."
        paru -S --noconfirm google-chrome
    else
        print_warning "yay hoặc paru không được cài đặt"
        print_info "Bạn có thể cài đặt yay: https://github.com/Jguer/yay"
        print_info "Hoặc cài đặt từ kho chính thức: sudo pacman -S chromium"
        
        if prompt_user "Bạn muốn cài đặt Chromium thay thế không? (y/n): "; then
            sudo pacman -S --noconfirm chromium
            print_success "Chromium đã được cài đặt thành công!"
        else
            print_warning "Hủy cài đặt"
        fi
        exit 0
    fi
    
    print_success "Google Chrome đã được cài đặt thành công!"
}

# Remove Chrome
remove_chrome() {
    print_warning "Gỡ cài đặt Google Chrome..."
    
    case "$DISTRO" in
        ubuntu|debian)
            check_root_for_apt_rpm
            apt-get remove -y google-chrome-stable
            print_success "Google Chrome đã bị gỡ cài đặt!"
            ;;
        fedora|rhel|centos)
            check_root_for_apt_rpm
            yum remove -y google-chrome-stable
            print_success "Google Chrome đã bị gỡ cài đặt!"
            ;;
        arch|manjaro|cachyos)
            check_root_for_pacman
            sudo pacman -R --noconfirm google-chrome
            print_success "Google Chrome đã bị gỡ cài đặt!"
            ;;
    esac
}

# Main installation logic
main() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     Google Chrome Auto Installer for Linux               ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    detect_distro
    
    # Special handling for Arch-based distros
    if [[ "$DISTRO" == "arch" || "$DISTRO" == "manjaro" || "$DISTRO" == "cachyos" ]]; then
        check_root_for_pacman
    else
        check_root_for_apt_rpm
    fi
    
    # Check if Chrome is already installed
    if check_chrome_installed; then
        echo ""
        print_warning "Google Chrome đã cài sẵn trên hệ thống của bạn"
        echo ""
        
        echo -e "${BLUE}Bạn muốn làm gì?${NC}"
        echo "1) Cài đặt lại (Reinstall)"
        echo "2) Gỡ cài đặt (Remove)"
        echo "3) Thoát (Exit)"
        echo ""
        
        read -p "Chọn lựa chọn (1-3): " choice
        
        case $choice in
            1)
                print_info "Gỡ cài đặt Chrome cũ..."
                remove_chrome
                echo ""
                print_info "Cài đặt Chrome mới..."
                ;;
            2)
                if prompt_user "Bạn chắc chắn muốn gỡ cài đặt Chrome không? (y/n): "; then
                    remove_chrome
                    exit 0
                else
                    print_warning "Hủy gỡ cài đặt"
                    exit 0
                fi
                ;;
            3)
                print_info "Thoát"
                exit 0
                ;;
            *)
                print_error "Lựa chọn không hợp lệ"
                exit 1
                ;;
        esac
    fi
    
    # Install Chrome
    case "$DISTRO" in
        ubuntu|debian)
            install_chrome_apt
            ;;
        fedora|rhel|centos)
            install_chrome_rpm
            ;;
        arch|manjaro|cachyos)
            install_chrome_pacman
            ;;
        *)
            print_error "Bản phân phối '$DISTRO' không được hỗ trợ"
            print_info "Các bản được hỗ trợ: Ubuntu, Debian, Fedora, CentOS, RHEL, Arch Linux, Manjaro, CachyOS"
            exit 1
            ;;
    esac
    
    echo ""
    print_success "Cài đặt hoàn tất!"
    print_info "Bạn có thể chạy Google Chrome bằng lệnh: google-chrome"
}

# Run main function
main "$@"
