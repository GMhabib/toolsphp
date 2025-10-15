#!/bin/bash
# Skrip untuk menginstal menu_website.py agar berjalan otomatis di Termux.

# --- PATH PENTING ---
PYTHON_FILE="menu_website.py"
BASHRC_FILE="$PREFIX/etc/bash.bashrc"
SCRIPT_PATH="$HOME/$PYTHON_FILE"
START_COMMAND="python $SCRIPT_PATH"
# --------------------

echo "========================================"
echo "--- Mempersiapkan Instalasi Menu habib ---"
echo "========================================"

# 1. Cek keberadaan file Python di lokasi saat ini
if [ ! -f "$PYTHON_FILE" ]; then
    echo "[ERROR] File Python '$PYTHON_FILE' tidak ditemukan di direktori ini."
    echo "Pastikan Anda menjalankan skrip setup_termux.sh di direktori yang sama dengan $PYTHON_FILE."
    exit 1
fi

# 2. Menyalin/Memastikan file berada di $HOME
echo "[INFO] Memastikan $PYTHON_FILE berada di $HOME/..."

# Coba salin. Kesalahan seperti 'are the same file' akan dialihkan ke /dev/null
# agar konsol tetap bersih, dan kami akan memeriksa keberadaan file setelahnya.
cp "$PYTHON_FILE" "$HOME/" 2>/dev/null 

# Cek secara definitif apakah file berada di lokasi akhir yang diharapkan ($HOME)
if [ -f "$SCRIPT_PATH" ]; then
    echo "[SUKSES] File $PYTHON_FILE dipastikan ada di $HOME/."
else
    # Ini akan menangkap kegagalan yang sebenarnya (misalnya, izin akses yang salah)
    echo "[ERROR] Gagal menyalin file ke $HOME/. Cek izin akses atau ruang penyimpanan."
    exit 1
fi

# 3. Cek apakah perintah sudah ada di bash.bashrc
echo "[INFO] Memeriksa $BASHRC_FILE untuk perintah eksekusi..."
if grep -qF "$START_COMMAND" "$BASHRC_FILE"; then
    echo "[INFO] Perintah otomatis sudah ada. Tidak ada perubahan pada $BASHRC_FILE."
else
    # 4. Tambahkan perintah ke bash.bashrc
    echo "[INFO] Menambahkan perintah eksekusi ke $BASHRC_FILE..."
    
    # Tambahkan baris baru dan komentar di bash.bashrc
    echo "" >> "$BASHRC_FILE"
    echo "# --- Otomatis menjalankan menu habib (Diinstal oleh setup_termux.sh) ---" >> "$BASHRC_FILE"
    # Tambahkan perintah eksekusi dengan pengecekan file
    echo "if [ -f \"$SCRIPT_PATH\" ]; then" >> "$BASHRC_FILE"
    echo "  $START_COMMAND" >> "$BASHRC_FILE"
    echo "fi" >> "$BASHRC_FILE"
    echo "# ----------------------------------------------------------------------" >> "$BASHRC_FILE"
    
    echo "[SUKSES] Perintah berhasil ditambahkan!"
fi

echo "========================================"
echo "Instalasi Selesai! Menu akan muncul saat sesi Termux baru dimulai."
echo "Untuk menguji: Ketik 'bash' atau buka Termux di jendela baru."
echo "========================================"
