require 'rspec'
require 'rspec/its'
require 'pronto/eslint'

%w(test eslintignore).each do |repo_name|
  RSpec.shared_context "#{repo_name} repo" do
    let(:git) { "spec/fixtures/#{repo_name}.git/git" }
    let(:dot_git) { "spec/fixtures/#{repo_name}.git/.git" }

    before { FileUtils.mv(git, dot_git) }
    let(:repo) { Pronto::Git::Repository.new("spec/fixtures/#{repo_name}.git") }
    after { FileUtils.mv(dot_git, git) }
  end
end

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :should }
  config.mock_with(:rspec) { |c| c.syntax = :should }
end
