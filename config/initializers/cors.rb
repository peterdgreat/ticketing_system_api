# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:5173, http://127.0.0.1:8080, https://vercel.com/rubywizards-projects/ticketing-system-frontend/414AxmycbYcGoPajaXj4ffn1jSSe"

    resource "*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
      # expose: ['Authorization'],  # Expose the Authorization header
      credentials: true  # Allow credentials (cookies, authorization headers, etc.)
  end
end
