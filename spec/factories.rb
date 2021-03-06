FactoryBot.define do
  factory :workspace do
    location { "Engineering" }
    workspace_type { :desks }
    capacity { 1 }
    user { association :admin_user }
  end

  factory :user do
    email { "hybridly@example.com" }
  end

  factory :admin_user, class: "User" do
    email { "hybridly-admin@example.com" }

    after(:create) do |user|
      user.add_role(:admin)
    end
  end

  factory :reservation do
    date { Date.parse('2022-01-01') }
    verification_code { SecureRandom.uuid }

    user
  end

  factory :reservation_policy do
    capacity { 1 }

    user { association :admin_user }
  end
end
