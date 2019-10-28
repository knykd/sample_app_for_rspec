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
end
