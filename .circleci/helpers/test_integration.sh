echo
echo "---===[ test_integration.sh ]===---"
echo

echo "Reading the API configuration from the environment variables so we can"
echo "run the integration tests."
: "${WSC_API_KEY:?Need to set WSC_API_KEY}"
: "${WSC_API_ACCESS_KEY:?Need to set WSC_API_ACCESS_KEY}"
: "${WSC_API_TEST_HOSTNAME:?Need to set WSC_API_TEST_HOSTNAME}"


# bundle exec rspec ./spec/integration --tag integration_test --format documentation --format RspecJunitFormatter --out ./test_results/rspec_integration/results.xml
