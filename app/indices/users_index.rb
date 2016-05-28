ThinkingSphinx::Index.define :user, with: :active_record, delta: true do
  indexes email, sortable: true

  has updated_at, created_at
end
