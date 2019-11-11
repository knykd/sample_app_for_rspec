FactoryBot.define do
  factory :user do
    email { 'test@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :dupulicate_user, class: User do
    email { 'test@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :other_user, class: User do
    email { 'other@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
