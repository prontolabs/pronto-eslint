require 'spec_helper'

module Pronto
  describe ESLint do
    let(:eslint) { ESLint.new(patches) }

    describe '#run' do
      subject { eslint.run }

      context 'patches are nil' do
        let(:patches) { nil }
        it { should == [] }
      end

      context 'no patches' do
        let(:patches) { [] }
        it { should == [] }
      end

      context 'invalid .eslintrc config' do
        include_context 'test repo'
        include_context 'eslintrc'

        let(:patches) { repo.diff('master') }

        its(:count) { should == 2 }

        it 'all messages are parsing errors' do
          subject.each do |element|
            element.msg.should ==
              'Parsing error: ecmaVersion must be 3, 5, 6, or 7.'
          end
        end
      end

      context 'patches with a four and a five warnings' do
        include_context 'test repo'

        let(:patches) { repo.diff('master') }

        its(:count) { should == 9 }
        its(:'first.msg') { should == "Expected { after 'if' condition." }
      end
    end
  end
end
