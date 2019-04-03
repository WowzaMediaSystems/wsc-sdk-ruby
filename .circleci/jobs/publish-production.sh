
echo "-----=====[ publish-staging.sh ]======-----"
echo

. ./.circleci/helpers/debundle-context.sh

. ./.circleci/helpers/setup.sh

. ./.circleci/helpers/test_unit.sh

. ./.circleci/helpers/test_integration.sh

. ./.circleci/helpers/build_docs.sh

. ./.circleci/helpers/publish_docs.sh

# /bin/bash ./.circleci/helpers/finalize_release.sh
