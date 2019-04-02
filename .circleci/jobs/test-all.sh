
echo "-----=====[ test-all.sh ]======-----"
echo

. ./.circleci/helpers/setup.sh

. ./.circleci/helpers/test_unit.sh

. ./.circleci/helpers/test_integration.sh
