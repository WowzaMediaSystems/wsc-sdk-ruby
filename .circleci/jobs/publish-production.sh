
echo "-----=====[ publish-staging.sh ]======-----"
echo

. ./.circleci/helpers/setup.sh

. ./.circleci/helpers/test_unit.sh

. ./.circleci/helpers/test_integration.sh

. ./.circleci/helpers/build_docs.sh

. ./.circleci/helpers/publish_docs_prod.sh

# /bin/bash ./.circleci/helpers/finalize_release.sh
