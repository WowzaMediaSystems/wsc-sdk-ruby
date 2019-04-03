
echo "-----=====[ build-and-deploy-master.sh ]======-----"
echo

. ./.circleci/helpers/debundle-context.sh

. ./.circleci/helpers/setup.sh

. ./.circleci/helpers/test_unit.sh

. ./.circleci/helpers/test_integration.sh

. ./.circleci/helpers/build_gem.sh

. ./.circleci/helpers/build_docs.sh

. ./.circleci/helpers/release_gem.sh

. ./.circleci/helpers/publish_docs.sh

. ./.circleci/helpers/finalize_release.sh
