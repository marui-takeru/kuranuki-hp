#!/bin/bash
# GitHub Pages 用の公開ファイルを作る。
#   元：site/index.html（試作版の本体）、素材/写真、素材/マップ
#   先：リポジトリ直下の index.html、img/、map/
# 掲載許可が済んでいない「人が写っている写真」は、写真準備中の画像に差し替える。
# 許可が取れたら、下の HOLD から名前を消して、もう一度このスクリプトを実行する。
set -euo pipefail
cd "$(dirname "$0")/.."

HOLD=""  # 2026-11-10 丸井さん確認により全写真掲載OK

rm -rf img map
mkdir -p img map
for f in 素材/写真/*.jpg; do
  name=$(basename "$f" .jpg)
  if [[ " $HOLD " == *" $name "* ]]; then
    cp 素材/placeholder.jpg "img/$name.jpg"
  else
    cp "$f" "img/$name.jpg"
  fi
done
cp 素材/マップ/hama-2.png 素材/マップ/zao-2.png map/

{
  cat <<'HEAD'
<!doctype html>
<html lang="ja">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
<meta name="robots" content="noindex,nofollow">
<style>:root{color-scheme:light;padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}body{margin:0}img{max-width:100%}[hidden]{display:none!important}</style>
HEAD
  cat site/index.html
  printf '\n</html>\n'
} > index.html

touch .nojekyll
echo "公開用ファイルを作成しました：index.html, img/, map/"
