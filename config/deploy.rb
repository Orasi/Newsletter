# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'rr_q1_fy15'
set :repo_url, 'git@github.com:Orasi/Newsletter.git'

# create the deploy environments and set staging as default
set :stages, ["staging", "production"]
set :default_stage, "staging"

# tell the remote machine to only update from git instead of 
# cloning the entire repo each time


# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :web, %w{damien@69.61.108.36}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server '69.61.108.36', user: 'damien', roles: %w{web}

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{/var/www/rural-directory/rural_reader}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 2

namespace :deploy do
  after :publishing, :restart do
    on roles(:all) do |host|
      within "#{deploy_to}/current/" do
        execute :bundle, 'install --deployment'
        execute :bundle, :exec, :rake
      end
    end
  end
end
