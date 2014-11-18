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
puts "\nDeploying branch: #{branch_to_deploy} to folder: #{folder_to_deploy}\n"
puts "\n\e[0;33mIs this the correct confiuration?\e[0m"
set :response, ask("\e[0;32m'Y'\e[0m to continue,\e[0;31m 'N'\e[0m to abort.", nil)
validate = fetch(:response)
unless validate.upcase == 'Y'
  puts "\e[0;31m Aborting......\e[0m\n"
  exit
end
