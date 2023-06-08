FROM ruby:2.7.6
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN apt-get install -y vim
RUN mkdir -p /app
WORKDIR /app
COPY Gemfile  /app/
ADD . /app

COPY ./bin/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
# Expose port 3000 to the Docker host, so we can access it
# from the outside.
EXPOSE $RAILS_PORT

COPY ./bin/run.sh /app/

CMD ["/app/run.sh"]
