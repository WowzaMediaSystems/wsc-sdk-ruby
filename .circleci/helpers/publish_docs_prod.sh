echo
echo "---===[ publish_docs_prod.sh ]===---"
echo

# Copy the generated docs to the server.
aws s3 cp doc/ s3://wsc-docs-prod-44ce08b825/resources/wsc/sdk/ruby --recursive --acl public-read
