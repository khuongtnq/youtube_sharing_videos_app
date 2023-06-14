# Youtube sharing videos app

* Overview
    - A ruby on rails application
    - Use RoR for logic backend
    - Current version included functions:
        + User registration and login
        + Sharing YouTube videos
        + Viewing a list of shared videos (no need to display up/down votes)
        + Real-time notifications for new video shares
    - Unit test and integration test implementation

* Use case
  Comming soon...


## Things you may want to cover:

* Ruby version
  2.7.6

* Rails version
  7.0.3

* Postgres database

* How to run the test suite
    - Make sure your OS installed Google Chrome browser
    - Run test unit
  ```bash
  $ bundle install
  $ rails db:create
  $ RACK_ENV=test bundle exec rails test
  $ RACK_ENV=test bundle exec rspec path/to/spec/file.rb

  ```

* How to run application on docker
    - After you run test and all case passed
    - Make sure Docker enginee running and docker compose installed
    - Run
  ```bash
  $ docker-compose up --build
  ```

    - Open URL: http://localhost:3000
## Test and Deploy

Use the built-in continuous integration in Fly.io.
* Domain: https://youtube-sharing-videos.fly.dev/api/v1/sign_up/
## Done
 - Feature User registration and login
 - Feature Sharing YouTube videos api
 - Implement the real-time notifications feature using ApplicationCable and background jobs
 - Deploy the application and include the link to the site when submitting the project
 - Docker configuration to run locally
