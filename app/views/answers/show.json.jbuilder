json.key_format! camelize: :lower

json.answer do
  json.(@answer, :id, :user_id, :content, :rating)
  json.path answer_path(@answer)
  json.best_path best_answer_path(@answer)
  json.like_path like_answer_path(@answer)
  json.dislike_path dislike_answer_path(@answer)
  json.indifferent_path indifferent_answer_path(@answer)
  json.comments_path answer_comments_path(@answer)

  json.attachments @answer.attachments do |attachment|
    json.id attachment.id
    json.identifier attachment.file.identifier
    json.path attachment.file.url
  end
end

json.question do
  json.(@question, :user_id)
end
