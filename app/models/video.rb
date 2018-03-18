class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }

  validates_presence_of :title, :description, :video_url

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name [Rails.application.engine_name, Rails.env].join('_')

  def self.search_by_title(title)
    return [] if title.blank?
    where("title LIKE ?", "%#{title}%")
  end

  def average_rating
    reviews.average(:rating).to_f.round(1) if reviews.any?
  end

  def self.search(query, options = {})
    search_definition =
      if query.present?
        {
          query: {
            bool: {
              must: {
                multi_match: {
                  query: query,
                  fields: ["title^100", "description^50"],
                  operator: "and"
                }
              }
            }
          },
          highlight: {
            pre_tags: ["<em class='label label-highlight'>"],
            post_tags: ["</em>"],
            fields: {
              title: { number_of_fragments: 0 },
              description: { number_of_fragments: 0 }
            }
          }
        }
      else
        { query: { bool: { must: { match_all: {} } } } }
      end

    if query.present? && options[:reviews]
      search_definition[:query][:bool][:must][:multi_match][:fields] << "reviews.body"
      search_definition[:highlight][:fields].update "reviews.body" => { fragment_size: 235 }
    end

    if options[:rating_from].present? || options[:rating_to].present?
      search_definition[:query][:bool][:filter] = {
        range: {
          average_rating: {
            gte: (options[:rating_from] if options[:rating_from].present?),
            lte: (options[:rating_to] if options[:rating_to].present?)
          }
        }
      }
      search_definition[:sort] = { average_rating: 'desc' }
    end

    __elasticsearch__.search(search_definition)
  end

  def as_indexed_json(options = {})
    self.as_json(
      methods: [:average_rating],
      only: [:title, :description, :average_rating, :small_cover],
      include: {
        reviews: { only: [:body] }
      }
    )
  end
end
