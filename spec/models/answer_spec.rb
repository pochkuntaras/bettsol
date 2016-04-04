# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  question_id :integer          not null
#  content     :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  best        :boolean          default(FALSE), not null
#

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :content }

  describe 'best answer' do
    let(:question) { create :question }
    let(:answer) { create :answer, question: question }
    let(:best_answer) { create :answer, best: true, question: question }

    it 'should choose the answer as the best' do
      expect(answer.best).to eq false

      answer.choose_as_best
      answer.reload

      expect(answer.best).to eq true
    end

    it 'should choose old best answer as not the best answer' do
      expect(best_answer.best).to eq true
      expect(answer.best).to eq false

      answer.choose_as_best

      best_answer.reload
      answer.reload

      expect(best_answer.best).to eq false
      expect(answer.best).to eq true
    end
  end
end
