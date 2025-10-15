#!/bin/bash
# Skrip untuk menginstal menu_website.py agar berjalan otomatis di Termux.

# --- PATH PENTING ---
PYTHON_FILE="menu.py"
TARGET_DIR="$PREFIX/etc"
BASHRC_FILE="$TARGET_DIR/bash.bashrc"
SCRIPT_PATH="$TARGET_DIR/$PYTHON_FILE"
START_COMMAND="python $SCRIPT_PATH"
SETUP_FILE="setup.sh" # Nama file ini jika dijalankan sebagai ./setup.sh
# --------------------

echo "========================================"
echo "--- Mempersiapkan Instalasi Menu habib ---"
echo "========================================"

# 1. Cek keberadaan file Python di lokasi saat ini
if [ ! -f "$PYTHON_FILE" ]; then
    echo "[ERROR] File Python '$PYTHON_FILE' tidak ditemukan di direktori ini."
    echo "Pastikan Anda menjalankan skrip setup.sh di direktori yang sama dengan $PYTHON_FILE."
    exit 1
fi

# 2. Menyalin file ke $PREFIX/etc/
echo "[INFO] Menyalin $PYTHON_FILE ke $TARGET_DIR/..."
# Gunakan cp -f untuk memaksa timpa file yang sudah ada
cp -f "$PYTHON_FILE" "$SCRIPT_PATH"

if [ -f "$SCRIPT_PATH" ]; then
    echo "[SUKSES] File $PYTHON_FILE berhasil diinstal di $TARGET_DIR/."
else
    echo "[ERROR] Gagal menyalin file ke $TARGET_DIR/. Cek izin akses."
    exit 1
fi

# 3. Cek apakah perintah sudah ada di bash.bashrc
echo "[INFO] Memeriksa $BASHRC_FILE untuk perintah eksekusi..."
if grep -qF "$START_COMMAND" "$BASHRC_FILE"; then
    echo "[INFO] Perintah otomatis sudah ada. Hanya update path file."
else
    # 4. Tambahkan perintah ke bash.bashrc
    echo "[INFO] Menambahkan perintah eksekusi ke $BASHRC_FILE..."
    
    # Tambahkan baris baru dan komentar di bash.bashrc
    echo "" >> "$BASHRC_FILE"
    echo "# --- Otomatis menjalankan menu habib (Diinstal oleh setup.sh) ---" >> "$BASHRC_FILE"
    # Tambahkan perintah eksekusi dengan pengecekan file
    echo "if [ -f \"$SCRIPT_PATH\" ]; then" >> "$BASHRC_FILE"
    echo "  $START_COMMAND" >> "$BASHRC_FILE"
    echo "fi" >> "$BASHRC_FILE"
    echo "# ----------------------------------------------------------------------" >> "$BASHRC_FILE"
    
    echo "[SUKSES] Perintah berhasil ditambahkan!"
fi

# 5. Membersihkan file sumber dari direktori saat ini
echo "[INFO] Membersihkan file sumber: $PYTHON_FILE dan $SETUP_FILE..."
rm -f "$PYTHON_FILE" "$SETUP_FILE"

# 6. Mengakhiri sesi Termux untuk memuat bash.bashrc yang baru
echo "[INFO] Mengakhiri sesi Termux (pkill com.termux) untuk memuat ulang konfigurasi."
echo "Termux akan menutup secara paksa dan Anda harus membukanya lagi untuk melihat menu."
pkill com.termux

echo "========================================"
echo "Instalasi Selesai."
echo "========================================"
