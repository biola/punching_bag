require 'spec_helper'

describe PunchingBag::ActiveRecord::ClassMethods do

  let(:request) { instance_double(ActionDispatch::Request, bot?: false) }

  let(:article1) { Article.create title: 'Article 1', content: 'Ding, ding ding... ding. Ding. DING. DING! ' }
  let(:article2) { Article.create title: 'Article 2', content: 'Ding, ding ding... ding. Ding. DING. DING! ' }

  describe '.most_hit' do
    it 'finds correct result' do
      PunchingBag.punch(article1, request)
      PunchingBag.punch(article2, request)
      PunchingBag.punch(article2, request)
      expect(Article.most_hit).to include(article2)
    end
  end

end
