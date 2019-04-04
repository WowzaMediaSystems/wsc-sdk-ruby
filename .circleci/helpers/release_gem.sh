echo
echo "---===[ release_gem.sh ]===---"
echo

rubygems_dir=~/.gem

# Push the gem to rubygems.
gem push pkg/* --verbose --key rubygems --debug --backtrace --config-file ${rubygems_dir}/credentials
