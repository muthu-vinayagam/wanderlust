FROM node:21


WORKDIR /app

COPY . .

RUN npm i
# comment
COPY .env.sample .env

EXPOSE 8080

ENTRYPOINT npm start
