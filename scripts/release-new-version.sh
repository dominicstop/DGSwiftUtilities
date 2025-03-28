#!/bin/bash

# assuming the script is run on repo root
# e.g. `sh ./scripts/release-new-version.sh`
podspec_file=$(ls ./*.podspec 2>/dev/null)

# extract name and ver. from the .podspec file
podspec_name=$(grep -m 1 's.name' "$podspec_file" | awk -F "'|\"" '{print $2}')
podspec_version=$(grep -m 1 's.version' "$podspec_file" | awk -F "'|\"" '{print $2}')

# get pod versions
pod_info_raw=$(pod trunk info $podspec_name)

# extract version numbers 
pod_published_versions=$(
  echo "$pod_info_raw" | grep -o '\b[0-9]\+\.[0-9]\+\.[0-9]\+\b' | sort -V
)

for version in $pod_published_versions; do
  pod_published_version_latest=$version
done

echo "Podspec name: $podspec_name"
echo "Podspec current version (local): $podspec_version"
echo "Podspec current version (remote): $pod_published_version_latest"


last_version_tag=$(git describe --tags)
echo "Git - Latest version tag: $last_version_tag"

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