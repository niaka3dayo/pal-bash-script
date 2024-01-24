#!/bin/bash

# このスクリプトは、PalWorldのサーバー設定ファイルを更新するためのものです。
# 1行にまとめて書くのが面倒なので、このスクリプトを使っています。

# INIファイルのパス 適宜
INI_FILE="/home/ubuntu/Steam/steamapps/common/PalServer/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini"

# 変数に改行された設定内容を定義
# 下記公式ドキュメントを参考に記載されていないものは未実装です。
# @see https://tech.palworldgame.com/optimize-game-balance
declare -a settings
settings=(
    # 難易度
    Difficulty=None
    # 昼の経過速度
    DayTimeSpeedRate=1.000000
    # 夜の経過速度
    NightTimeSpeedRate=1.000000
    # 経験値獲得倍率
    ExpRate=1.000000
    # パルの捕獲率倍率
    PalCaptureRate=1.000000
    # パルの出現倍率
    PalSpawnNumRate=1.000000
    # パルの与えるダメージ倍率
    PalDamageRateAttack=1.000000
    # パルの受けるダメージ倍率
    PalDamageRateDefense=1.000000
    # プレイヤーの与えるダメージ倍率
    PlayerDamageRateAttack=1.000000
    # プレイヤーの受けるダメージ倍率
    PlayerDamageRateDefense=1.000000
    # プレイヤーの満腹度減少倍率
    PlayerStomachDecreaceRate=1.000000
    # プレイヤーのスタミナ減少倍率
    PlayerStaminaDecreaceRate=1.000000
    # プレイヤーのHP自動回復倍率
    PlayerAutoHPRegeneRate=1.000000
    # プレイヤーの睡眠時HP自動回復倍率
    PlayerAutoHpRegeneRateInSleep=1.000000
    # パルの満腹度減少倍率
    PalStomachDecreaceRate=1.000000
    # パルのスタミナ減少倍率
    PalStaminaDecreaceRate=1.000000
    # パルのHP自動回復倍率
    PalAutoHPRegeneRate=1.000000
    # パルの睡眠時HP自動回復倍率
    PalAutoHpRegeneRateInSleep=1.000000
    # 建造物に対するダメージ倍率
    BuildObjectDamageRate=1.000000
    # 建造物の劣化速度倍率
    BuildObjectDeteriorationDamageRate=1.000000
    # 採集アイテムのドロップ倍率
    CollectionDropRate=1.000000
    # 採集アイテムのHP倍率
    CollectionObjectHpRate=1.000000
    # 採集アイテムのリスポーン間隔
    CollectionObjectRespawnSpeedRate=1.000000
    # ドロップアイテム量の倍率
    EnemyDropItemRate=1.000000
    # デスペナルティ None : ロスト無し, Item : 装備品以外のアイテム, ItemAndEquipment : すべての装備品とアイテム, All : 全ての装備品と装備品と手持ちパル
    DeathPenalty=None
    # 未実装: フィールドPKの有効化
    bEnablePlayerToPlayerDamage=False
    # 未実装: フレンドリーファイアの有効化
    bEnableFriendlyFire=False
    # 未実装: 侵略者の有効化
    bEnableInvaderEnemy=True
    # 未実装: UNKOの有効化
    bActiveUNKO=False
    # 未実装: パッドのエイムアシストの有効化
    bEnableAimAssistPad=True
    # 未実装: キーボードのエイムアシストの有効化
    bEnableAimAssistKeyboard=True
    # 未実装: ドロップアイテムの最大数
    DropItemMaxNum=3000
    # 未実装: 何かの最大数
    DropItemMaxNum_UNKO=100
    # 未実装: 拠点の最大数
    BaseCampMaxNum=64
    # 未実装: 拠点の最大パル数
    BaseCampWorkerMaxNum=20
    # 未実装: ドロップアイテムの最大生存時間(h)
    DropItemAliveMaxHours=1.000000
    # 未実装: 未ログイン状態のギルドの自動解体
    bAutoResetGuildNoOnlinePlayers=False
    # 未実装: 未ログイン状態のギルドの自動解体時間(h)
    AutoResetGuildTimeNoOnlinePlayers=72.000000
    # ギルドの最大人数
    GuildPlayerMaxNum=32
    # タマゴの孵化時間(h)
    PalEggDefaultHatchingTime=1.000000
    # 未実装: 作業速度倍率
    WorkSpeedRate=1.000000
    # 未実装: マルチプレイの有効化
    bIsMultiplay=False
    # 未実装: PvPの有効化
    bIsPvP=False
    # 未実装: 他ギルドの死亡ペナルティのドロップアイテムの拾えるか
    bCanPickupOtherGuildDeathPenaltyDrop=False
    # 未実装: 長期非ログイン時のペナルティの有効化
    bEnableNonLoginPenalty=True
    # 未実装: ファストトラベルの有効化
    bEnableFastTravel=True
    # 未実装: スタート位置のマップ選択の有効化
    bIsStartLocationSelectByMap=True
    # 未実装: ログアウト後のプレイヤーの残存の有効化
    bExistPlayerAfterLogout=False
    # 未実装: 他ギルドプレイヤーの防衛の有効化
    bEnableDefenseOtherGuildPlayer=False
    # 未実装: Coopプレイヤーの最大人数
    CoopPlayerMaxNum=4
    # サーバーの最大人数
    ServerPlayerMaxNum=32
    # サーバーの名前 ダブルクオーテーションの前にはエスケープ文字を付ける
    ServerName=\"Pal_World\"
    # サーバーの説明 ダブルクオーテーションの前にはエスケープ文字を付ける
    ServerDescription=\"Server_of_pal_world\"
    # サーバー管理者のパスワード 適時変更 ダブルクオーテーションの前にはエスケープ文字を付ける
    AdminPassword=\"password\"
    # サーバーのパスワード 適時変更 ダブルクオーテーションの前にはエスケープ文字を付ける
    ServerPassword=\"\"
    # サーバーのポート番号
    PublicPort=8211
    # 公開IPアドレス
    PublicIP=\"\"
    # RCONの有効化
    RCONEnabled=True
    # RCONのポート番号
    RCONPort=25575
    # 未実装: リージョン
    Region=\"\"
    # 未実装: 認証の有効化
    bUseAuth=True
    # 未実装: BANリストのURL
    BanListURL=\"https://api.palworldgame.com/api/banlist.txt\"
)

# INIの1行目に記述する内容
FIRST_LINE_CONTENT="[/Script/Pal.PalGameWorldSettings]"

# INIの2行目の最初に記述する内容
SECOND_LINE_PREFIX="OptionSettings=("

# INIの2行目の設定値をループで結合
SECOND_LINE_CONTENT=""
for setting in "${settings[@]}"; do
    SECOND_LINE_CONTENT+="$setting,"
done

# 末尾の余分なカンマを削除
SECOND_LINE_CONTENT=${SECOND_LINE_CONTENT%,}

# INIの2行目の最後に記述する内容
SECOND_LINE_SUFFIX=")"

# 一行にまとめた内容をINIファイルに上書きする
echo "$FIRST_LINE_CONTENT" > "$INI_FILE"
echo "$SECOND_LINE_PREFIX$SECOND_LINE_CONTENT$SECOND_LINE_SUFFIX" >> "$INI_FILE"
