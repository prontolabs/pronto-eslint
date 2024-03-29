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
      offences = Eslintrb.lint(patch.new_file_full_path, options).compact

      fatals = offences.select { |offence| offence['fatal'] }
        .map { |offence| new_message(offence, nil) }

      return fatals if fatals && !fatals.empty?

      offences.map do |offence|
        patch.added_lines.select { |line| line.new_lineno == offence['line'] }
          .map { |line| new_message(offence, line) }
      end
    end

    def options
      if ENV['ESLINT_CONFIG']
        JSON.parse(IO.read(ENV['ESLINT_CONFIG']))
      else
        File.exist?('.eslintrc') ? :eslintrc : :defaults
      end
    end

    def new_message(offence, line)
      path = line ? line.patch.delta.new_file[:path] : '.eslintrc'
      level = line ? :warning : :fatal
      message = offence['message']
      message = "#{offence['ruleId']}: #{message}" if offence['ruleId']

      Message.new(path, line, level, message, nil, self.class)
    end

    def js_file?(path)
      %w[.js .es6 .js.es6 .jsx].include?(File.extname(path))
    end
  end
end
