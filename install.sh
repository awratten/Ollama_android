#!/data/data/com.termux/files/usr/bin/sh
set -e

ARCH=$(uname -m)
case "$ARCH" in
  aarch64|arm64) ARCH="arm64" ;;
  x86_64) ARCH="amd64" ;;
  *) echo "Unsupported arch: $ARCH"; exit 1 ;;
esac

PREFIX=${PREFIX:-/data/data/com.termux/files/usr}
INSTALL_DIR="$PREFIX/opt/ollama"
BIN_DIR="$PREFIX/bin"

# Safe temp directory for Android/Termux
TMP_DIR="$PREFIX/tmp"
mkdir -p "$TMP_DIR"
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"

echo "Downloading Ollama..."

# Ensure downloader uses writable path (NOT /tmp)
DOWNLOAD_FILE="$TMP_DIR/ollama.tar.zst"

curl -L "https://ollama.com/download/ollama-linux-${ARCH}.tar.zst" -o "$DOWNLOAD_FILE"

echo "Installing dependencies (zstd, tar)..."
pkg install -y zstd tar >/dev/null 2>&1

echo "Extracting..."

zstd -d "$DOWNLOAD_FILE" | tar -xf - -C "$INSTALL_DIR"

echo "Linking binary..."
ln -sf "$INSTALL_DIR/ollama" "$BIN_DIR/ollama"

echo "Cleaning up..."
rm -f "$DOWNLOAD_FILE"

echo "Done."
echo "Run: ollama serve"
