# This file contains the settings for creating the staging version of the website
# that is hosted at [http://ruraldirectory.orasi.com/next_rural_reader/].
# To deploy it, run the command "bundle exec cap staging deploy".
# It will build the staging site from your current working git branch, which
# should NOT be the master branch - this is the staging environment and
# should be a work in progress
#
# IMPORTANT: make sure that [folder_to_deploy] is correctly set to the
# date of the NEXT edition that is about to come out, NOT the current one
#
# Also make sure that you have committed any changes to the site to the repository
# or they won't be reflected on the live staging site.

# Set the deploy branch to the current branch
branch_to_deploy = `git symbolic-ref HEAD 2> /dev/null`.strip.gsub(/^refs\/heads\//, '')
set :branch, branch_to_deploy

# Set the deploy folder to be the location of the next version while in development.
# This will need to be updated whenever a new issue needs to be deployed
folder_to_deploy = '/var/www/rural-reader/2015/q3'
set :deploy_to, folder_to_deploy

# Set the name and location of the symlink
# The webserver uses symbolic links to know where the content is for the link:
# http://ruraldirectory.orasi.com/next_rural_reader/
# Capistrano uses these settings to delete the old symlink and create a new
# one with the updated content
symlink_name = '/var/www/rural-reader/next'
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
