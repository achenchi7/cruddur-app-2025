FROM node:16.18

ENV PORT=3000

# Set working directory
WORKDIR /frontend-react-js

# Copy package.json and package-lock.json first
COPY package*.json ./

# Install dependencies
RUN npm install

# Now copy the rest of the app (after installing dependencies)
COPY . .

# Expose the port React dev server uses
EXPOSE ${PORT}

# Start the app
CMD ["npm", "start"]
