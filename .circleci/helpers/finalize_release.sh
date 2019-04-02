echo
echo "---===[ finalize_release.sh ]===---"
echo

# Generate the version tag.
VERSION_TAG=`bundle exec ruby -e 'require "wsc_sdk"' -e 'puts WscSdk::VERSION'`

git config --global push.default current

# Commit/push updated files
git add .
git commit -m "SDK release version ${VERSION_TAG} [ci skip]"
git push origin

# Tag the commit and update the REPO.
git push origin ":${VERSION_TAG}"
git tag --delete ${VERSION_TAG}
git tag -a v${VERSION_TAG} -m "Released version: ${VERSION_TAG}"
git push --tags > /dev/null 2>&1

# git push origin :refs/tags/v${VERSION_TAG}
# git tag -fa v${VERSION_TAG}
# git push origin --tags
# git push origin
