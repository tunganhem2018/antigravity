#!/bin/bash

# Define colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting TwentyCRM setup...${NC}"

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${YELLOW}.env file not found. Creating from .env.example...${NC}"
    cp .env.example .env
    
    # Generate random passwords
    DB_PASSWORD=$(openssl rand -base64 12)
    APP_SECRET=$(openssl rand -base64 32)
    
    # Update .env with generated secrets
    # Use sed compatible with both Linux and macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/PG_DATABASE_PASSWORD=replace_me_with_a_strong_password/PG_DATABASE_PASSWORD=$DB_PASSWORD/" .env
        sed -i '' "s|APP_SECRET=replace_me_with_a_random_string|APP_SECRET=$APP_SECRET|" .env
    else
        sed -i "s/PG_DATABASE_PASSWORD=replace_me_with_a_strong_password/PG_DATABASE_PASSWORD=$DB_PASSWORD/" .env
        sed -i "s|APP_SECRET=replace_me_with_a_random_string|APP_SECRET=$APP_SECRET|" .env
    fi
    
    echo -e "${GREEN}Generated secure passwords for database and app secret.${NC}"
else
    echo -e "${GREEN}.env file already exists. Skipping generation.${NC}"
fi

# Pull latest images
echo -e "${GREEN}Pulling latest Docker images...${NC}"
docker compose pull

# Start services
echo -e "${GREEN}Starting services...${NC}"
docker compose up -d

# Check status
echo -e "${GREEN}Checking service status...${NC}"
sleep 5
docker compose ps

echo -e "${GREEN}TwentyCRM should be available at http://localhost:3000${NC}"
