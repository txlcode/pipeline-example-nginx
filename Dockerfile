FROM centos:7
MAINTAINER QUNXUE
RUN yum install -y gcc gcc-c++ make \
    openssl-devel pcre-devel gd-devel \
    iproute net-tools telnet wget curl && \
    yum clean all && \
    rm -rf /var/cache/yum/*
RUN wget http://nginx.org/download/nginx-1.15.5.tar.gz && \
    tar zxf nginx-1.15.5.tar.gz && \
    cd nginx-1.15.5 &&\
    ./configure --prefix=/usr/local/nginx \
    --with-http_ssl_module \
    --with-http_stub_status_module && \
    make -j 4 && make install && \
    rm -rf /usr/local/nginx/html/* && \
    echo "ok" >> /usr/local/nginx/html/status.html && \
    cd / && rm -rf nginx-1.15.5* && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime  && \
    groupadd -r nginx && \
    useradd -r -g nginx nginx && \
    mkdir /var/log/nginx/ && \
    chown nginx:nginx /var/log/nginx/ -R
ENV PATH $PATH:/usr/local/nginx/sbin
COPY nginx.conf /usr/local/nginx/conf/nginx.conf
COPY test.html /usr/share/nginx/html
WORKDIR /usr/local/nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
