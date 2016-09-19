# Dockerfile for Insight-Dash Server
# https://www.dash.org/
# https://github.com/thelazier/insight-dash

FROM alpine
MAINTAINER TheLazieR <thelazier@gmail.com>
LABEL description="Dockerized Insight Dash Server"

WORKDIR /
# Install packages
RUN apk --update add build-base git python python-dev py-setuptools tar patch wget linux-headers libtool perl autoconf automake bash
# Install Node
ENV NODE_VERSION=0.10.46
RUN wget http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.gz \
  && tar -xvf node-v$NODE_VERSION.tar.gz \
  && cd node-v$NODE_VERSION \
  && ./configure \
  && make \
  && make install \
  && cd .. \
  && rm -r node-v$NODE_VERSION node-v$NODE_VERSION.tar.gz

### Electrum-Dash Server
# Clone
WORKDIR /
RUN git clone -b master --depth 1 https://github.com/thelazier/insight-dash.git

# Compile & Install
RUN cd insight-dash \
  && npm install

# Volume data
RUN mkdir /insight_data
VOLUME [/insight_data]
RUN mkdir /insight_data/.insight && ln -s /insight_data/.insight $HOME/.insight

EXPOSE 3000 3001
WORKDIR /insight-dash
CMD npm start
# End.
