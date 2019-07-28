# Follow these steps to run the Rails app:

1. Build the local Dockerfile:

    docker-compose build

2. Get the rails app running on the background:
 
     docker-compose up -d

3. Create database, run migrations and seed root folder.

    docker-compose exec web rails db:create db:migrate db:seed

4. Go to localhost:3000 access app!

5. To run tests

    docker-compose run --rm -e RAILS_ENV=test web rspec
    
