# nginx-more-headers

This repository contains Dockerfile and docker-compose.yml to easily compile `nginx-more-headers` module for nginx on Amazon Linux 2.  
To compile module simply run `docker compose up --build`.  
After successful compilation, `ngx_http_headers_more_filter_module.so` file can be located in this folder.  
If you need to change version of nginx that will use this module or module version, change `NGINX_VERSION` and/or `HEADERS_MORE_NGINX_VERSION` build arg in docker-compose.yml
