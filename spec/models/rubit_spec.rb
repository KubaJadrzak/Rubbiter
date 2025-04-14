require 'rails_helper'

RSpec.describe Rubit, type: :model do
  let(:user) { User.create(email: 'test@example.com', password: 'password') }

  it "is valid with valid attributes" do
    rubit = Rubit.new(content: "Hello #rails", user: user)
    expect(rubit).to be_valid
  end

  it "is not valid without content" do
    rubit = Rubit.new(content: nil, user: user)
    expect(rubit).not_to be_valid
  end

  it "is not valid if content is too long" do
    rubit = Rubit.new(content: "a" * 205, user: user)
    expect(rubit).not_to be_valid
  end

  it "is valid as child rubit" do
    rubit = Rubit.create(content: "Parent Rubit", user: user)
    child_rubit = Rubit.create(content: "Child Rubit", user: user, parent_rubit: rubit)
  end

  it "creates hashtags after save" do
    rubit = Rubit.create(content: "Testing #RSpec #rails", user: user)
    expect(rubit.hashtags.map(&:name)).to include("rspec", "rails")
  end
  
end
