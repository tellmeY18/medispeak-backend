FROM ruby:3.2.2-slim

# Install Git and other essentials
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    git \
    libpq-dev \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Configure Git to use HTTPS instead of SSH
RUN git config --global url."https://".insteadOf git://

WORKDIR /app

# Copy only Gemfile first for better caching
COPY Gemfile Gemfile.lock ./

# Install gems with more verbose output and Git configuration
RUN bundle config set force_ruby_platform true && \
    bundle install --jobs 4 --retry 3 -V
# Precompile assets (if needed)
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Expose port
EXPOSE 3000

# Default command
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
