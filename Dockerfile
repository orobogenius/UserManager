# Install node
FROM node:carbon
# Create working directory
WORKDIR /usr/src/app
# Copy package.json and package-lock.json (if exists).
COPY package*.json ./
# Install dependencies specified in package*.json
RUN npm install
# Bundle app
COPY . .
# Expose this port
EXPOSE 3000
# Command to start the app
CMD [ “npm”, “start” ]