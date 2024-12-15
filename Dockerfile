# Base Image
ARG RUBY_VERSION=3.2.2
FROM ruby:${RUBY_VERSION}-slim AS base

# Set Environment Variables
ENV BUNDLE_PATH=/usr/local/bundle \
    RAILS_ENV=production \
    SECRET_KEY_BASE_DUMMY=1

# Set working directory
WORKDIR /rails

# Install base dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libjemalloc2 \
    libvips \
    postgresql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archives/*

# Build Stage for Gems and Precompilation
FROM base AS build

# Install build dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libpq-dev \
    pkg-config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archives/*

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs=4 --retry=3 && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}/ruby/*/cache" "${BUNDLE_PATH}/ruby/*/bundler/gems/*/.git" && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile assets and bootsnap
RUN bundle exec bootsnap precompile app/ lib/ && \
    ./bin/rails assets:precompile

# Final Runtime Image
FROM base

# Copy built artifacts
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Create a non-root user for running the application
RUN groupadd --system --gid 1000 rails && \
    useradd --system --uid 1000 --gid 1000 --create-home --shell /bin/bash rails && \
    chown -R rails:rails db log storage tmp

USER rails:rails

# Entrypoint and default command
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
