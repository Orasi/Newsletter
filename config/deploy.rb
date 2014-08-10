# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'rr_q1_fy15'
set :repo_url, 'git@github.com:LGordon2/rural_reader_q1.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/rural-reader/2015/q1'

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
set :keep_releases, 1

namespace :deploy do
  after :publishing, :restart do
    on roles(:all) do |host|
      within "#{deploy_to}/current/" do
        execute :pwd
        execute :bundle, :install
        execute :bundle, :exec, :rake
      end
    end
  end
end
