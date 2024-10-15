# Development Setup

The backed is developed using a standard Ruby on Rails 8 setup, with a Postgres database and tailwind for styling.

> The documentation is incomplete, and the steps are not tested, you can use the Rails setup documentation if you are stuck.

These instructions cover setting up the development environment for MediSpeak on **macOS**, **Ubuntu**, and **Windows** ([WSL](https://docs.microsoft.com/en-us/windows/wsl/install) with Ubuntu 22.04). Instructions for Ubuntu also apply to Windows (WSL), except where special instructions are noted.

## Install and configure dependencies

### Install third-party software

#### On macOS

We'll use [Homebrew](https://brew.sh/) to fetch most of the packages on macOS:

- libvips - `brew install vips`
- postgresql - Install [Postgres.app](http://postgresapp.com) and follow its
  [instructions](https://postgresapp.com/documentation/install.html), **including** the part about setting up
  command-line tools.

#### On Ubuntu

The following command should install all required dependencies on Ubuntu. If you're using another _flavour_ of Linux,
adapt the command to work with the package manager available with your distribution.

    sudo apt-get install libvips postgresql postgresql-contrib autoconf libtool libpq-dev

##### Check version of libvips

Make sure that you're running a version of `libvips` higher than 18.15.1. If you've got a lower version, you may need to [build it from source](https://github.com/libvips/libvips/wiki/Build-for-Ubuntu).

### Install Ruby & Node.js

Use [asdf](https://asdf-vm.com/) to install Ruby and Node.js. Simply run `asdf install` from the project directory. It'll read the required versions from the `.tool-versions` file and install them.

### Install Rubygems

Once Ruby is installed, fetch all gems using Bundler:

    bundle install

You may need to install the `bundler` gem if the version of Ruby you have installed comes with a different `bundler`
version. Simply follow the instructions in the error message, if this occurs.

On macOS, if installation of the `pg` gem crashes, asking for `libpq-fe.h`, run the following commands, and then run `bundle install` again:

## Set credentials for local database

Let's make sure that PostgreSQL server is up and running using the following command:

    # macOS
    brew services start postgresql

    # Ubuntu
    sudo service postgresql start

**Note for WSL users:** You'll need to run the above command each time you restart Windows, and open up Ubuntu for the first time.

If you're setting up Postgres for the first time, we'll now set a password for the `postgres` database username.

Once PostgreSQL server is running, we'll set a password for the default database user. Open the `psql` CLI:

    # macOS
    psql -U postgres

    # Ubuntu
    sudo -u postgres psql

Then, in the PostgreSQL CLI, set a new password and quit.

    # Set a password for this username.
    \password postgres

    # Quit.
    \q

## Configure application environment variables

1. Copy `example.env` to `.env`.

   ```
   cp example.env .env
   ```

2. Update the values of `DB_USERNAME` and `DB_PASSWORD` in the new `.env` file.

   Use the same values from the previous step. The username should be `postgres`, and the password will be whatever value you've set.

The `.env` file contains environment variables that are used to configure the application. The file contains documentation explaining where you should source its values from. If you're just starting out, you shouldn't have to change any variables other than the ones listed above.

## Seed local database

    bundle exec rails db:setup

This will also _seed_ data into the database that will be useful for testing during development.

## Start the Rails server

    ./bin/dev

## Logging in with Demo Credentials

We've created a demo account for you to use right away. Here are the login details:

- **Username:** `admin@example.com`
- **Password:** `password123`

These credentials were automatically added to your database during the seeding process. Feel free to use them to dive right in!

### Exploring the Admin Panel

The demo account comes with admin privileges. This means you can access the admin panel.

To visit the admin panel:

1. Log in using the demo credentials
2. Navigate to: http://localhost:3000/admin
