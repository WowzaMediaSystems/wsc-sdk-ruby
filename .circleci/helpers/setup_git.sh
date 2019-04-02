ssh_dir="~/.ssh"

echo "Reading the base64 encoded git_ssh_key passed in as environment variable"
echo "and putting it in the ${ssh_dir}/id_rsa file"
: "${GIT_SSH_KEY_BASE64:?Need to set GIT_SSH_KEY_BASE64}"

mkdir -p "${ssh_dir}"

ssh-keyscan github.com >> ~/.ssh/known_hosts
ssh-keyscan wowza.git.beanstalkapp.com >> ~/.ssh/known_hosts
ssh-keyscan wowzamedia.git.beanstalkapp.com >> ~/.ssh/known_hosts

export GIT_SSH_KEY_FILE="${ssh_dir}/id_rsa"
echo $GIT_SSH_KEY_BASE64 | base64 -d > $GIT_SSH_KEY_FILE
chmod 600 $GIT_SSH_KEY_FILE

# Remove the default keyfile from teh agent (the read only one that circle uses)
ssh-add -D
# Add our more powerful key
ssh-add ${GIT_SSH_KEY_FILE}

# Setup the git configuration
git config --global user.email "circleci@wowza.com"
git config --global user.name "CirlceCI"
