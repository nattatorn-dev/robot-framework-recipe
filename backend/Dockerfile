FROM node:16-alpine as builder
WORKDIR /var/source
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:16-alpine
WORKDIR /var/source
RUN chown node:node .
USER node
COPY --from=builder /var/source/node_modules node_modules
COPY --from=builder /var/source/dist dist
COPY --from=builder /var/source/package.json .
CMD [ "npm", "run", "start:production" ]