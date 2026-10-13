# Stage 1: cài deps + build
FROM node:24-alpine AS build
WORKDIR /var/www/app
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
RUN corepack enable pnpm
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
COPY tsconfig.json ./
COPY src ./src
RUN pnpm build && pnpm prune --prod

# Stage 2: runtime
FROM node:24-alpine
ENV NODE_ENV=production
RUN npm install -g pm2@7.0.4
WORKDIR /var/www/app
COPY package.json pm2.json ./
COPY --from=build /var/www/app/node_modules ./node_modules
COPY --from=build /var/www/app/dist ./dist
EXPOSE 3334
CMD ["pm2-runtime", "pm2.json"]
