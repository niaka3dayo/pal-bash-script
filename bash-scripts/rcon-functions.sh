#!/bin/bash

# sourceコマンドで読み込んでRCON用の関数を使用するためのスクリプト
# mcronコマンドを使用しているため、RCONが有効で、mcrconコマンドが使用可能である必要がある
# 他のRCONクライアントを使用する場合は、この関数を書き換える必要がある

# RCONのIPアドレス
RCON_IP="127.0.0.1"

# RCONのポート番号 適時変更
RCON_PORT="25575"

# RCONの管理者用パスワード 適時変更
RCON_PASSWORD="password"

# ワールド内にメッセージを送信する関数
send_world_message() {
    local message=$1
    CURRENT_TIME=$(TZ=Asia/Tokyo date '+%H:%M')
    mcrcon -H $RCON_IP -P $RCON_PORT -p $RCON_PASSWORD "Broadcast [$CURRENT_TIME]:$message"
    echo "Message sent to world: [$CURRENT_TIME]:$message"
}

# ワールドデータをセーブする関数
save_world_data() {
    mcrcon -H $RCON_IP -P $RCON_PORT -p $RCON_PASSWORD "Save"
    echo "Save command sent to world."
}
