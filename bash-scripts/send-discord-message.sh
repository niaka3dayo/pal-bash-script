#!/bin/bash

# DISCORDのWebhookのURL
WEBHOOK_URL="https://discord.com/api/webhooks/xxxxxxx"

# Discordにメッセージを送信する関数
send_discord_message() {
    local message=$1
    curl -X POST -H "Content-Type: application/json" -d "{\"content\": \"$message\"}" $WEBHOOK_URL
    echo "Message sent to Discord: $message"
}

# メッセージの送信を実行
send_discord_message "$1"
