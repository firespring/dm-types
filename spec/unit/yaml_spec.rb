require_relative '../spec_helper'
require_relative '../shared/identity_function_group'

try_spec do

  require_relative '../fixtures/person'

  describe DataMapper::Property::Yaml do
    before :all do
      @property = DataMapper::TypesFixtures::Person.properties[:inventions]
    end

    describe '.load' do
      describe 'when nil is provided' do
        it 'returns nil' do
          expect(@property.load(nil)).to be_nil
        end
      end

      describe 'when YAML encoded primitive string is provided' do
        it 'returns decoded value as Ruby string' do
          expect(@property.load("--- yaml string\n")).to eq 'yaml string'
        end
      end

      describe 'when something else is provided' do
        it 'raises ArgumentError with a meaningful message' do
          expect {
            @property.load(:sym)
          }.to raise_error(ArgumentError, '+value+ of a property of YAML type must be nil or a String')
        end
      end
    end

    describe '.dump' do
      describe 'when nil is provided' do
        it 'returns nil' do
          expect(@property.dump(nil)).to be_nil
        end
      end

      describe 'when YAML encoded primitive string is provided' do
        it 'does not do double encoding' do
          expect(YAML.safe_load(@property.dump("--- yaml encoded string\n"))).to eq 'yaml encoded string'
        end
      end

      describe 'when regular Ruby string is provided' do
        it 'dumps argument to YAML' do
          expect(YAML.safe_load(@property.dump('dump me (to yaml)'))).to eq 'dump me (to yaml)'
        end
      end

      describe 'when Ruby array is provided' do
        it 'dumps argument to YAML' do
          expect(YAML.safe_load(@property.dump([ 1, 2, 3 ]))).to eq [ 1, 2, 3 ]
        end
      end

      describe 'when Ruby hash is provided' do
        it 'dumps argument to YAML' do
          expect(YAML.safe_load(@property.dump('datamapper' => 'Data access layer in Ruby'))).to eq({ 'datamapper' => 'Data access layer in Ruby' })
        end
      end
    end

    describe '.typecast' do
      class ::SerializeMe
        attr_accessor :name
      end

      describe 'given a number' do
        before :all do
          @input  = 15
          @result = 15
        end

        it_behaves_like 'identity function'
      end

      describe 'given an Array instance' do
        before :all do
          @input  = ['dm-core', 'dm-more']
          @result = ['dm-core', 'dm-more']
        end

        it_behaves_like 'identity function'
      end

      describe 'given a Hash instance' do
        before :all do
          @input  = { :format => 'yaml' }
          @result = { :format => 'yaml' }
        end

        it_behaves_like 'identity function'
      end

      describe 'given a plain old Ruby object' do
        before :all do
          @input      = SerializeMe.new
          @input.name = 'yamly'

          @result = @input
        end

        it_behaves_like 'identity function'
      end
    end
  end
end
