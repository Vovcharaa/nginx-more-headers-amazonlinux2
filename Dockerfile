FROM amazonlinux:2

WORKDIR /workspace

RUN yum groupinstall "Development Tools" -y \
    && yum install pcre pcre-devel openssl-devel libxslt-devel gd gd-devel perl-ExtUtils-Embed geoip-devel gperftools-devel wget -y \
    && mkdir -p /out

ARG NGINX_VERSION=1.22.1
ARG HEADERS_MORE_NGINX_VERSION=0.34

RUN wget -O nginx.tar.gz http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
    && mkdir nginx \
    && tar -zxvf nginx.tar.gz -C nginx --strip-components=1

RUN wget -O headers-more-nginx.tar.gz https://github.com/openresty/headers-more-nginx-module/archive/refs/tags/v${HEADERS_MORE_NGINX_VERSION}.tar.gz \
    && mkdir headers-more-nginx \
    && tar -zxvf headers-more-nginx.tar.gz -C headers-more-nginx --strip-components=1

RUN set -ex \
    && cd nginx \
    && ./configure --add-dynamic-module=../headers-more-nginx --prefix=/usr/share/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --http-client-body-temp-path=/var/lib/nginx/tmp/client_body --http-proxy-temp-path=/var/lib/nginx/tmp/proxy --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi --http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi --http-scgi-temp-path=/var/lib/nginx/tmp/scgi --pid-path=/run/nginx.pid --lock-path=/run/lock/subsys/nginx --user=nginx --group=nginx --with-compat --with-debug --with-file-aio --with-google_perftools_module --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_degradation_module --with-http_flv_module --with-http_geoip_module=dynamic --with-stream_geoip_module=dynamic --with-http_gunzip_module --with-http_gzip_static_module --with-http_image_filter_module=dynamic --with-http_mp4_module --with-http_perl_module=dynamic --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-http_xslt_module=dynamic --with-mail=dynamic --with-mail_ssl_module --with-pcre --with-pcre-jit --with-stream=dynamic --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-threads --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -m64 -mtune=generic' --with-ld-opt='-Wl,-z,relro -specs=/usr/lib/rpm/redhat/redhat-hardened-ld -Wl,-E' \
    && make modules \
    && chmod 755 objs/ngx_http_headers_more_filter_module.so

CMD cp nginx/objs/ngx_http_headers_more_filter_module.so /out/ngx_http_headers_more_filter_module.so
