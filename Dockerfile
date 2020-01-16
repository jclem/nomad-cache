FROM node:alpine
COPY package*.json .
RUN yarn
COPY index.js .
CMD ["node", "index.js"]