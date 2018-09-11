FROM ruby:2.5.1-alpine3.7

RUN gem install sinatra
RUN mkdir -p /app/views
WORKDIR /app
EXPOSE 4567
COPY front-end.rb front-end.rb
COPY index.erb views/index.erb
#ENV APP_ENV production

CMD ruby front-end.rb

