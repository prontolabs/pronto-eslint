require 'pronto'
require 'eslintrb'

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
      File.extname(path) == '.js'
    end
  end
end
