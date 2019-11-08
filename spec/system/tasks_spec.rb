require 'rails_helper'

RSpec.describe Task, type: :system do
  include LoginSupport

  describe '他のユーザでログイン' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:other_user) }
    let(:task_by_other_user) { create(:task_by_other_user, user_id: user.id) }
    before do
      login_as(other_user)
    end

    context 'タスク一覧ページにアクセス' do
      it '編集・削除が表示されない' do
        task_by_other_user
        visit tasks_path

        expect(current_path).to eq tasks_path
        expect(page).to have_no_link "Edit"
        expect(page).to have_no_link "Destroy"
      end
    end
  end

  describe 'ログイン後' do
    let!(:user) { create(:user) }
    let(:task_by_logined_user) { create(:task_by_logined_user, user_id: user.id) }
    let(:dupulicate_task) { build(:dupulicate_task) }
    before do
      login_as(user)
    end

    describe 'タスク編集' do
      context '入力値が正常' do
        it 'タスクの編集ができる' do
          task_by_logined_user
          visit tasks_path
          expect(current_path).to eq tasks_path

          click_link "Edit"
          expect(current_path).to eq edit_task_path(user.tasks.ids)

          fill_in "Title", with: "user title"
          fill_in "Content", with: "user content"
          select "todo", from: "task_status"
          fill_in "task_deadline", with: "1999-12-31T23:59:60Z"
          click_button "Update Task"
          expect(page).to have_content "Task was successfully updated."
          expect(current_path).to eq task_path(user.tasks.ids)
        end
      end

      context 'タイトルが未入力時に' do
        it 'タスクの編集が失敗する' do
          task_by_logined_user
          visit tasks_path
          expect(current_path).to eq tasks_path

          click_link "Edit"
          expect(current_path).to eq edit_task_path(user.tasks.ids)

          fill_in "Title", with: ""
          fill_in "Content", with: "user content"
          select "todo", from: "task_status"
          fill_in "task_deadline", with: "1999-12-31T23:59:60Z"
          click_button "Update Task"
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq task_path(user.tasks.ids)
        end
      end

      context '登録済のタイトルを使用' do
        let!(:task) { create(:task) }
        it 'タスクの編集が失敗' do
          task_by_logined_user
          visit tasks_path
          expect(current_path).to eq tasks_path

          click_link "Edit"
          expect(current_path).to eq edit_task_path(user.tasks.ids)

          fill_in "Title", with: "test"
          fill_in "Content", with: "user content"
          select "todo", from: "task_status"
          fill_in "task_deadline", with: "1999-12-31T23:59:60Z"
          click_button "Update Task"
          dupulicate_task.valid?
          expect(dupulicate_task.errors[:title]).to include('has already been taken')
          expect(current_path).to eq task_path(user.tasks.ids)
        end
      end
    end

    context 'タスクの削除' do
      it 'タスクの削除が成功する' do
        task_by_logined_user
        visit tasks_path
        expect(current_path).to eq tasks_path
        click_link "Destroy"

        expect {
          page.accept_confirm "Are you sure?"
          expect(page).to have_content "Task was successfully destroyed."
        }.to change{ Task.count }.by(-1)
      end
    end
  end
end
