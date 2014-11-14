# Default branch is :master, so it does not need to be specified
# Set the branch to master
branch_to_deploy = 'master'
set :branch, branch_to_deploy

# Set the deploy folder to be the location of the current version
# this will need to be updated whenever a new issue needs to be deployed
# !!!!make sure you update this BEFORE running cap production deploy!!!!
# The symbolic link "current" in /var/www/rural-reader will also need to be updated
# to match the 'current' folder in this location
folder_to_deploy = '/var/www/rural-reader/2015/q2'
set :deploy_to, folder_to_deploy

# Display a status message with the selected options
puts "Deploying branch: #{branch_to_deploy} to folder: #{folder_to_deploy}"
