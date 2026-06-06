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

mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"

echo "Downloading Ollama..."

curl -L "https://ollama.com/download/ollama-linux-${ARCH}.tar.zst" -o /tmp/ollama.tar.zst

# Termux usually needs zstd
pkg install -y zstd tar

zstd -d $PREFIX/tmp/ollama.tar.zst | tar -xf - -C "$INSTALL_DIR"

echo "Linking binary..."
ln -sf "$INSTALL_DIR/ollama" "$BIN_DIR/ollama"

echo "Done."
echo "Run: ollama serve"
