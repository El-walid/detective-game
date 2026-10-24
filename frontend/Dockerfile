# frontend/Dockerfile
FROM node:20-alpine

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the frontend code
COPY . .

EXPOSE 5173

# Start Vite and expose to host network
CMD ["npm", "run", "dev", "--", "--host"]