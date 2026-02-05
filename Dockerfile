# Stage 1: Build React app
FROM node:22 AS build
WORKDIR /app

COPY package*.json ./
RUN npm install --legacy-peer-deps

COPY . .
RUN npm run build

# copy build into server folder
RUN cp -r build server

# install server dependencies
WORKDIR /app/server
RUN npm install --legacy-peer-deps


# Stage 2: Running the BFF Server
FROM node:22-alpine AS final
WORKDIR /server

COPY --from=build /app/server .

EXPOSE 5000
CMD ["node", "index.js"]
