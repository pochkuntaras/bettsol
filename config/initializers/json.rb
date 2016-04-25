module JSON
  def self.parse_nil(json)
    JSON.parse(json) if json && json.length >= 2
  end
end
