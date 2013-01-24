# encoding: utf-8

class TvArticle < Article
  attr_accessor :head_video_url
  attr_accessible :head_video_url

  before_validation :extract_image_and_code_for_video
  validate :head_video_code_presence

  def head_video_url
    case
    when @head_video_url.present?
      @head_video_url
    when head_video_code.present?
      "http://www.youtube.com/watch?v=#{head_video_code}"
    else
      ''
    end
  end

  private

  def extract_image_and_code_for_video
    process_head_video_url
    generate_video_thumbnail
  end

  # same as usual presence, but put error for _url field
  # to be displayed in admin form
  def head_video_code_presence
    errors.add(:head_video_url, :blank) if head_video_code.blank?
  end

  def process_head_video_url
    return if head_video_url.blank?

    reg1 = /youtube\.com\/embed\/([a-zA-Z0-9_-]+)/
    reg2 = /youtu\.be\/([a-zA-Z0-9_-]+)/
    reg3 = /youtube\.com\/watch.*v=([a-zA-Z0-9_-]+)/
    match = reg1.match(head_video_url) || reg2.match(head_video_url) || reg3.match(head_video_url)
    
    self.head_video_code = match[1] if match
  end

  def generate_video_thumbnail
    return if head_video_code.blank?
    return unless head_video_code_changed?
    
    thumb_url = "http://img.youtube.com/vi/#{head_video_code}/0.jpg"

    require "uri"
    require "net/http"

    file = Tempfile.new(['youtube_thumb', '.jpg'])
    file.binmode
    file.write(open(thumb_url).read)
    file.close
    self.head_image = file
  rescue OpenURI::HTTPError
    errors.add(:head_video_url, "Видео по указанной ссылке не найдено")
  end
end