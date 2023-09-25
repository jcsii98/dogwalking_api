require 'rails_helper'

RSpec.describe DogProfile, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = FactoryBot.create(:user)
      dog_profile = described_class.new(
        user: user,
        name: "Buddy",
        age: 3,
        weight: 30
      )
      expect(dog_profile).to be_valid
    end

    it "is not valid without a name" do
      dog_profile = described_class.new(name: nil)
      expect(dog_profile).not_to be_valid
      expect(dog_profile.errors[:name]).to include("can't be blank")
    end

    it "is not valid with a non-integer age" do
      dog_profile = described_class.new(age: 2.5)
      expect(dog_profile).not_to be_valid
      expect(dog_profile.errors[:age]).to include("must be an integer")
    end

    it "is not valid with a non-integer weight" do
      dog_profile = described_class.new(weight: 25.5)
      expect(dog_profile).not_to be_valid
      expect(dog_profile.errors[:weight]).to include("must be an integer")
    end

    it "is not valid with a negative age" do
      dog_profile = described_class.new(age: -1)
      expect(dog_profile).not_to be_valid
      expect(dog_profile.errors[:age]).to include("must be greater than 0")
    end

    it "is not valid with a negative weight" do
      dog_profile = described_class.new(weight: -5)
      expect(dog_profile).not_to be_valid
      expect(dog_profile.errors[:weight]).to include("must be greater than 0")
    end
  end

  describe "associations" do
    it { should belong_to(:user) }
  end
end
