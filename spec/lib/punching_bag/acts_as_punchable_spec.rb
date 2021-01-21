require 'spec_helper'

describe PunchingBag::ActiveRecord::ClassMethods do

  let(:request) { instance_double(ActionDispatch::Request, bot?: false) }

  let(:article1) { Article.create title: 'Article 1', content: 'Ding, ding ding... ding. Ding. DING. DING! ' }
  let(:article2) { Article.create title: 'Article 2', content: 'Ding, ding ding... ding. Ding. DING. DING! ' }
  let(:article3) { Article.create title: 'Article 3', content: 'This article has no hits' }

  before do
    PunchingBag.punch(article1, request)
    PunchingBag.punch(article2, request)
    PunchingBag.punch(article2, request)

    # Create article3 in database with no hits
    article3
  end

  describe '.most_hit' do
    it 'finds correct result' do
      expect(Article.most_hit).to include(article2)
    end
  end

  describe '.sort_by_popularity' do
    it 'sorts DESC' do
      expect(Article.sort_by_popularity('DESC')).to eq([article2, article1, article3])
    end
    it 'sorts ASC' do
      expect(Article.sort_by_popularity('ASC')).to eq([article3, article1, article2])
    end
  end

end
