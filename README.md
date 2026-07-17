# Chrome Auto Installer for Linux 🚀

Script tự động phát hiện bản phân phối Linux và cài đặt Google Chrome phù hợp.

## Hỗ trợ các bản Linux

- ✅ **Ubuntu** / **Debian** (APT)
- ✅ **Fedora** / **CentOS** / **RHEL** (RPM)
- ✅ **Arch Linux** / **Manjaro**/**CachyOS** (PACMAN)

## Yêu cầu

- Quyền root (sudo) Đối với cá hệ thuộc Debian(Ubuntu,Linux Mint,..) và Redhat(Fedora,RHEL,..)
- Kết nối internet
- `wget` hoặc `curl` (sẽ được cài đặt tự động nếu cần)

## Cách sử dụng

### 1. Clone repository
```bash
git clone https://github.com/kimngoctrungthuy4-rgb/chrome-auto-installer.git
cd chrome-auto-installer
```

### 2. Cấp quyền thực thi
```bash
chmod +x install-chrome.sh
```

### 3. Chạy script
Dối với hệ Debian
```bash
sudo ./install-chrome.sh
```
Dối với hệ Arch Linux(Cachy OS,Arch Linux,Artic,..)
```bash
./install-chrome.sh
```
##Script sẽ:
1. Phát hiện bản phân phối Linux của bạn
2. Cài đặt các gói phụ thuộc cần thiết
3. Thêm kho lưu trữ Google Chrome
4. Cài đặt Google Chrome phiên bản ổn định mới nhất

## Tính năng

- 🔍 **Tự động phát hiện distro** - Không cần cấu hình thủ công
- 🎯 **Hỗ trợ đa nền tảng** - Ubuntu, Fedora, Arch và các bản khác
- 🛡️ **An toàn** - Kiểm tra quyền root, xử lý lỗi
- 📝 **Output rõ ràng** - Hiển thị các bước cài đặt với màu sắc

## Lỗi thường gặp và cách khắc phục

### Ubuntu/Debian
Nếu gặp lỗi về GPG key:
```bash
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
```

### Fedora/CentOS/RHEL
Nếu gặp lỗi về repository:
```bash
sudo yum clean all
sudo yum update
```

### Arch Linux
Nếu không có `yay` hoặc `paru`, cài đặt yay:
```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## Kiểm tra cài đặt

Sau khi cài đặt, kiểm tra xem Google Chrome đã được cài đặt chưa:
```bash
google-chrome --version
```

Hoặc chạy Google Chrome:
```bash
google-chrome &
```

## Gỡ cài đặt Google Chrome

### Ubuntu/Debian
```bash
sudo apt-get remove -y google-chrome-stable
```

### Fedora/CentOS/RHEL
```bash
sudo yum remove -y google-chrome-stable
```

### Arch Linux
```bash
sudo pacman -R google-chrome
```

## Phát triển thêm

Để bổ sung hỗ trợ cho các bản phân phối khác, hãy:

1. Fork repository này
2. Thêm hàm cài đặt mới (ví dụ: `install_chrome_opensuse()`)
3. Cập nhật case statement trong hàm `main()`
4. Tạo Pull Request

## Thông tin liên hệ

- GitHub: [@kimngoctrungthuy4-rgb](https://github.com/kimngoctrungthuy4-rgb)
- Repository: [chrome-auto-installer](https://github.com/kimngoctrungthuy4-rgb/chrome-auto-installer)
- Gmail:kimngoctrungthuy4@gmail.com

## License

MIT License - Bạn tự do sử dụng, chỉnh sửa và phân phối script này.

## Lưu ý

- Script cần chạy với quyền root (`sudo`)
- Hãy kiểm tra script trước khi chạy trên hệ thống production
- Google Chrome sẽ được cài đặt từ các kho lưu trữ chính thức
- Bản cập nhật Chrome sẽ được tự động cài đặt thông qua package manager của distro

---

**Được tạo bởi**: kimngoctrungthuy4-rgb
**Cập nhật lần cuối**: 2026
