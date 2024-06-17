FROM node:21


WORKDIR /app

COPY . .

RUN npm i
# comment
COPY ~/wanderlust/backend/.env.sample .env

EXPOSE 8080

ENTRYPOINT npm start
