Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ['http://example.com', 'http://localhost:3000']
    resource '*',
      headers: :any,
      methods: [:get, :post, :options]
  end
end
