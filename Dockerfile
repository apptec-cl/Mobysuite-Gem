
FROM ruby:2.4.1-stretch AS runner

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y &&  apt install -y \
    `# mysql deps` \
    mysql-client 

WORKDIR /app
COPY ./Gemfile* /app

# RUN bundle install --jobs=4

CMD ["tail", "-f", "/dev/null"]