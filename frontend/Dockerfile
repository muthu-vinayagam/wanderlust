FROM node:22

WORKDIR /app

# COPY package*.json ./

#RUN npm cache clean --force && \
#    rm -rf node_modules package-lock.json

COPY . .

RUN npm i

COPY .env.sample .env

EXPOSE 5173

CMD ["npm", "run", "dev", "--", "--host"]
