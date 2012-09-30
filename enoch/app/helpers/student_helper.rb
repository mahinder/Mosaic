module StudentHelper
  def pdf_image_tag(image, options = {})
    options[:src] = File.expand_path(Rails.root) + '/public' + image
    tag(:img, options)
  end

  def pdf_male_image_tag(image, options = {})
    options[:src] = File.expand_path(Rails.root) + '/app/assets/images/' + image
    tag(:img, options)
  end

  def pdf_female_image_tag(image, options = {})
    options[:src] = File.expand_path(Rails.root) + '/app/assets/images/' + image
    tag(:img, options)
  end
end
