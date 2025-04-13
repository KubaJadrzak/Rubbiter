Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'rubitter.net'  # Add your domain here
      resource '*', headers: :any, methods: [:get, :post, :options]
    end
  end