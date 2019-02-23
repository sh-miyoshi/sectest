FROM ruby:2.5.1-alpine3.7

RUN mkdir -p /myapp
WORKDIR /myapp
EXPOSE 4567
#ENV APP_ENV production

RUN apk --no-cache add \
      build-base \
      mysql-dev

RUN gem instal sinatra mysql2

COPY main.rb main.rb

CMD ruby main.rb

