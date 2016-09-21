rbenv_ruby "2.3.1" do
  global true
end

rbenv_gem "bundler" do
  ruby_version "2.3.1"
end

execute "install project gems" do
  command "cd /vagrant && bundle install"
end

execute "prepare database for rails project" do
  command "cd /vagrant && bundle exec rails db:create && bundle exec rails db:migrate"
end

execute "run project" do
  command "cd /vagrant && bundle exec rails s -p 3001 &"
end
