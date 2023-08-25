
FROM ruby:2.4.1-stretch AS runner

ENV DEBIAN_FRONTEND=noninteractive

RUN set -xe \
    && sed -i /stretch-updates/d /etc/apt/sources.list \
    && sed -i /stretch\\/updates/d /etc/apt/sources.list

WORKDIR /app
COPY . /app

RUN bundle install --jobs=4

CMD ["tail", "-f", "/dev/null"]