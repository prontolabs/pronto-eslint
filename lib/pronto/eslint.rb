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

      fatals = offences.select do |offence|
        offence['fatal']
      end
      .map do |offence|
        new_message(offence, nil)
      end

      return fatals if fatals && fatals.length > 0

      offences.map do |offence|
        patch.added_lines.select { |line| line.new_lineno == offence['line'] }
          .map { |line| new_message(offence, line) }
      end
    end

    def new_message(offence, line)
      path = line ? line.patch.delta.new_file[:path] : '.eslintrc'
      level = line ? :warning : :fatal

      Message.new(path, line, level, offence['message'], nil, self.class)
    end

    def js_file?(path)
      %w(.js .es6 .js.es6).include? File.extname(path)
    end
  end
end
