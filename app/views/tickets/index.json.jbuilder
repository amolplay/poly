json.array!(@tickets) do |ticket|
  json.extract! ticket, :title, :description
  json.url ticket_url(ticket, format: :json)
end
