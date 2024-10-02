# Medispeak Backend

Medispeak: Transforming Patient-Doctor Dialogues Worldwide!

This is the backend API for Medispeak, a tool that provides seamless transcriptions and effortless EMR integration. Our goal is to streamline patient-doctor interactions and automate form filling processes.

## Features

- Automated transcription of patient-doctor dialogues and form filling with plugin
- API for transcription and data structuring
- Template management for various medical forms in different emr systems

## Tech Stack

- Ruby on Rails
- PostgreSQL

## Getting Started

### Prerequisites

- Ruby (version specified in `.ruby-version`)
- Rails (version specified in `Gemfile`)
- PostgreSQL

### Installation

1. Clone the repository:

   ```
   git clone https://github.com/medispeak/medispeak_backend.git
   cd medispeak_backend
   ```

2. Install dependencies:

   ```
   bundle install
   ```

3. Set up the database:

   ```
   rails db:create db:migrate
   ```

4. Set up environment variables:

   ```
   cp example.env .env
   ```

   Edit `.env` and add your configuration details.

5. Start the server:
   ```
   ./bin/dev
   ```

## API Documentation

WIP
