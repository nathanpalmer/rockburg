require 'rails_helper'

RSpec.describe Activity::WriteSong, type: :service do
  let(:member1) { create(:member, primary_skill: Skill.find_by_name('Keyboards')) }
  let(:member2) { create(:member, primary_skill: Skill.find_by_name('Drummer')) }
  let(:genre) { Genre.find_by_style('Drum & Bass') }
  let(:band) { create :band, genre: genre }

  before do
    band.add_member(member1, skill: member1.primary_skill)
    band.add_member(member2, skill: member2.primary_skill)
  end

  it 'should write a song' do
    expect {
      Sidekiq::Testing.inline! do
        result = described_class.call(band: band, hours: 1)
        expect(result.success?).to eq(true)
        expect(result.activity).to be_present
      end
    }.to change{ band.songs.count }.by(1)
  end
end
