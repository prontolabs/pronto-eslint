require 'pronto'
require 'eslintrb'
require 'globby'

module Pronto
  class ESLint < Runner
    def run
      return [] unless @patches

      @patches.select { |patch| patch.additions > 0 }
        .select { |patch| js_file?(patch.new_file_full_path) }
        .map { |patch| inspect(patch) }
        .flatten.compact
    end

    def inspect(patch)
      options = File.exist?('.eslintrc') ? :eslintrc : :defaults
      offences = Eslintrb.lint(patch.new_file_full_path, options).compact

      offences.map do |offence|
        patch.added_lines.select { |line| line.new_lineno == offence['line'] }
          .map { |line| new_message(offence, line) }
      end
    end

    def new_message(offence, line)
      path = line.patch.delta.new_file[:path]
      level = :warning

      Message.new(path, line, level, offence['message'], nil, self.class)
    end

    def js_file?(path)
      %w(.js .es6 .js.es6).include?(File.extname(path)) && !eslintignore_matches?(path)
    end

    def eslintignore_matches?(path)
      @_repo_path ||= @patches.first.repo.path
      @_eslintignore_path ||= File.join(@_repo_path, '.eslintignore')
      @_eslintignore_exists ||= File.exist?(@_eslintignore_path)

      return false unless @_eslintignore_exists

      @_eslintignored_files ||=
        Dir.chdir @_repo_path do # change to the repo path where `.eslintignore` was found
          eslintignore_content = File.readlines(@_eslintignore_path).map(&:chomp)
          ignored_files = Globby.select(eslintignore_content)

          # prefix each found file with `repo_path`, because `path` is absolute, too
          ignored_files.map { |file| File.join(@_repo_path, file).to_s }
        end

      @_eslintignored_files.include?(path.to_s)
    end
  end
end
