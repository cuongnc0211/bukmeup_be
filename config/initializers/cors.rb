# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'  # This allows all origins, but you can specify specific domains instead of '*'
    resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options]
  end
end
