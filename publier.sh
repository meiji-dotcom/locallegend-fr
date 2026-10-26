#!/bin/bash
# Met en ligne la derniere version OFFICIELLE du jeu sur le nom de domaine locallegend.fr (depot GitHub "locallegend-fr", GitHub Pages).
# A lancer APRES promouvoir_officiel.sh (qui exporte le jeu dans /Users/jules/Audit/local-legend). Meme contenu que github-deploy/publier.sh.
# Usage : bash publier.sh
set -e
cd "$(dirname "$0")"
SRC=/Users/jules/Audit/local-legend
REMOTE=https://github.com/meiji-dotcom/locallegend-fr.git
if [ ! -d .git ]; then
  git init -b main
  git remote add origin "$REMOTE"
fi
rsync -a --delete --exclude '.git' --exclude 'publier.sh' --exclude '.nojekyll' --exclude 'CNAME' --exclude 'LISEZMOI.txt' \
  --include 'index.html' --include 'index.js' --include 'index.wasm' --include 'index.pck' --include 'index.png' \
  --include 'index.icon.png' --include 'index.apple-touch-icon.png' --include 'index.audio*.js' --include 'city_*.pck' --include 'musique/' --include 'musique/*.mp3' \
  --exclude '*' "$SRC/" ./
touch .nojekyll
echo "locallegend.fr" > CNAME # GitHub Pages : le nom de domaine du site
git add -A
# on remplace le dernier envoi au lieu d'en empiler un nouveau : le depot reste leger (le fichier .wasm pese 38 Mo)
if git rev-parse HEAD >/dev/null 2>&1; then
  git commit --amend -m "Local Legend" --allow-empty
  git push --force origin HEAD:main
else
  git commit -m "Local Legend"
  git push -u origin HEAD:main
fi
echo "Envoye. Le site se met a jour en 1 a 2 minutes : https://locallegend.fr"
