# This file contains the settings for creating the production version of the website
# that is hosted at [http://ruraldirectory.orasi.com/rural_reader/].
# To deploy it, run the command "bundle exec cap production deploy".
# It will build the production site from your master git branch, regardless of
# your current working branch
#
# IMPORTANT: make sure that [folder_to_deploy] is correctly set to the
# date of the CURRENT edition that is already out or coming out for the first time
# NOT a future or past edition
#
# Also make sure that all changes have been pushed to master on git, otherwise
# they won't be reflected on the live production site.

# Set the branch to master
branch_to_deploy = 'master'
set :branch, branch_to_deploy

# Set the deploy folder to be the location of the current version
# this will need to be updated whenever a new issue needs to be deployed
# !!!!Make sure you update this BEFORE running cap production deploy!!!!
folder_to_deploy = '/var/www/rural-reader/2015/q4'
set :deploy_to, folder_to_deploy

# Set the name and location of the symlink
# The webserver uses symbolic links to know where the content is for the link:
# http://ruraldirectory.orasi.com/rural_reader/
# Capistrano uses these settings to delete the old symlink and create a new
# one with the updated content
symlink_name = '/var/www/rural-reader/current'
set :sym_name, symlink_name
symlink_location = "#{folder_to_deploy}/current/"
set :sym_location, symlink_location

# Display a status message with the selected options and validate with the user
puts "\nDeploying branch: #{branch_to_deploy} to folder: #{folder_to_deploy}\n"
puts "\n\e[0;33mIs this the correct confiuration?\e[0m"
set :response, ask("\e[0;32m'Y'\e[0m to continue,\e[0;31m 'N'\e[0m to abort.", nil)
validate = fetch(:response)
unless validate.upcase == 'Y'
  puts "\e[0;31m Aborting......\e[0m\n"
  exit
end
