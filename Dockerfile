FROM ruby:3.2.2-slim

# Install essential packages
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    git \
    libpq-dev \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install gems
RUN bundle install

# Precompile assets (if needed)
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Expose port
EXPOSE 3000

# Default command
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
