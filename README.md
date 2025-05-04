Requirements: 

- Ruby 3.4.2
- Rails 8.0.2
- SQLite3


Install dependencies:

- bundle install

Set up the database:

- rails db:setup

Sensitive credentials (app_id, password, checksum_key) are stored using Rails Encrypted Credentials with structure:

espago:
-  app_id: app_id
-  password: password
-  checksum_key: checksum_key

Application uses the dotenv-rails gem to manage environment variables for development and test environments. Required env variable is APP_HOST_URL, by default:

- APP_HOST_URL=http://localhost:3000 for dev
- APP_HOST_URL=http://localhost:3001 for test

These have to included in the root .env and .env.test files respectively

Running app:

- rails s

The test suite uses Rspec, Capybara and Selenium. To run the full test suite locally, ensure you have:

- Google Chrome or Chromium installed
- Chromedriver installed
- .env.test file with necessary variables (APP_HOST_URL), credentials are also required for testing

Running tests: 

- bundle exec rspec
