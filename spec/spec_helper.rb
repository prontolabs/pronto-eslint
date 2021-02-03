require 'rspec'
require 'rspec/its'
require 'pronto/eslint'

RSpec.shared_context 'test repo' do
  let(:git) { 'spec/fixtures/test.git/git' }
  let(:dot_git) { 'spec/fixtures/test.git/.git' }

  before { FileUtils.mv(git, dot_git) }
  let(:repo) { Pronto::Git::Repository.new('spec/fixtures/test.git') }
  after { FileUtils.mv(dot_git, git) }
end

RSpec.shared_context 'eslintrc' do
  let(:eslintrc) { 'spec/fixtures/eslintrc8' }
  let(:dot_eslintrc) { '.eslintrc' }

  before { FileUtils.mv(eslintrc, dot_eslintrc) }
  after { FileUtils.mv(dot_eslintrc, eslintrc) }
end

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :should }
  config.mock_with(:rspec) { |c| c.syntax = :should }
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
