
echo "-----=====[ build-and-deploy-master.sh ]======-----"
echo

. ./.circleci/helpers/setup.sh

. ./.circleci/helpers/build_gem.sh

. ./.circleci/helpers/build_docs.sh

. ./.circleci/helpers/publish_gem.sh

. ./.circleci/helpers/publish_docs_prod.sh
