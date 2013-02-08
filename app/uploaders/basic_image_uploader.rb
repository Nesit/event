# encoding: utf-8

# for filenames
require 'digest/md5'

class BasicImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  storage :file

  def default_url
    "/none"
  end

  # hack to make fallback url work
  def url(*args)
    super_url = super
    File.exists?("#{root}#{super_url}") ? super_url : default_url
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    case
    when original_filename
      "#{Digest::MD5.hexdigest(original_filename)}.png"
    when model.send(:"#{mounted_as}?")
      old_mount = model.send(mounted_as)
      File.basename old_mount.to_s
    when model[mounted_as].nil?
      nil
    end
  end
end
