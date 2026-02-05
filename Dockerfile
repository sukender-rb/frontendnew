# ---------- Stage 1: Build React app ----------
##
FROM node:22 AS clientbuild
WORKDIR /client

# install client deps
COPY package*.json ./
RUN npm install --legacy-peer-deps

# copy client source and build
COPY public ./public
COPY src ./src
# if you have these files, keep them; harmless if missing:
COPY *.json ./
COPY *.js ./
RUN npm run build


# ---------- Stage 2: Install server deps + run ----------
FROM node:22-alpine AS final
WORKDIR /server

# install server deps
COPY server/package*.json ./
RUN npm install --legacy-peer-deps

# copy server source
COPY server/ ./

# copy React build into server/build
COPY --from=clientbuild /client/build ./build

EXPOSE 5000
CMD ["node", "index.js"]
