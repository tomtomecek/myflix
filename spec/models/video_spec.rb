require 'spec_helper'

describe Video do

  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "#self.search_by_title" do

    it "returns an empty array if no match" do
      Video.create(title: "Interstellar", description: "a big step for humans")
      expect(Video.search_by_title("Inception")).to eq([])
    end

    it "returns an array of 1 exact match" do
      interstellar = Video.create(title: "Interstellar", description: "a big step for humans")
      expect(Video.search_by_title("Interstellar")).to eq([interstellar])
    end

    it "returns an array of 1 pattern match" do
      interstellar = Video.create(title: "Interstellar", description: "a big step for humans")
      expect(Video.search_by_title("Inter")).to eq([interstellar])
    end

    it "returns an array of multiple videos per pattern" do
      interstellar = Video.create(title: "Interstellar", description: "a big step for humans")
      stellarium = Video.create(title: "stellarium", description: "will be released in 2016")
      expect(Video.search_by_title("stella")).to eq([interstellar, stellarium])
    end

    it "returns an empty array if no search" do
      Video.create(title: "Interstellar", description: "a big step for humans")
      expect(Video.search_by_title("")).to eq([])
    end

  end


end