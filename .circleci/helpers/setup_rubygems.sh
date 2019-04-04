rubygems_dir=~/.gem

echo "Reading the RubyGems API key passed in from the environment variables so"
echo "we can build the ${rubygems_dir}/credentials file."
: "${RUBYGEMS_API_KEY:?Need to set RUBYGEMS_API_KEY}"

# Build the gems credentials for rubygems.org
mkdir -p ${rubygems_dir}
echo "---" > ${rubygems_dir}/credentials
echo ":rubygems_api_key: ${RUBYGEMS_API_KEY}" >> ${rubygems_dir}/credentials
chmod 0600 ${rubygems_dir}/credentials

echo
cat ${rubygems_dir}/credentials
echo
