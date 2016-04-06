ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag !~ /^<label/
    errors = Array(instance.error_message).join(",\s")
    %(#{html_tag}<span class="validation-error">#{errors}</span>).html_safe
  else
    html_tag.html_safe
  end
end
