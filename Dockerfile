FROM ruby:3.0.0-alpine3.13

ENV RAILS_ENV=production

WORKDIR /opt

COPY . .

RUN apk add --no-cache build-base git sqlite sqlite-dev sqlite-libs libxml2-dev nodejs nodejs-npm make

RUN bundle config set --local without 'development test'
RUN bundle install

RUN npm install -g yarn

RUN rake db:migrate

RUN rake assets:precompile
RUN bin/webpack

EXPOSE 3000
ENTRYPOINT ["rails", "s", "-e", "production"]

