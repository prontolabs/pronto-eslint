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
            element.commit_sha.should ==
              '931004157205727e6a47586feaed0473c6ddbd66'
          end
        end
      end

      context 'patches with a four and a five warnings' do
        include_context 'test repo'

        let(:patches) { repo.diff('master') }

        its(:count) { should == 9 }
        its(:'first.msg') { should == "curly: Expected { after 'if' condition." }
        its(:'first.commit_sha') { should == "3a6237c5feacca9a37c36bec5110a1eeb9da703b" }
      end
    end
  end
end
