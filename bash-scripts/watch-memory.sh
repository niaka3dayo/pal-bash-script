#!/bin/bash

# RCON用の関数を読み込み
. /home/ubuntu/bash-scripts/rcon-functions.sh

# Discordにメッセージを送信する関数を読み込み
. /home/ubuntu/bash-scripts/send-discord-message.sh

# ワールドデータをバックアップする関数を読み込み
. /home/ubuntu/bash-scripts/backup-world-data.sh

# 再起動が必要と判断するしきい値（パーセントで指定）
THRESHOLD=80

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
