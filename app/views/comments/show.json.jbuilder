json.key_format! camelize: :lower

json.comment do
  json.(@comment, :content)
  json.commentable "#{@comment.commentable_type.downcase}_#{@comment.commentable_id}"
end
