ARG NODE_VERSION=20
FROM node:${NODE_VERSION}-buster-slim  as builder

WORKDIR /usr/src/app

# Download dependencies using bind and cache mounts to leverage Docker's caching.
# This will speed up subsequent builds.
COPY package*.json ./
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm ci --omit=dev


COPY . .


FROM node:${NODE_VERSION}-alpine

# Use production node environment
ENV NODE_ENV production

WORKDIR /usr/src/app


COPY --from=builder /usr/src/app .


USER node

# Expose the port that the application listens on.
EXPOSE 4005

# Run the application.
CMD ["npm", "start"]
