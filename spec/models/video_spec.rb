require 'spec_helper'

describe Video do

  it { should belong_to(:category) }
  it { should have_many(:reviews).order('created_at DESC') }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:video_url) }

  describe ".search_by_title" do
    let(:interstellar) do
      Fabricate(:video, title: "Interstellar", created_at: 1.day.ago)
    end

    it { expect(Video.search_by_title("")).to eq [] }
    it { expect(Video.search_by_title("no-match")).to eq [] }
    it { expect(Video.search_by_title("Interstellar")).to eq [interstellar] }
    it { expect(Video.search_by_title("Inter")).to eq [interstellar] }

    it "returns an array of multiple videos per pattern" do
      stellarium = Fabricate(:video, title: "stellarium")
      expect(Video.search_by_title("stella")).to eq([stellarium, interstellar])
    end
  end

  describe "#average_rating" do
    let(:video) { Fabricate(:video) }

    it "returns float rating as review if 1 review" do
      review = Fabricate(:review, video: video)
      expect(video.reload.average_rating).to eq(review.rating.to_f)
    end

    it "returns average rating from all review ratings" do
      Fabricate(:review, video: video, rating: 2)
      Fabricate(:review, video: video, rating: 3)
      expect(video.reload.average_rating).to eq(2.5)
    end
  end

  describe ".search", :elasticsearch do
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end

    context "with title" do
      it "returns no results when no match" do
        Fabricate(:video, title: "Futurama")
        refresh_index

        expect(Video.search("whatever").records.to_a).to eq([])
      end

      it "returns an array of 1 video for title case insensitve match" do
        futurama = Fabricate(:video, title: "Futurama")
        south_park = Fabricate(:video, title: "South Park")
        refresh_index

        expect(Video.search("futurama").records.to_a).to eq([futurama])
      end

      it "returns an array of many videos for title match" do
        star_trek = Fabricate(:video, title: "Star Trek")
        star_wars = Fabricate(:video, title: "Star Wars")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_trek, star_wars]
      end
    end

    context "with title and description" do
      it "returns an array of many videos based for title and description match" do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "sun is a star")
        refresh_index

        expect(Video.search("star").records.to_a).to eq [star_wars, about_sun]
      end
    end

    context "with title, description and reviews" do
      it "returns an empty array for no match with an option" do
        star_wars = Fabricate(:video, title: "Star Wars")
        batman    = Fabricate(:video, title: "Batman")
        batman_review = Fabricate(:review, video: batman, body: "such a star movie!")
        refresh_index

        expect(Video.search("no_match", reviews: true).records.to_a).to eq([])
      end

      it "returns an array of many videos for title, description and reviews" do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "sun is a star!")
        batman    = Fabricate(:video, title: "Batman")
        batman_review = Fabricate(:review, video: batman, body: "such a star movie!")
        refresh_index

        expect(Video.search("star", reviews: true).records.to_a).to eq([star_wars, about_sun, batman])
      end
    end

    context "with average ratings" do
      let!(:star_wars) { Fabricate(:video, title: "Star Wars") }
      let!(:star_wars_review1) { Fabricate(:review, rating: "2", video: star_wars) }
      let!(:star_wars_review2) { Fabricate(:review, rating: "4", video: star_wars) }
      let!(:interstellar) { Fabricate(:video, title: "Interstellar") }
      let!(:interstellar_review1) { Fabricate(:review, rating: "4", video: interstellar) }
      let!(:alice) { Fabricate(:video, title: "Alice in Wonderland") }
      let!(:alice_review) { Fabricate(:review, rating: "2", video: alice) }

      before { refresh_index }

      context "with only rating_from selected" do
        it "returns an empty array when there are no matches" do
          expect(Video.search("", rating_from: "4.1").records.to_a).to eq []
        end

        it "returns an array of one video when there is one match" do
          expect(Video.search("", rating_from: "4.0").records.to_a).to eq [interstellar]
        end

        it "returns an array of many videos when there are multiple matches" do
          expect(Video.search("", rating_from: "3.0").records.to_a).to eq [interstellar, star_wars]
        end
      end

      context "with only rating_to selected" do
        it "returns an empty array when there are no matches" do
          expect(Video.search("", rating_to: "1.5").records.to_a).to eq []
        end

        it "returns an array of one video when there is one match" do
          expect(Video.search("", rating_to: "2.5").records.to_a).to eq [alice]
        end

        it "returns an array of many videos when there are multiple matches" do
          expect(Video.search("", rating_to: "3.4").records.to_a).to eq [star_wars, alice]
        end
      end

      context "with both rating_from and rating_to selected" do
        it "returns an empty array when there are no matches" do
          expect(Video.search("", rating_from: "3.4", rating_to: "3.9").records.to_a).to eq []
        end

        it "returns an array of one video when there is one match" do
          expect(Video.search("", rating_from: "1.8", rating_to: "2.2").records.to_a).to eq [alice]
        end

        it "returns an array of many videos when there are multiple matches" do
          expect(Video.search("", rating_from: "2.9", rating_to: "4.1").records.to_a).to eq [interstellar, star_wars]
        end

        it "returns an empty array when to is lower than from" do
          expect(Video.search("", rating_from: 5.0, rating_to: 1.0).records.to_a).to eq []
        end
      end

      it "returns an array of one video by title and an average rating option" do
        expect(Video.search("star", rating_from: "2.9", rating_to: "4.1").records.to_a).to eq [star_wars]
      end

      it "sorts videos based on returned average ratings in descending order" do
        expect(Video.search("", rating_from: "1.0", rating_to: "5.0").records.to_a).to eq [interstellar, star_wars, alice]
      end
    end

    context "multiple words must match" do
      it "returns an array of videos where 2 words match title" do
        star_wars1 = Fabricate(:video, title: "Star Wars: Episode I")
        star_wars2 = Fabricate(:video, title: "Star Wars: Episode II")
        bride_wars = Fabricate(:video, title: "Bride Wars")
        star_trek = Fabricate(:video, title: "Star Trek")
        refresh_index

        expect(Video.search("Star Wars").records.to_a).to eq [star_wars1, star_wars2]
      end
    end
  end
end
