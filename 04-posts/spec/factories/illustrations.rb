FactoryGirl.define do
  factory :illustration do
    image { Rack::Test::UploadedFile.new('spec/support/images/placeholder.png', 'image/png') }
  end
end
