require 'spec_helper'

describe Article do
  let(:article_1) { Article.create title: 'Bacon', content: 'Bacon ipsum dolor sit amet turkey short ribs tri-tip' }
  let(:article_2) { Article.create title: 'Hipsters', content: 'American Apparel aute Banksy officia ugh.' }
  let(:article_3) { Article.create title: 'Lebowski', content: 'Lebowski ipsum over the line! Dolor sit amet, consectetur adipiscing elit praesent ac.' }

  # Instance methods
  describe 'Article' do
    subject { article_1 }

    describe '#hits' do
      context 'with no hits' do
        its(:hits) { should eql 0 }
      end

      context 'with one hit' do
        before { subject.punch }
        its(:hits) { should eql 1 }
      end
    end

    describe '#punch' do
      it 'incleases hits by one' do
        expect { subject.punch }.to change { subject.hits }.by 1
      end

      context 'when count is set to two' do
        it 'increases hits by two' do
          expect { subject.punch(nil, count: 2) }.to change { subject.hits }.by 2
        end
      end
    end
  end

  # Class methods
  describe 'Article' do
    subject { Article }

    before do
      2.times { article_3.punch }
      article_1.punch
    end

    describe '.most_hit' do
      its(:most_hit) { should include article_3 }
      its(:most_hit) { should include article_1 }
      its(:most_hit) { should_not include article_2 }

      its('most_hit.first') { should eql article_3 }
      its('most_hit.second') { should eql article_1 }
    end

    describe '.sort_by_popularity' do
      its(:sort_by_popularity) { should include article_1 }
      its(:sort_by_popularity) { should include article_2 }
      its(:sort_by_popularity) { should include article_3 }

      its('sort_by_popularity.first') { should eql article_3 }
      its('sort_by_popularity.second') { should eql article_1 }
    end
  end
end
