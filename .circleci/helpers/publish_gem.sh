echo
echo "---===[ publish_gem.sh ]===---"
echo


rubygems_dir="~/.gem"

echo
cat ${rubygems_dir}/credentials
echo

# Push the gem to rubygems.
gem push pkg/* --verbose --key rubygems --debug --backtrace --config-file ${rubygems_dir}/credentials
