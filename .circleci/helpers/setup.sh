echo
echo "---===[ setup.sh ]===---"
echo

. ./.circleci/helpers/setup_gem.sh

. ./.circleci/helpers/setup_rubygems.sh

. ./.circleci/helpers/setup_aws.sh

. ./.circleci/helpers/setup_git.sh
