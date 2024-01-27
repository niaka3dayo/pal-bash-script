#!/bin/bash

# sourceコマンドで読み込んでRCON用の関数を使用するためのスクリプト

# セーブデータのパス
WORLD_SAVE_PATH="/home/ubuntu/Steam/steamapps/common/PalServer/Pal/Saved/SaveGames"

# セーブデータのバックアップ保存先のパス
WORLD_BACKUP_PATH="/home/ubuntu/PalSeverBackup"

# 作成するバックアップの最大数
MAX_BACKUP_COUNT=5

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
