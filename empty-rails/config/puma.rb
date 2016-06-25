require 'pathname'

environment 'production'

app_root = Pathname.new('../../').expand_path(__FILE__)
logs_dir = app_root.join('log')
tmp_dir  = app_root.join('tmp')
pids_dir = tmp_dir.join('pids')

pidfile pids_dir.join('puma.pid').to_s
state_path tmp_dir.join('puma.state').to_s

bind "unix://#{tmp_dir}/puma.sock"

stdout_redirect "#{logs_dir}/stdout.log", "#{logs_dir}/stderr.log", true
