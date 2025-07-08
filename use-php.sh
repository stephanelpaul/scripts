#!/bin/zsh

if [ -z "$1" ]; then
  echo "Usage: source use-php.sh <version> (e.g., 8.1, 8.2, 7.4)"
  return 1
fi

PHP_VERSION="$1"
PHP_FORMULA="php@$PHP_VERSION"
PHP_PATH="/opt/homebrew/opt/$PHP_FORMULA"

if [ ! -d "$PHP_PATH" ]; then
  echo "PHP $PHP_VERSION is not installed."

  echo -n "Do you want to install $PHP_FORMULA using Homebrew? (y/N): "
  read confirm

  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "Checking if formula exists..."
    if ! brew info "$PHP_FORMULA" &>/dev/null; then
      echo "Formula not found. Tapping shivammathur/php for legacy PHP versions..."
      brew tap shivammathur/php
    fi

    echo "Installing $PHP_FORMULA..."
    brew install "$PHP_FORMULA"

    if [ $? -ne 0 ] || [ ! -d "$PHP_PATH" ]; then
      echo "❌ Installation failed or formula not found. Aborting."
      return 1
    fi
  else
    echo "Aborted."
    return 1
  fi
fi

CLEANED_PATH=$(echo "$PATH" | tr ':' '\n' | grep -v '/opt/homebrew/opt/php@' | paste -sd: -)
export PATH="$PHP_PATH/bin:$PHP_PATH/sbin:$CLEANED_PATH"

echo "✅ Switched to PHP $PHP_VERSION"
php -v
