require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:empty_task) { build(:empty_task) }
  let(:dupulicate_task) { build(:dupulicate_task) }

  # 空の場合無効
  context 'empty params' do
    it 'invalid without a title' do
      empty_task.valid?
      expect(empty_task.errors[:title]).to include("can't be blank")
    end

    it 'invalid without a status' do
      empty_task.valid?
      expect(empty_task.errors[:title]).to include("can't be blank")
    end
  end

  # 重複する場合無効
  context 'dupulicate params' do
    let!(:task) { create(:task) }
    it 'invalid with a duplicate title' do
      expect(dupulicate_task.valid?).to eq(false)
    end
  end
end
