aws_dir=~/.aws

echo "Reading the AWS configuration from the environment variables so we can"
echo "build the ${aws_dir}/credentials file."
: "${AWS_ACCESS_KEY_ID:?Need to set AWS_ACCESS_KEY_ID}"
: "${AWS_SECRET_ACCESS_KEY:?Need to set AWS_SECRET_ACCESS_KEY}"

# Build the AWS credentials
mkdir -p ${aws_dir}
echo "[default]" > ${aws_dir}/credentials
echo "aws_access_key_id = $AWS_ACCESS_KEY_ID" >> ${aws_dir}/credentials
echo "aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >> ${aws_dir}/credentials
chmod 0600 ${aws_dir}/credentials
