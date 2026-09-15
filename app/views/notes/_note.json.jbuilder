json.extract! note, :id, :title, :content, :is_pinned, :created_at, :updated_at
json.url note_url(note, format: :json)
