#!/bin/bash

# sourceコマンドで読み込んでDiscordにメッセージを送信する関数を使用するためのスクリプト

# DISCORDのWebhookのURL
WEBHOOK_URL="https://discord.com/api/webhooks/xxxxxxx"

# Discordにメッセージを送信する関数
send_discord_message() {
    local message=$1
    curl -X POST -H "Content-Type: application/json" -d "{\"content\": \"$message\"}" $WEBHOOK_URL
    echo "Message sent to Discord: $message"
}
