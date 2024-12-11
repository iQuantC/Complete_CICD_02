# Use an official alpine nodeJS image as the base image
FROM node:alpine

# Set working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install only production nodeJS dependencies in Docker Image
RUN npm install --only=production

# Copy the rest of the application code into the container
COPY . .

# Expose the app on a port
EXPOSE 3000

# Command that runs the app
CMD ["npm", "start"]

##

