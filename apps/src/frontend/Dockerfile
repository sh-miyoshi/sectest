FROM ruby:2.5.1-alpine3.7

RUN mkdir -p /myapp
WORKDIR /myapp
EXPOSE 4567
#ENV APP_ENV production

RUN gem install sinatra

COPY main.rb main.rb
COPY views views

CMD ruby main.rb

