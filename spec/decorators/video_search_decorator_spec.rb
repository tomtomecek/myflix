require 'spec_helper'

describe VideoSearchDecorator do
  describe "#title" do
    let(:normal_title_response) { OpenStruct.new("title" => "Family guy") }
    let(:highlighted_title_response) do
      OpenStruct.new(
        "title" => "Family guy",
        "highlight" => {
          "title" => ["<em class='label label-highlight'>Family</em> guy"]
        }
      )
    end

    it "returns normal title" do
      video_search = VideoSearchDecorator.new(normal_title_response)
      expect(video_search.title).to eq "Family guy"
    end

    it "returns highlighted title" do
      video_search = VideoSearchDecorator.new(highlighted_title_response)
      expect(video_search.title).to eq "<em class='label label-highlight'>Family</em> guy"
    end
  end

  describe "#description" do
    let(:normal_description_response) { OpenStruct.new("description" => "some nice description") }
    let(:highlighted_description_response) do
      OpenStruct.new(
        "description" => "some nice description",
        "highlight" => {
          "description" => ["some <em class='label label-highlight'>nice</em> description"]
        }
      )
    end

    it "returns normal description" do
      video_search = VideoSearchDecorator.new(normal_description_response)
      expect(video_search.description).to eq "some nice description"
    end

    it "returns highlighted description" do
      video_search = VideoSearchDecorator.new(highlighted_description_response)
      expect(video_search.description).to eq "some <em class='label label-highlight'>nice</em> description"
    end
  end

  describe "#average_rating" do
    let(:average_rating_response) { OpenStruct.new("average_rating" => 3) }

    it "returns average rating" do
      video_search = VideoSearchDecorator.new(average_rating_response)
      expect(video_search.average_rating).to eq 3
    end
  end

  describe "#small_cover_url" do
    let(:small_cover_url_response) do
      OpenStruct.new(
        "small_cover" => OpenStruct.new("url" => "/tmp/name.jpg")
      )
    end

    it "returns small cover url" do
      video_search = VideoSearchDecorator.new(small_cover_url_response)
      expect(video_search.small_cover_url).to eq "/tmp/name.jpg"
    end
  end

  describe "#reviews_count" do
    let(:reviews_response) do
      OpenStruct.new(
        "reviews" => [
          OpenStruct.new("body" => "review 1"),
          OpenStruct.new("body" => "review 2"),
          OpenStruct.new("body" => "review 3")
        ]
      )
    end

    it "returns the reviews count" do
      video_search = VideoSearchDecorator.new(reviews_response)
      expect(video_search.reviews_count).to eq 3
    end
  end

  describe "#first_review" do
    let(:empty_reviews_response) { OpenStruct.new("reviews" => []) }
    let(:normal_reviews_response) do
      OpenStruct.new(
        "reviews" => [
          OpenStruct.new("body" => "review 1"),
          OpenStruct.new("body" => "review 2")
        ]
      )
    end
    let(:highlighted_reviews_response) do
      OpenStruct.new(
        "reviews" => [
          OpenStruct.new("body" => "review 1"),
          OpenStruct.new("body" => "review 2")
        ],
        "highlight" => {
          "reviews.body" => [
            "<em class='label label-highlight'>review</em> 1",
            "<em class='label label-highlight'>review</em> 2",
          ]
        }
      )
    end

    it "returns no-review message when there is no review" do
      video_search = VideoSearchDecorator.new(empty_reviews_response)
      expect(video_search.first_review).to eq "There are currently no reviews."
    end

    it "returns normal first review from response" do
      video_search = VideoSearchDecorator.new(normal_reviews_response)
      expect(video_search.first_review).to eq "review 1"
    end

    it "returns highlighted first review from response" do
      video_search = VideoSearchDecorator.new(highlighted_reviews_response)
      expect(video_search.first_review).to eq "... <em class='label label-highlight'>review</em> 1 ..."
    end
  end
end
