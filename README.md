# BettSol website

This application is designed to help people solve their problems.

## Installation

It's preferable that you'll use RVM for managing gems and ruby versions.

Go to project directory and install appropriate version of ruby and create gemset for the project as described in **.ruby-version** and **.ruby-gemset** files.

Install gems by running

```
bundle install
```

Copy **database.yml.example** as **database.yml** and configure your database connection.

Create database and run migrations:

```
rake db:create
rake db:migrate
```

Seed database with test data:

```
rake db:seed
```

Start your server:

```
rails server
