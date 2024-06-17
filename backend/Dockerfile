FROM node:21


WORKDIR /app

COPY . .

RUN npm i

COPY ~/wanderlust/backend/.env.sample .env

EXPOSE 8080

ENTRYPOINT npm start
