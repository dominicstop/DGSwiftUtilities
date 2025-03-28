
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

echo "Input tag to delete:" 
read version

# check if version is provided...
if [ -z "$version" ]; then
  echo "Version not provided, exiting..."
  exit 1
fi

echo "Deleting tag: $version"

git tag -d "$version"
git push origin --delete "$version"
git push origin --tags

echo "Should delete version for pod? (y/n)"
read should_delete_pod_version

# check if the response is 'y' or 'Y'
if [[ "$should_delete_pod_version" == [Yy] ]]; then

  if [ -z "$podspec_name" ]; then
    echo "Could not extract podspec name, exiting..."
    exit 1
  fi

  pod trunk delete "$podspec_name" "$version"
fi

