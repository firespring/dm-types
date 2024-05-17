require_relative '../spec_helper'

try_spec do

  require_relative '../fixtures/person'

  describe DataMapper::TypesFixtures::Person do
    supported_by :all do
      before :all do
        @resource = DataMapper::TypesFixtures::Person.new(:name => 'Thomas Edison')
      end

      describe 'with no positions information' do
        before :all do
          @resource.positions = nil
        end

        describe 'when dumped and loaded again' do
          before :all do
            expect(@resource.save).to be(true)
            @resource.reload
          end

          it 'has nil positions list' do
            expect(@resource.positions).to be_nil
          end
        end
      end

      describe 'with a few items on the positions list' do
        before :all do
          @resource.positions = [
            { :company => 'The Death Star, Inc', :title => 'Light sabre engineer'    },
            { :company => 'Sane Little Company', :title => 'Chief Curiosity Officer' },
          ]
        end

        describe 'when dumped and loaded again' do
          before :all do
            expect(@resource.save).to be(true)
            @resource.reload
          end

          it 'loads positions list to the state when it was dumped/persisted with keys being strings' do
            expect(@resource.positions).to eq [
              { 'company' => 'The Death Star, Inc',  'title' => 'Light sabre engineer'    },
              { 'company'  => 'Sane Little Company', 'title' => 'Chief Curiosity Officer' },
            ]
          end
        end
      end

      describe 'with positions information given as empty list' do
        before :all do
          @resource.positions = []
        end

        describe 'when dumped and loaded again' do
          before :all do
            expect(@resource.save).to be(true)
            @resource.reload
          end

          it 'has empty positions list' do
            expect(@resource.positions).to eq []
          end
        end
      end

    end
  end
end
