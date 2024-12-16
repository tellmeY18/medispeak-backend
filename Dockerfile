# Base Image
ARG RUBY_VERSION=3.2.2
FROM ruby:${RUBY_VERSION}-slim AS base

# Set Environment Variables
ENV BUNDLE_PATH=/usr/local/bundle \
    RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true

# Set working directory
WORKDIR /rails

# Install base dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libjemalloc2 \
    libvips \
    postgresql-client \
    build-essential \
    git \
    libpq-dev \
    pkg-config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archives/*

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle config set --local without 'development test' && \
    bundle install --jobs=4 --retry=3 && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}/ruby/*/cache" "${BUNDLE_PATH}/ruby/*/bundler/gems/*/.git"

# Copy application code
COPY . .

# Create master key script
RUN echo '#!/bin/bash\n\
if [ -z "$RAILS_MASTER_KEY" ]; then\n\
    echo "Warning: RAILS_MASTER_KEY is not set. Using a dummy key for build."\n\
    echo "dummy-key-for-build-only" > config/master.key\n\
else\n\
    echo "$RAILS_MASTER_KEY" > config/master.key\n\
fi\n\
chmod 600 config/master.key\n\
' > /tmp/setup-master-key.sh && \
    chmod +x /tmp/setup-master-key.sh && \
    /tmp/setup-master-key.sh

# Precompile assets and bootsnap (use dummy key if needed)
RUN bundle exec bootsnap precompile --gemfile && \
    bundle exec bootsnap precompile app/ lib/ && \
    bundle exec rails assets:precompile

# Create a non-root user for running the application
RUN groupadd --system --gid 1000 rails && \
    useradd --system --uid 1000 --gid 1000 --create-home --shell /bin/bash rails && \
    chown -R rails:rails db log storage tmp config/master.key

# Switch to non-root user
USER rails:rails

# Create a docker-entrypoint script
RUN echo '#!/bin/bash\n\
set -e\n\
rm -f /rails/tmp/pids/server.pid\n\
if [ -n "$RAILS_MASTER_KEY" ]; then\n\
    echo "$RAILS_MASTER_KEY" > config/master.key\n\
    chmod 600 config/master.key\n\
fi\n\
exec "$@"\n\
' > /rails/bin/docker-entrypoint && \
    chmod +x /rails/bin/docker-entrypoint

# Expose port and set entrypoint
EXPOSE 3000
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
