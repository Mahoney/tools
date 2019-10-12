#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

main() {
  declare file_path="$1"
  declare file_pattern="$2"
  source_paths=()
  while IFS='' read -r line; do source_paths+=("$line"); done < <(find -E "$file_path" -regex ".*/$file_pattern\.java")

  for source_path in "${source_paths[@]}"; do
    with_kotlin_dir="${source_path//\/java\///kotlin/}"
    destination_path="${with_kotlin_dir//.java/.kt}"

    mkdir -p "$(dirname "$destination_path")"
    mv "$source_path" "$destination_path"
    git add "$source_path" "$destination_path"
  done

  git commit -m "Moved files in $file_path matching $file_pattern to kotlin"

  for old_source_path in "${source_paths[@]}"; do
    with_kotlin_dir="${old_source_path//\/java\///kotlin/}"
    new_path="${with_kotlin_dir//.java/.kt}"

    mv "$new_path" "$with_kotlin_dir"
    git add "$new_path" "$with_kotlin_dir"

    echo "Prepared $with_kotlin_dir for conversion to kotlin in IDEA"
  done

  echo ""
  echo "Now go to each of the files listed as prepared above and press Shift-Alt-Cmd K to migrate it to kotlin, then commit the results"
}

main "$@"
