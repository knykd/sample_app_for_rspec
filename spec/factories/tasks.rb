FactoryBot.define do
  factory :task do
    title { 'test' }
    status { 'todo' }
  end

  factory :empty_task, class: Task do
    title { '' }
    status { '' }
  end

  factory :same_task, class: Task do
    title { 'test' }
    status { 'done' }
  end
end
