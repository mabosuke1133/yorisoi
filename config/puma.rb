# スレッドの設定
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# ポート番号（3000番）
port ENV.fetch("PORT") { 3000 }

# 環境設定（デフォルトはproduction）
environment ENV.fetch("RAILS_ENV") { "production" }

# PIDファイルの場所（フルパスまたは相対パス）
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# 💡 ここが修正のポイント！
# Rails.root ではなく、実行時のディレクトリ（Dir.pwd）を使います
app_dir = Dir.pwd

# 本番環境用のログ出力設定
# puma.service（systemd）で管理する場合、daemonize は「false」にするのが鉄則です！
if ENV.fetch("RAILS_ENV") == "production"
  stdout_redirect "#{app_dir}/log/puma.log", "#{app_dir}/log/puma-error.log", true
end

# 再起動プラグイン
plugin :tmp_restart