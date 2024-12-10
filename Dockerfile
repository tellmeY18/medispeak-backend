# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.2.2
ARG BUNDLER_VERSION=2.5.7

# Base stage with essential runtime dependencies
FROM docker.io/library/ruby:${RUBY_VERSION}-slim AS base
LABEL maintainer="Your Name <your.email@example.com>"

# Set production environment
ENV RAILS_ENV=production \
    BUNDLE_APP_CONFIG=/bundle \
    BUNDLE_PATH=/bundle \
    BUNDLE_WITHOUT=development:test \
    PATH=/rails/bin:$PATH

WORKDIR /rails

# Install runtime dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libpq-dev \
    libvips \
    postgresql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Build stage with build dependencies
FROM base AS build
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    pkg-config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install specific Bundler version
RUN gem install bundler:${BUNDLER_VERSION}

# Copy dependency files
COPY --link Gemfile Gemfile.lock ./

# Install gems with caching and optimization
RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install --jobs=4 --retry=3 && \
    bundle clean --force && \
    rm -rf vendor/bundle/ruby/*/cache

# Copy application code
COPY --link . .

# Precompile assets and bootsnap
RUN bundle exec bootsnap precompile app/ lib/ && \
    SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Final production stage
FROM base
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build --chown=1000:1000 /rails /rails

# Create non-root user
RUN groupadd --system --gid 1000 rails && \
    useradd rails \
    --uid 1000 \
    --gid 1000 \
    --create-home \
    --shell /bin/bash && \
    mkdir -p /rails/tmp /rails/log /rails/storage && \
    chown -R rails:rails \
    /rails/tmp \
    /rails/log \
    /rails/storage

# Switch to non-root user
USER rails:rails

# Application port
EXPOSE 3000

# Default command
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
