require 'pronto'
require 'eslintrb'

module Pronto
  class ESLint < Runner
    CONFIG_FILE = '.pronto_eslint.yml'.freeze

    def run
      return [] unless @patches

      @patches.select { |patch| patch.additions > 0 }
        .select { |patch| file_to_lint?(patch.new_file_full_path) }
        .map { |patch| inspect(patch) }
        .flatten.compact
    end

    def file_to_lint?(path)
      files_to_lint =~ path.to_s
    end

    def files_to_lint
      @files_to_lint ||= Regexp.new(
        config['files_to_lint'] || /(\.jsx?|\.es6)$/
      )
    end

    def config
      @config ||= begin
        config_file = File.join(repo_path, CONFIG_FILE)
        return {} unless File.exist?(config_file)
        YAML.load_file(config_file)
      end
    end

    def inspect(patch)
      offences = Eslintrb.lint(patch.new_file_full_path, options).compact

      offences.map do |offence|
        patch.added_lines.select { |line| line.new_lineno == offence['line'] }
          .map { |line| new_message(offence, line) }
      end
    end

    def options
      @options ||= File.exist?('.eslintrc') ? :eslintrc : :defaults
    end

    def new_message(offence, line)
      path = line.patch.delta.new_file[:path]
      level = :warning

      Message.new(path, line, level, offence['message'], nil, self.class)
    end
  end
end
