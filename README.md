# Ticketing System

A full-stack ticketing system with GraphQL API backend and JWT authentication.

## Prerequisites

- Ruby 3.3.0
- PostgreSQL
- Node.js (for frontend development)
- Mailtrap account (for email testing)

## Backend Setup

1. Clone the repository and navigate to the project directory

2. Install dependencies:
```bash
bundle install
```

3. Configure environment variables:

Create a `.env` file in the root directory with the following variables:
```plaintext
TICKETING_SYSTEM_DATABASE=your_database_name
TICKETING_SYSTEM_DATABASE_USERNAME=your_database_username
TICKETING_SYSTEM_DATABASE_PASSWORD=your_database_password
MAILTRAP_USERNAME=your_mailtrap_username
MAILTRAP_PASSWORD=your_mailtrap_password
```

4. Setup the database:
```bash
rails db:create
rails db:migrate
```

5. Start the Rails server:
```bash
rails s
```

The backend will be available at `http://localhost:3000`

## API Documentation

### Authentication

The system uses JWT tokens for authentication. Include the token in the Authorization header:
```
Authorization: Bearer jwt_token
```


## Features

- User authentication with JWT
- Role-based authorization (customer/agent)
- Ticket management
- File attachments
- Email notifications
- CORS configuration for frontend integration

## Development

### Testing

Run the test suite:
```bash
rspec
```

### GraphiQL

Access the GraphiQL interface at `http://localhost:3000/graphiql` for API testing and exploration.

## Frontend Integration

The backend is configured to accept requests from:
- `http://localhost:5173`
- `http://127.0.0.1:8080`
- `ticket-system-web.netlify.app`

## Environment Configuration

### Development
- Database: PostgreSQL
- Email: Configured with Mailtrap for testing
- File Storage: Local disk storage

### Production
Make sure to set appropriate environment variables and configure:
- Database credentials
- Email settings
- Storage solution
- JWT secret key

## Security

- JWT-based authentication
- Password encryption with Devise
- CORS protection
- Role-based authorization

## Sidekiq
The system uses Sidekiq for background processing. Start Sidekiq with:
```bash
bundle exec sidekiq
```
## Rake Task
A rake task is available to send daily open tickets to agents. Run it with: 
```bash
bundle exec rake  tickets:daily_open_tickets  
```