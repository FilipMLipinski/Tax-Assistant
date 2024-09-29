# Step 1: Build the React app
FROM node:16 as build

# Set working directory
WORKDIR /app

# Install dependencies
COPY package.json /app/package.json
RUN npm install

# Copy the source code
COPY . /app

# Build the React app
RUN npm run build

# Step 2: Serve the app with a production server
FROM nginx:alpine

# Copy the build output to the Nginx server's directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 for the web server
EXPOSE 80

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]
