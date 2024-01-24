#!/bin/sh

# このスクリプトは、SteamCMDを使って、Palworldのゲームサーバーを更新します。

# Steam CMD のパス
STEAM_CMD="/home/ubuntu/steamcmd.sh"

# パルワールドのインストールディレクトリ
INSTALL_DIR="/home/ubuntu/Steam/steamapps/common/PalServer"

# サーバーのデーモン名
DAEMON_NAME="palserver.service"

echo "# Check the environment."
date
OLD_Build=`$STEAM_CMD +force_install_dir $INSTALL_DIR +login anonymous +app_status 2394010 +quit | grep -e "BuildID" | awk '{print $8}'`
echo "Old BuildID: $OLD_Build"

echo "# Start updating the game server..."
$STEAM_CMD +force_install_dir $INSTALL_DIR +login anonymous +app_update 2394010 validate +quit > /dev/null

echo "# Check the environment after the update."
NEW_Build=`$STEAM_CMD +force_install_dir $INSTALL_DIR +login anonymous +app_status 2394010 +quit | grep -e "BuildID" | awk '{print $8}'`
echo "New BuildID: $NEW_Build"

# Check if updated.
if [ $OLD_Build = $NEW_Build ]; then
    echo "Build number matches."
else
    echo "Restart $DAEMON_NAME because an game update exists."
    sudo systemctl stop $DAEMON_NAME
    sudo systemctl start $DAEMON_NAME
    systemctl status $DAEMON_NAME
fi
