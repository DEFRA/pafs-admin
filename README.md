# Project Application and Funding Service

The Project Application and Funding Service (PAFS) is used by regional management authorities to apply for funding for flood and coastal risk management projects.

This application contains the back office functionality for the service as is intended for internal use only.

The application sends emails using the Send-grid e-mail service.

## PAFS Documentation
For a full breakdown of the PAFS documentation, technical and non technical please click the [link](https://aimspd.sharepoint.com/sites/pwa_dev/AIMS%20Project%20Delivery%20Collaboration/_layouts/15/guestaccess.aspx?docid=08fcc88cb3f7c45b48a274bf0ea4132f5&authkey=AWuSgciHOQlICM9DP0JtdRA)

## Development Environment

### Install global system dependencies

The following system dependencies are required, regardless of how you install the development environment.

* [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [git-flow](https://github.com/nvie/gitflow/wiki/Installation)

### Obtain the source code

Clone the repository, copying the project into a working directory:

    git clone https://github.com/EnvironmentAgency/pafs-admin.git
    cd pafs-admin

We use "git flow" to manage development and features branches.
To initialise git flow for the project, you need to run:

    git checkout -t origin/master
    git flow init # choose the defaults
    git checkout develop

See the [Wiki page on Git Flow](https://github.com/EnvironmentAgency/waste-exemptions/wiki/Git-Flow),
for more information about our branching strategy.

### Local Installation

#### Local system dependencies

* [Ruby 2.3.x](https://www.ruby-lang.org) (e.g. via [RVM](https://rvm.io) or [Rbenv](https://github.com/sstephenson/rbenv/blob/master/README.md))
* [Postgresql](http://www.postgresql.org/download)
* [Phantomjs](https://github.com/teampoltergeist/poltergeist#installing-phantomjs) (test specs)

#### Application gems _(local)_

Run the following to download the app dependencies ([rubygems](https://www.ruby-lang.org/en/libraries/))

    cd <pafs-project-directory>
    gem install bundler
    bundle install

#### Databases _(local)_

There are several databases per environment, therefore, ensure you run the following:

    bundle exec rake db:create:all
    bundle exec rake db:migrate db:seed

#### .env configuration file

The project uses the [dotenv](https://github.com/bkeepers/dotenv) gem which allows enviroment variables to be loaded from a ```.env``` configuration file in the project root.

Duplicate ```./dotenv.example``` and rename the copy as ```./.env```. Open it and update SECRET_KEY_BASE and settings for database, email etc.

#### Start the service _(local)_

To start the service locally simply run:

    bundle exec rails server

You can then access the web site at http://localhost:3000

#### Intercepting email in development

You can use mailcatcher to trap and view outgoing email.

Make sure you have the following in your `.env` or `.env.development` file:

    EMAIL_USERNAME=''
    EMAIL_PASSWORD=''
    EMAIL_APP_DOMAIN=''
    EMAIL_HOST='localhost'
    EMAIL_PORT='1025'

Start mailcatcher with `$ mailcatcher` and navigate to
[http://127.0.0.1:1080](http://127.0.0.1:1080) in your browser.

## Quality

We use tools like [rubocop](https://github.com/bbatsov/rubocop) and [brakeman](https://github.com/presidentbeef/brakeman), automated using GitHub actions.

## Tests

We use [RSpec](http://rspec.info/) for unit testing, and intend to use [Cucumber](https://github.com/cucumber/cucumber-rails) for our acceptance testing.

### Test database seeding

Before executing the tests for the first time, you will need to seed the database:

    bundle exec rake db:seed RAILS_ENV=test

To execute the unit tests simply enter:

    rspec

As this point we have no acceptance tests but when we do they can be executed using:

    cucumber

### Production debugging

More details on the pafs-user [README](https://github.com/DEFRA/pafs-user/#production-debugging)

## Contributing to this project

If you have an idea you'd like to contribute please log an issue.

All contributions should be submitted via a pull request.

## License

No license

Copyright [2015][EnvironmentAgency]
