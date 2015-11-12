require 'spec_helper'

describe PunchingBag do
  let(:article) { Article.create title: 'Hector', content: 'Ding, ding ding... ding. Ding. DING. DING! ' }

  subject { PunchingBag }

  describe '.punch' do
    let(:request) { nil }

    context 'when request is from a bot' do
      let(:request) { instance_double(ActionDispatch::Request, bot?: true) }

      it 'does nothing' do
        expect(PunchingBag.punch(article, request)).to be false
      end
    end

    context 'when the request is valid' do
      let(:request) { instance_double(ActionDispatch::Request, bot?: false) }

      it 'creates a new punch' do
        expect { PunchingBag.punch(article, request) }.to change { Punch.count }.by 1
      end
    end

    context 'when there is no request' do
      it 'creates a new punch' do
        expect { PunchingBag.punch(article) }.to change { Punch.count }.by 1
      end
    end

    context 'when count is more than one' do
      it 'creates a new punch with a higher count' do
        expect { PunchingBag.punch(article, nil, 2) }.to change { Punch.sum(:hits) }.by 2
      end
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
