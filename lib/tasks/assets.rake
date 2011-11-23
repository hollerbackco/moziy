namespace :assets do
  desc "Compile all the assets named in config.assets.precompile and push them"
  task :compile do
    AssetsCompiler.new.compile
  end

  class AssetsCompiler
    def compile
      ensure_clean_git
      removed_previous_assets
      compile_assets
      commit_compiled_assets
      push
    end

    def ensure_clean_git
      raise "Can't deploy without a clean git status." if git_dirty?
    end

    def removed_previous_assets
      run "bundle exec rake RAILS_ENV=production assets:clean"
    end

    def compile_assets
      run "bundle exec rake RAILS_ENV=production assets:precompile"
    end

    def commit_compiled_assets
      run "git add -u && git add . && git commit -am 'Compiled assets'"
    end

    def push
      run "git push"
    end

    private

    def run(command)
      puts "+ Running: #{command}"
      puts "-- #{system command}"
    end

    def git_dirty?
      `[[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]]`
      dirty = $?.success?
    end
  end
end