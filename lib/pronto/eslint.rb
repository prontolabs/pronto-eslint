require 'pronto'

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
      @_repo_path ||= @patches.first.repo.path

      offences =
        Dir.chdir(@_repo_path) do
          JSON.parse(`eslint #{patch.new_file_full_path} -f json`)
        end

      offences =
        offences
          .select { |offence| offence['errorCount'] > 0 || offence['warningCount'] > 0 } # no warning or error, no problem
          .map { |offence| offence['messages'] } # get error messages for that file
          .flatten
          .select { |offence| offence['line'] } # for now ignore errors without a line number

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
      %w(.js .es6 .js.es6).include?(File.extname(path))
    end
  end
end
