module IconsHelper
  def icon(name, **options)
    classes = class_names "icon icon--#{name}", options.delete(:class)
    options["aria-hidden"] = true

    content_tag :span, "", class: classes, **options
  end
end
