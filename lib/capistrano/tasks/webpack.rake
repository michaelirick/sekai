namespace :webpack do
  task :build do
    on roles(:app) do
      within release_path do
        # https://github.com/capistrano/sshkit#the-command-map
        with path: "#{release_path}/bin:$PATH" do
          execute :webpack
        end
      end
    end
  end
end

