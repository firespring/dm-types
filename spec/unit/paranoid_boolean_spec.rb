require 'spec_helper'

describe DataMapper::Property::ParanoidBoolean do
  before :all do
    Object.send(:remove_const, :Blog) if defined?(Blog)

    module ::Blog
      class Draft
        include DataMapper::Resource

        property :id,      Serial
        property :deleted, ParanoidBoolean

        before :destroy, :before_destroy

        def before_destroy; end
      end

      class Article < Draft; end

      class Review < Article; end
    end

    @model = Blog::Article
  end

  supported_by :all do
    describe 'Resource#destroy' do
      subject { @resource.destroy }

      describe 'with a new resource' do
        before do
          @resource = @model.new
        end

        it { is_expected.to be(false) }

        it 'does not delete the resource from the datastore' do
          expect { method(:subject) }.not_to change { @model.with_deleted.size }.from(0)
        end

        it 'does not set the paranoid column' do
          expect { method(:subject) }.not_to change { @resource.deleted }.from(false)
        end

        it 'runs the destroy hook' do
          expect(@resource).to receive(:before_destroy).with(no_args)
          subject
        end
      end

      describe 'with a saved resource' do
        before do
          @resource = @model.create
        end

        it { is_expected.to be(true) }

        it 'does not delete the resource from the datastore' do
          expect { method(:subject) }.not_to change { @model.with_deleted.size }.from(1)
        end

        it 'sets the paranoid column' do
          expect { method(:subject) }.to change { @resource.deleted }.from(false).to(true)
        end

        it 'runs the destroy hook' do
          expect(@resource).to receive(:before_destroy).with(no_args)
          subject
        end
      end
    end

    describe 'Resource#destroy!' do
      subject { @resource.destroy! }

      describe 'with a new resource' do
        before do
          @resource = @model.new
        end

        it { is_expected.to be(false) }

        it 'does not delete the resource from the datastore' do
          expect { method(:subject) }.not_to change { @model.with_deleted.size }.from(0)
        end

        it 'does not set the paranoid column' do
          expect { method(:subject) }.not_to change { @resource.deleted }.from(false)
        end

        it 'does not run the destroy hook' do
          expect(@resource).not_to receive(:before_destroy).with(no_args)
          subject
        end
      end

      describe 'with a saved resource' do
        before do
          @resource = @model.create
        end

        it { is_expected.to be(true) }

        it 'deletes the resource from the datastore' do
          expect { method(:subject) }.to change { @model.with_deleted.size }.from(1).to(0)
        end

        it 'does not set the paranoid column' do
          expect { method(:subject) }.not_to change { @resource.deleted }.from(false)
        end

        it 'does not run the destroy hook' do
          expect(@resource).not_to receive(:before_destroy).with(no_args)
          subject
        end
      end
    end

    describe 'Model#with_deleted' do
      before do
        @resource = @model.create
        @resource.destroy
      end

      describe 'with a block' do
        subject { @model.with_deleted { @model.all } }

        it 'scopes the block to return all resources' do
          expect(subject.map(&:key)).to eq [ @resource.key ]
        end
      end

      describe 'without a block' do
        subject { @model.with_deleted }

        it 'returns a collection scoped to return all resources' do
          expect(subject.map(&:key)).to eq [ @resource.key ]
        end
      end
    end

    describe 'Model.inherited' do
      it 'sets @paranoid_properties' do
        expect(::Blog::Review.instance_variable_get(:@paranoid_properties)).to eq ::Blog::Article.instance_variable_get(:@paranoid_properties)
      end
    end
  end
end
