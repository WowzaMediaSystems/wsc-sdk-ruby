echo
echo "---===[ finalize_release.sh ]===---"
echo

# Generate the version tag.
VERSION_TAG=`bundle exec ruby -e 'require "wsc_sdk"' -e 'puts WscSdk::VERSION'`

git config --global push.default current

git push origin :refs/tags/v${VERSION_TAG}
git add .
git commit -m "SDK build version ${VERSION_TAG} [ci skip]"
git tag -fa v${VERSION_TAG}
git push origin --tags
git push origin
