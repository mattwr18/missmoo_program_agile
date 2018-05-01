FactoryBot.define do
  factory :sale do
    amount 10
    description "FactoryBot Sale"
  end

  factory :second_sale, class: "Sale" do
    amount 11
    description "FactoryBot second sale"
  end
end
