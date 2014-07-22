require 'spec_helper'

describe PunchingBag do
  let(:article) { Article.create title: 'Hector', content: 'Ding, ding ding... ding. Ding. DING. DING! ' }
  let(:human_request) { OpenStruct.new(bot?: false) }
  let(:bot_request) { OpenStruct.new(bot?: true) }

  subject { PunchingBag }

  describe '.punch' do
    it 'does nothing when the request is from a bot' do
      expect(PunchingBag.punch(article, bot_request)).to be false
    end

    it 'creates a new punch when the request is valid' do
      expect { PunchingBag.punch(article, human_request) }.to change { Punch.count }.by 1
    end

    it 'creates a new punch when there is no request' do
      expect { PunchingBag.punch(article) }.to change { Punch.count }.by 1
    end
  end

  describe '.average_time' do
    let(:time) { Time.zone.now.beginning_of_day }
    let(:punch_1) { Punch.new(average_time: time + 15.seconds, hits: 2) }
    let(:punch_2) { Punch.new(average_time: time + 30.seconds, hits: 4) }

    it 'finds an average time for multiple punches' do
      expect(PunchingBag.average_time(punch_1, punch_2)).to eql (time + 25.seconds)
    end
  end
end
