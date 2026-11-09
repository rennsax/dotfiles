set -euo pipefail
umask 037
DB_PATH="/home/rbj/qqbot/data/hs_deck_bot_db.sqlite3"
BACKUP_DIR="/var/backups/hs_deck_bot_db"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="$BACKUP_DIR/db-$TIMESTAMP.sqlite.gz"
TMP_FILE=$(mktemp "$BACKUP_DIR/.backup.XXXXXX")
trap 'rm -f "$TMP_FILE" "$BACKUP_FILE.tmp"' EXIT

sqlite3 "$DB_PATH" ".backup '$TMP_FILE'"
gzip -c "$TMP_FILE" > "$BACKUP_FILE.tmp"

mv "$BACKUP_FILE.tmp" "$BACKUP_FILE"
# 删除 7 天前的备份
find "$BACKUP_DIR" -type f -name 'db-*.sqlite.gz' -mtime +7 -delete
