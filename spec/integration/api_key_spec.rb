require_relative '../spec_helper'

try_spec do
  require_relative '../fixtures/api_user'

  describe DataMapper::TypesFixtures::APIUser do
    supported_by :all do
      subject { described_class.new(:name => 'alice') }

      let(:original_api_key) { subject.api_key }

      it "has a default value" do
        expect(original_api_key).not_to be_nil
      end

      it "preserves the default value" do
        expect(subject.api_key).to eq original_api_key
      end

      it "generates unique API Keys for each resource" do
        other_resource = described_class.new(:name => 'eve')

        expect(other_resource.api_key).not_to eq original_api_key
      end
    end
  end
end
