#!/bin/bash

# Konfigurasi
BACKUP_DIR="./git_backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
PROJECT_NAME=$(basename $(git rev-parse --show-toplevel))
BACKUP_FILE="${BACKUP_DIR}/${PROJECT_NAME}_full_backup_${TIMESTAMP}.bundle"
LOG_FILE="${BACKUP_DIR}/backup_log.txt"

# Buat folder backup jika belum ada
mkdir -p "$BACKUP_DIR"

echo "[$(date)] Memulai backup untuk $PROJECT_NAME..." | tee -a "$LOG_FILE"

# Pastikan semua ref lokal terupdate
git fetch --all

# Buat bundle dari semua branch dan tag
# --all menyertakan semua refs
if git bundle create "$BACKUP_FILE" --all; then
    echo "[$(date)] SUKSES: Backup tersimpan di $BACKUP_FILE" | tee -a "$LOG_FILE"
else
    echo "[$(date)] GAGAL: Terjadi kesalahan saat membuat bundle." | tee -a "$LOG_FILE"
    exit 1
fi

# Verifikasi file bundle
if git bundle verify "$BACKUP_FILE"; then
    echo "[$(date)] VERIFIKASI: File bundle valid." | tee -a "$LOG_FILE"
else
    echo "[$(date)] VERIFIKASI: File bundle rusal/invalid." | tee -a "$LOG_FILE"
fi

echo "----------------------------------------" | tee -a "$LOG_FILE"
