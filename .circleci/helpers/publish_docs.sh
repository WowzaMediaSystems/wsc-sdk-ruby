echo
echo "---===[ publish_docs.sh ]===---"
echo

: "${WSC_DOCS_BUCKET:?Need to set WSC_DOCS_BUCKET}"

echo "Copying doc/ directory to ${WSC_DOCS_BUCKET} bucket"

# Copy the generated docs to the server.
aws s3 cp doc/ s3://${WSC_DOCS_BUCKET}/resources/wsc/sdk/ruby --recursive --acl public-read
