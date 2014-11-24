require 'spec_helper'

describe Video do

  it { should belong_to(:category) }
  it { should have_many(:reviews).order('created_at DESC') }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "#search_by_title" do
    let(:interstellar) { Fabricate(:video, title: "Interstellar", created_at: 1.day.ago) }
    
    it { expect(Video.search_by_title("")).to             eq [] }
    it { expect(Video.search_by_title("no-match")).to     eq [] }
    it { expect(Video.search_by_title("Interstellar")).to eq [interstellar] }
    it { expect(Video.search_by_title("Inter")).to        eq [interstellar] }

    it "returns an array of multiple videos per pattern" do
      stellarium = Fabricate(:video, title: "stellarium")
      expect(Video.search_by_title("stella")).to eq([stellarium, interstellar])
    end
  end
end