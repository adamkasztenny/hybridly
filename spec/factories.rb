FactoryBot.define do
  factory :user do
    email { "hybridly@example.com" }
  end

  factory :admin_user, class: "User" do
    email { "hybridly-admin@example.com" }

    after(:create) do |user|
      user.add_role(:admin)
    end
  end
end
