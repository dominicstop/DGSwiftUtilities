#!/bin/bash

# assuming the script is run on repo root
# e.g. `sh ./scripts/release-new-version.sh`
podspec_file=$(ls ./*.podspec 2>/dev/null)

# extract name and ver. from the .podspec file
podspec_name=$(grep -m 1 's.name' "$podspec_file" | awk -F "'|\"" '{print $2}')
podspec_version=$(grep -m 1 's.version' "$podspec_file" | awk -F "'|\"" '{print $2}')

echo "Podspec name: $podspec_name"
echo "Podspec version: $podspec_version"

last_version_tag=$(git describe --tags)
echo "Latest version tag: $last_version_tag"

echo "Input new version:" 
read version

# check if verison is provided...
if [ -z "$version" ]; then
  echo "Version not provided. Exiting."
  exit 1
fi

echo "Releasing version: $version"

git tag "$version"
git push origin --tags
pod trunk push 
git push