require 'rails_helper'

RSpec.describe User, type: :system do
  include LoginSupport
  let(:dupulicate_user) { build(:dupulicate_user) }

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context '入力値が正常' do
        it 'ユーザーの新規作成ができる' do
          visit sign_up_path
          expect {
            fill_in "Email", with: "test@example.com"
            fill_in "Password", with: "password"
            fill_in "Password confirmation", with: "password"
            click_button "SignUp"
          }.to change(User, :count).by(1)
          expect(current_path).to eq login_path
          expect(page).to have_content "User was successfully created."
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit sign_up_path
          fill_in "Email", with: ""
          fill_in "Password", with: "password"
          fill_in "Password confirmation", with: "password"
          click_button "SignUp"
          expect(page).to have_content "Email can't be blank"
          expect(current_path).to eq users_path
        end
      end

      context '登録済メールアドレスを使用' do
        let!(:user) { create(:user) }
        it 'ユーザーの新規作成が失敗する' do
          visit sign_up_path
          fill_in "Email", with: dupulicate_user.email
          fill_in "Password", with: "password"
          fill_in "Password confirmation", with: "password"
          click_button "SignUp"
          dupulicate_user.valid?
          expect(dupulicate_user.errors[:email]).to include('has already been taken')
          expect(current_path).to eq users_path
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        let!(:user) { create(:user) }
        it 'マイページへのアクセスが失敗する' do
          visit user_path(user)
          expect(page).to have_content "Login required"
          expect(current_path).to eq login_path
        end
      end
    end
  end

  describe 'ログイン後' do
    let!(:user) { create(:user) }
    before do
      login_as(user)
    end

    describe 'ユーザー編集' do
      context '入力値が正常' do
        it 'ユーザーの編集ができる' do
          click_link "Mypage"
          expect(current_path).to eq user_path(user)
          
          visit edit_user_path(user)
          fill_in "Email", with: "update@example.com"
          fill_in "Password", with: "update"
          fill_in "Password confirmation", with: "update"
          click_button "Update"
          expect(user.reload.email).to eq "update@example.com"
          expect(current_path).to eq user_path(user)
          expect(page).to have_content "User was successfully updated."
        end
      end
    end

    context 'メールアドレスが未入力時に' do
      it 'ユーザーの編集が失敗する' do
          click_link "Mypage"
          expect(current_path).to eq user_path(user)
          
          visit edit_user_path(user)
          fill_in "Email", with: ""
          fill_in "Password", with: "update"
          fill_in "Password confirmation", with: "update"
          click_button "Update"
          expect(user.reload.email).to eq user.email
          expect(current_path).to eq user_path(user)
          expect(page).to have_content "Email can't be blank"
      end
    end

    context '登録済メールアドレスを使用' do
      it 'ユーザーの編集が失敗' do
        click_link "Mypage"
        expect(current_path).to eq user_path(user)

        visit edit_user_path(user)
        fill_in "Email", with: "test@example.com"
        fill_in "Password", with: "password"
        fill_in "Password confirmation", with: "password"
        click_button "Update"
        dupulicate_user.valid?
        expect(dupulicate_user.errors[:email]).to include('has already been taken')
      end
    end

    context '他ユーザーの編集ページにアクセス' do
      let!(:other_user) { create(:other_user) }
      it 'アクセスが失敗する' do
        visit edit_user_path(other_user)
        expect(current_path).to eq user_path(user)
        expect(page).to have_content "Forbidden access."
      end
    end

    describe 'マイページ' do
      let!(:task) { create(:task) }
      context 'タスクを作成' do
        it '新規作成したタスクが表示される' do
          click_link "New task"
          expect(current_path).to eq new_task_path

          fill_in "Title", with: "user title"
          fill_in "Content", with: "user content"
          select "todo", from: "task_status"
          fill_in "task_deadline", with: "1999-12-31T23:59:60Z"
          click_button "Create Task"
          expect(page).to have_content "Task was successfully created."
          expect(current_path).to eq task_path(user.tasks.ids)
        end
      end
    end
  end
end
