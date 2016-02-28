require 'spec_helper'

module Pronto
  describe ESLint do
    let(:eslint) { ESLint.new }

    describe '#run' do
      subject { eslint.run(patches, nil) }

      context 'patches are nil' do
        let(:patches) { nil }
        it { should == [] }
      end

      context 'no patches' do
        let(:patches) { [] }
        it { should == [] }
      end

      context 'patches with a four warnings' do
        include_context 'test repo'

        let(:patches) { repo.diff('master') }

        its(:count) { should == 4 }
        its(:'first.msg') { should == "Expected { after 'if' condition." }
      end
    end
  end
end
