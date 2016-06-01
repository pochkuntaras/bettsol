ThinkingSphinx::Index.define :comment, with: :active_record, delta: true do
  indexes content
  indexes user.email, as: :author, sortable: true

  has user_id, updated_at, created_at
end
