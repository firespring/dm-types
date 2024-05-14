# encoding: utf-8

require_relative '../spec_helper'

try_spec do

  require_relative '../fixtures/article'

  describe DataMapper::TypesFixtures::Article do
    supported_by :all do
      describe "persisted with title and slug set to 'New DataMapper Type'" do
        before :all do
          @input    = 'New DataMapper Type'
          @resource = DataMapper::TypesFixtures::Article.create(:title => @input, :slug => @input)

          @resource.reload
        end

        it 'has slug equal to "new-datamapper-type"' do
          expect(@resource.slug).to eq 'new-datamapper-type'
        end

        it 'can be found by slug' do
          expect(DataMapper::TypesFixtures::Article.first(:slug => 'new-datamapper-type')).to eq @resource
        end
      end

      # FIXME: when stringex fixes the problems it has with it's YAML
      # files not being parsable by psych remove this conditional.
      unless RUBY_PLATFORM =~ /java/ && JRUBY_VERSION >= '1.6' && RUBY_VERSION >= '1.9.2'
        [
          [ 'Iñtërnâtiônàlizætiøn',                                           'internationalizaetion'                                                 ],
          [ "This is Dan's Blog",                                             'this-is-dans-blog'                                                     ],
          [ 'This is My Site, and Blog',                                      'this-is-my-site-and-blog'                                              ],
          [ 'Google searches for holy grail of Python performance',           'google-searches-for-holy-grail-of-python-performance'                  ],
          [ 'iPhone dev: Creating length-controlled data sources',            'iphone-dev-creating-length-controlled-data-sources'                    ],
          [ "Review: Nintendo's New DSi -- A Quantum Leap Forward",           'review-nintendos-new-dsi-a-quantum-leap-forward'                       ],
          [ "Arriva BraiVe, è l'auto-robot che si 'guida' da sola'",          'arriva-braive-e-lauto-robot-che-si-guida-da-sola'                      ],
          [ "La ley antipiratería reduce un 33% el tráfico online en Suecia", 'la-ley-antipirateria-reduce-un-33-percent-el-trafico-online-en-suecia' ],
          [ "L'Etat américain du Texas s'apprête à interdire Windows Vista",  'letat-americain-du-texas-sapprete-a-interdire-windows-vista'           ],
        ].each do |title, slug|
          describe "set with title '#{title}'" do
            before :all do
              @resource = DataMapper::TypesFixtures::Article.new(:title => title)
              expect(@resource.valid?).to be(true)
            end

            it "has slug equal to '#{slug}'" do
              expect(@resource.slug).to eq slug
            end

            describe "and persisted" do
              before :all do
                expect(@resource.save).to be(true)
                @resource.reload
              end

              it 'can be found by slug' do
                expect(DataMapper::TypesFixtures::Article.first(:slug => slug)).to eq @resource
              end
            end
          end
        end
      end
    end
  end
end
