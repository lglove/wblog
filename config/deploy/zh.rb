set :domain, 'www.lige.space'
set :deploy_to, '/opt/app/lige_blog'
set :repository, 'git@github.com:lglove/wblog.git'
set :branch, 'master'
set :user, 'ruby'
set :unicorn_config, -> { "#{deploy_to}/#{current_path}/config/unicorn/zh.rb" }
