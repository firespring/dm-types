shared_examples 'A property with flags' do
  before :all do
    %w(@property_klass).each do |ivar|
      raise "+#{ivar}+ should be defined in before block" unless instance_variable_defined?(ivar)
    end

    @flags = %i(one two three)

    class ::User
      include DataMapper::Resource
    end

    @property = User.property :item, @property_klass[@flags], key: true
  end

  describe '.generated_classes' do
    it 'caches the generated class' do
      expect(@property_klass.generated_classes[@flags]).not_to be_nil
    end
  end

  it 'includes :flags in accepted_options' do
    expect(@property_klass.accepted_options).to include(:flags)
  end

  it 'responds to :generated_classes' do
    expect(@property_klass).to respond_to(:generated_classes)
  end

  it 'responds to :flag_map' do
    expect(@property).to respond_to(:flag_map)
  end

  it 'is custom' do
    expect(@property.custom?).to be(true)
  end
end
