require 'rails_helper'

RSpec.describe Task, type: :model do
  let!(:task) { FactoryBot.create(:task) }
  let(:empty_task) { FactoryBot.build(:empty_task) }
  let(:same_task) { FactoryBot.build(:same_task) }

  # 空の場合無効
  context 'empty params' do
    it 'invalid without a title' do
      expect(empty_task.valid?).to eq(false)
    end

    it 'invalid without a status' do
      expect(empty_task.valid?).to eq(false)
    end
  end

  # 重複する場合無効
  context 'same params' do
    it 'invalid with a duplicate title' do
      expect(same_task.valid?).to eq(false)
    end
  end
end
