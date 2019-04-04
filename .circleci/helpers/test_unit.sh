echo
echo "---===[ test_unit.sh ]===---"
echo

# bundle exec rspec ./spec/unit --tag unit_test
bundle exec rspec ./spec/unit --tag unit_test --format documentation --format RspecJunitFormatter --out ./test_results/rspec_unit/results.xml
