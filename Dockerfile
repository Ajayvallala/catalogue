FROM node:20-alpine3.19 AS builder
WORKDIR /opt/server
COPY package.json .
COPY *.js .
RUN npm install

FROM node:20-alpine3.19
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop
ENV MONGO="true" \
    MONGO_URL="mongodb://mongodb:27017/catalogue"
WORKDIR /opt/server
USER roboshop
COPY --from=builder --chown=roboshop:roboshop /opt/server /opt/server
CMD ["node","server.js"]


# FROM node:20-alpine
# WORKDIR /opt/server
# COPY package.json .
# COPY *.js .
# RUN npm install 
# ENV MONGO="true" \
#     MONGO_URL="mongodb://mongodb:27017/catalogue"
# CMD ["node","server.js"]


# FROM node:20
# WORKDIR /opt/server
# COPY package.json .
# COPY *.js .
# RUN npm install 
# ENV MONGO="true" \
#     MONGO_URL="mongodb://mongodb:27017/catalogue"
# CMD ["node","server.js"]
