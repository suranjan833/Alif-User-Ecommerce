#!/bin/bash

echo "-----------------------------------------"
echo "   🚀 Git Push + Split APK Auto Version"
echo "-----------------------------------------"

# =====================================
# 🔥 APP NAME (CHANGE HERE)
# =====================================
APP_NAME="Alif Ecommerce"

# =====================================
# INSTALL FZF
# =====================================
install_fzf() {
  echo "📦 Installing fzf..."

  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install fzf
  else
    sudo apt update && sudo apt install -y fzf
  fi
}

command -v fzf >/dev/null 2>&1 || install_fzf

# =====================================
# CHECK GIT REPO
# =====================================
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
  echo "❌ Not inside git repo"
  exit 1
}

# =====================================
# VERSION AUTO INCREMENT
# =====================================
PUBSPEC="pubspec.yaml"

if [ ! -f "$PUBSPEC" ]; then
  echo "❌ pubspec.yaml not found"
  exit 1
fi

current_version=$(grep '^version:' $PUBSPEC | awk '{print $2}')

version_name=$(echo $current_version | cut -d'+' -f1)
build_number=$(echo $current_version | cut -d'+' -f2)

IFS='.' read -r major minor patch <<< "$version_name"

# 🔥 AUTO PATCH INCREMENT
patch=$((patch + 1))

# 🔥 BUILD NUMBER INCREMENT
if [ -z "$build_number" ]; then
  build_number=1
else
  build_number=$((build_number + 1))
fi

new_version="$major.$minor.$patch+$build_number"

echo ""
echo "📌 Current Version : $current_version"
echo "🚀 New Version     : $new_version"

# =====================================
# UPDATE PUBSPEC VERSION
# =====================================
sed -i.bak "s/^version: .*/version: $new_version/" $PUBSPEC
rm -f pubspec.yaml.bak

echo "✅ pubspec.yaml updated"

# =====================================
# VERSION FOR APK NAME
# =====================================
apk_version="$major.$minor.$patch"

# =====================================
# REMOTE
# =====================================
remotes=$(git remote)

if [ -z "$remotes" ]; then

  read -p "Remote name (origin): " rname
  rname=${rname:-origin}

  read -p "Remote URL: " rurl

  git remote add "$rname" "$rurl"

  remote="$rname"

else

  remote=$(printf "%s\n" "$remotes" | fzf --prompt="Select remote: ")

fi

echo "📡 Using remote: $remote"

# =====================================
# BRANCH
# =====================================
branches=$(git branch 2>/dev/null | sed 's/^..//')

if [ -z "$branches" ]; then

  echo "⚠️ No branch exists"

  read -p "Create branch name (main): " branch
  branch=${branch:-main}

  git checkout -b "$branch"

  echo "🌿 Created branch: $branch"

else

  current=$(git rev-parse --abbrev-ref HEAD)

  echo ""
  echo "🌿 Current branch: $current"

  branch=$(printf "%s\n" "$branches" | fzf --prompt="Select branch (Enter = current): ")

  if [ -z "$branch" ]; then
    branch="$current"
  fi

  git checkout "$branch"

fi

echo "🌿 Using branch: $branch"

# =====================================
# COMMIT
# =====================================
echo ""

read -p "Commit message: " commit

[ -z "$commit" ] && {
  echo "❌ Commit message required"
  exit 1
}

read -p "Add timestamp suffix? (Y/n): " add_time
add_time=${add_time:-Y}

if [[ "$add_time" =~ ^[Yy]$ ]]; then
  time=$(date +"%I:%M:%S %p")
  commit="$commit | $time"
fi

# =====================================
# FLUTTER BUILD SPLIT APK
# =====================================
echo ""
echo "🧹 Cleaning project..."

flutter clean

echo ""
echo "📦 Getting packages..."

flutter pub get

echo ""
echo "⚙️ Building Split APK..."

flutter build apk --split-per-abi

if [ $? -ne 0 ]; then
  echo "❌ APK Build Failed"
  exit 1
fi

# =====================================
# RENAME APK FILES
# =====================================
APK_DIR="build/app/outputs/flutter-apk"

echo ""
echo "📦 Renaming APK files..."

# Prefer arm64 build
TARGET_APK=$(find "$APK_DIR" -name "*arm64-v8a*.apk" | head -n 1)

# fallback if arm64 not found
if [ -z "$TARGET_APK" ]; then
  TARGET_APK=$(find "$APK_DIR" -name "*.apk" | head -n 1)
fi

NEW_NAME="${APP_NAME}-v${apk_version}.apk"

cp "$TARGET_APK" "$APK_DIR/$NEW_NAME"

echo "✅ $NEW_NAME"
# =====================================
# GIT PUSH
# =====================================
git add .

if git diff --cached --quiet; then
  echo "⚠️ Nothing to commit"
  exit 0
fi

git commit -m "$commit"

git push -u "$remote" "$branch"

echo ""
echo "-----------------------------------------"
echo "✅ Code pushed → $remote/$branch"
echo "🚀 Split APK Build Complete"
echo "📦 Version: $new_version"
echo "📂 APK Folder: $APK_DIR"
echo "-----------------------------------------"