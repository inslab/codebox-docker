FROM ubuntu:14.04
MAINTAINER sunchanlee@inslab.co.kr

# Install nginx
WORKDIR /root
RUN apt-get install -y curl
RUN curl -O http://nginx.org/keys/nginx_signing.key
RUN apt-key add nginx_signing.key
RUN echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list \
    && echo "deb-src http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y nginx

# Nginx setting
RUN rm /etc/nginx/conf.d/*
ADD nginx_codebox.conf /etc/nginx/conf.d/codebox.conf

# Install tools and codebox
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y nodejs build-essential git python
RUN npm install -g node-gyp
RUN npm install -g codebox

# Rebuild pty.js
# codebox cannot find module ../build/Release/pty.node if don't rebuild pty.js
# http://stackoverflow.com/questions/23570023/issues-in-finding-node-package-when-running-codebox
RUN cd /usr/lib/node_modules/codebox/node_modules/shux/node_modules/pty.js \
    && make clean && make

RUN mkdir -p /opt/codebox_data/workspace
ENV HOME /opt/codebox_data

# Copy start script
ADD start.sh /root/start.sh
RUN chmod +x /root/start.sh

EXPOSE 80
VOLUME /opt/codebox_data

CMD /root/start.sh
