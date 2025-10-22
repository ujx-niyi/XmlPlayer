#!/usr/bin/env bash
set -e

cmd="$1"
shift || true

case "$cmd" in
  pytest)
    echo "🧪 Running pytest..."
    exec pytest "$@"
    ;;
  allure)
    echo "📊 Generating Allure report..."
    exec allure "$@"
    ;;
  bash)
    echo "🐚 Starting bash..."
    exec bash "$@"
    ;;
  *)
    echo "▶ Running Excel→XML→HTML→PDF conversion..."
    exec python excel_to_xml_converter.py "$cmd" "$@"
    ;;
esac
