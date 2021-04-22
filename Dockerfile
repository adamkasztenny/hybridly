FROM ruby:3.0.1-alpine3.13

ENV RAILS_ENV=production

WORKDIR /opt

COPY . .

RUN apk add --no-cache build-base sqlite-dev nodejs nodejs-npm make

RUN bundle config set --local without 'development test'
RUN bundle install

RUN npm install -g yarn

RUN rake assets:precompile
RUN bin/webpack

RUN apk del nodejs nodejs-npm

EXPOSE 3000
CMD ["/bin/sh", "-c", "make migrate && rails s -e production"]

