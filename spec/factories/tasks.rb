FactoryBot.define do
  factory :task do
    title { 'test' }
    status { :todo }
  end

  factory :empty_task, class: Task do
    title { '' }
    status { '' }
  end

  factory :dupulicate_task, class: Task do
    title { 'test' }
    status { :done }
  end

  factory :task_by_other_user, class: Task do
    title { 'task_by_other_user' }
    status { :done }
    user
  end

  factory :task_by_logined_user, class: Task do
    title { 'task_by_logined_user' }
    status { :done }
    user
  end
end
