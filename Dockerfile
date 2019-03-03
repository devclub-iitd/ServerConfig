FROM jwilder/nginx-proxy
RUN apt-get update
RUN apt-get -y install vim curl
RUN { \
      echo 'client_max_body_size 200M;'; \
    } > /etc/nginx/conf.d/my_proxy.conf
