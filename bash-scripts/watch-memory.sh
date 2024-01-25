#!/bin/bash

# 再起動が必要と判断するしきい値（パーセントで指定）
THRESHOLD=80

# DISCORDのWebhookのURL 適時変更
WEBHOOK_URL="https://discord.com/api/webhooks/xxxxxxx"

# RCONのIPアドレス
RCON_IP="127.0.0.1"

# RCONのポート番号 適時変更
RCON_PORT="25575"

# RCONの管理者用パスワード 適時変更
RCON_PASSWORD="password"

# セーブデータのパス 適時変更
WORLD_SAVE_PATH="/home/ubuntu/Steam/steamapps/common/PalServer/Pal/Saved/SaveGames"

# セーブデータのバックアップ保存先のパス 適時変更
WORLD_BACKUP_PATH="/home/ubuntu/PalSeverBackup"

# 作成するバックアップの最大数
MAX_BACKUP_COUNT=5

# Discordにメッセージを送信する関数
# curlコマンドを使用しているため、curlコマンドが使用可能である必要がある
send_discord_message() {
    local message=$1
    curl -X POST -H "Content-Type: application/json" -d "{\"content\": \"$message\"}" $WEBHOOK_URL
    echo "Message sent to Discord: $message"
}

# ワールド内にメッセージを送信する関数
# mcronコマンドを使用しているため、RCONが有効で、mcrconコマンドが使用可能である必要がある
# 他のRCONクライアントを使用する場合は、この関数を書き換える必要がある
send_world_message() {
    local message=$1
    CURRENT_TIME=$(TZ=Asia/Tokyo date '+%H:%M')
    mcrcon -H $RCON_IP -P $RCON_PORT -p $RCON_PASSWORD "Broadcast [$CURRENT_TIME]:$message"
    echo "Message sent to world: [$CURRENT_TIME]:$message"
}

# ワールドデータをセーブする関数
# mcronコマンドを使用しているため、RCONが有効で、mcrconコマンドが使用可能である必要がある
# 他のRCONクライアントを使用する場合は、この関数を書き換える必要がある
save_world_data() {
    mcrcon -H $RCON_IP -P $RCON_PORT -p $RCON_PASSWORD "Save"
    echo "Save command sent to world."
}

# ワールドデータをバックアップする関数
# zipコマンドを使用しているため、zipコマンドが使用可能である必要がある
backup_world_data() {
    # バックアップ保存先のディレクトリが存在しない場合は作成
    if [ ! -d $WORLD_BACKUP_PATH ]; then
        mkdir -p $WORLD_BACKUP_PATH
    fi

    # バックアップ保存先のディレクトリにzip形式でバックアップを作成
    # ファイル名形式は PalWorldSave_YYYYMMDD-HHMM-S.zip
    zip -r $WORLD_BACKUP_PATH/PalWorldSave_$(TZ=Asia/Tokyo date '+%Y%m%d-%H%M-%S').zip $WORLD_SAVE_PATH
    echo "World data backup created: $WORLD_BACKUP_PATH/PalWorldSave_$(TZ=Asia/Tokyo date '+%Y%m%d-%H%M-%S').zip"

    # バックアップがMAX_BACKUP_COUNT以上存在する場合は古いものから削除
    BACKUP_COUNT=$(ls $WORLD_BACKUP_PATH | wc -l)
    if [ $BACKUP_COUNT -gt $MAX_BACKUP_COUNT ]; then
        rm $(ls -t $WORLD_BACKUP_PATH | tail -n $(($BACKUP_COUNT - $MAX_BACKUP_COUNT)))
    fi
}

# 現在のメモリ使用量を取得
MEMORY_USAGE=$(free | awk '/Mem:/ {print int($3/$2 * 100.0)}')
echo "Memory usage: $MEMORY_USAGE%"

# サーバーのメモリ使用量をワールドに通知
send_world_message "MemoryUsage=$MEMORY_USAGE%/$THRESHOLD%"

# 使用量が閾値を超えた場合
if [ $MEMORY_USAGE -gt $THRESHOLD ]; then
  # Discordに通知
  send_discord_message "メモリ使用量が閾値を超えました。1分後にワールドサーバーを強制的に再起動します。 メモリ使用量: $MEMORY_USAGE%"
  # ワールド内に通知
  send_world_message "Restarting_server_in_1_minute_due_to_high_memory_usage._please_log_out."
  # 1分待機
  sleep 60
  # セーブを実行してから10秒待機
  save_world_data
  # セーブ中であることをDiscordとワールド内に通知
  send_discord_message "ワールドデータをセーブ中です。"
  send_world_message "Saving_world_data."
  sleep 10
  # 最終ワールド通知を送信
  send_world_message "Saving_world_data_completed._Restarting_server_now."
  sleep 5
  # ワールドサーバーを停止してDsicordに通知し、10秒待機
  sudo systemctl stop palserver.service
  send_discord_message "ワールドサーバーを停止しました。"
  # サーバー停止後にワールドデータのバックアップを作成して10秒待機
  backup_world_data
  sleep 10
  # ワールドサーバーを起動して10秒待機
  sudo systemctl start palserver.service
  sleep 10
  # 再起動完了をDiscordに通知
  send_discord_message "ワールドサーバーの再起動が完了しました。"
fi
