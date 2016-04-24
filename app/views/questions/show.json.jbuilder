json.key_format! camelize: :lower

json.question do
  json.(@question, :user_id, :title)
  json.path question_path(@question)
end
