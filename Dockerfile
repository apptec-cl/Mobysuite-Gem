
FROM ruby:2.4.1-stretch AS runner

ENV DEBIAN_FRONTEND=noninteractive

RUN set -xe \
    && sed -i /stretch-updates/d /etc/apt/sources.list \
    && sed -i  \
    -e '/stretch\/updates/d' \ 
    -e 's/deb.debian.org/archive.debian.org/g' \
    -e 's/stable\/updates/stable-security\/updates/' /etc/apt/sources.list

RUN apt update -y &&  apt install -y 

WORKDIR /app
COPY . /app

RUN bundle install --jobs=4

CMD ["tail", "-f", "/dev/null"]