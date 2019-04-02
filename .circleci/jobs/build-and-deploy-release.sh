
echo "-----=====[ build-and-deploy-release.sh ]======-----"
echo

. ./.circleci/helpers/setup.sh

. ./.circleci/helpers/test_unit.sh

. ./.circleci/helpers/test_integration.sh

. ./.circleci/helpers/build_gem.sh

. ./.circleci/helpers/build_docs.sh

. ./.circleci/helpers/publish_docs_staging.sh

/bin/bash ./.circleci/helpers/finalize_release.sh
