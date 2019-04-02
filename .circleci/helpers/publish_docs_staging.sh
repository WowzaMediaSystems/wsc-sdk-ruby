echo
echo "---===[ publish_docs_staging.sh ]===---"
echo

# Copy the generated docs to the server.
aws s3 cp doc/ s3://wsc-docs-staging-204107a9f6/resources/wsc/sdk/ruby --recursive --acl public-read
