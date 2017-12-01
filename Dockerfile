FROM alpine:3.6

ARG VERSION=3.4.2
ARG BUILD_DATE
ARG VCS_REF

LABEL \
    maintainer="lonly197@qq.com" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.license="Apache License 2.0" \
    org.label-schema.name="lonly/docker-alpine-r" \
    org.label-schema.url="https://github.com/lonly197" \
    org.label-schema.description="This is a Base and Clean Docker Image for R Programming Language." \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/lonly197/docker-alpine-r" \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vendor="lonly197@qq.com" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0"

# Define environment 
ENV	JAVA_HOME=/usr/lib/jvm/default-jvm \
    PATH=$PATH:${JAVA_HOME}:${JAVA_HOME}/bin:${JAVA_HOME}/jre:${JAVA_HOME}/jre/bin

# Install packages
RUN	set -x \
    ## Add Aliyun repo
    && echo http://mirrors.aliyun.com/alpine/v3.6/main/ >> /etc/apk/repositories \
    && echo http://mirrors.aliyun.com/alpine/v3.6/community/>> /etc/apk/repositories \
    ## Update apk package
    && apk update \
    ## Install base package
    && apk add --no-cache --upgrade bash curl libressl-dev curl-dev libxml2-dev gcc g++ git coreutils ncurses \
    ## Install R package
    && apk add --no-cache --upgrade R R-dev R-doc \
    ## R bindings to the libgit2 library
    && git clone https://github.com/ropensci/git2r.git \
    && R CMD INSTALL --configure-args="--with-libssl-include=/usr/lib/" git2r \
    ## Install R dev related package
    && R -q -e "install.packages('knitr', repos='https://cloud.r-project.org')" \
    && R -q -e "install.packages('ggplot2', repos='https://cloud.r-project.org)" \
    && R -q -e "install.packages('googleVis', repos='https://cloud.r-project.org')" \
    && R -q -e "install.packages('data.table', repos='https://cloud.r-project.org)" \
    && R -q -e "install.packages('devtools', repos='https://cloud.r-project.org')" \
    && R -q -e "install.packages('covr', repos='https://cloud.r-project.org')" \
    && R -q -e "install.packages('roxygen2', repos='https://cloud.r-project.org')" \
    && R -q -e "install.packages('testthat', repos='https://cloud.r-project.org')" \
    && R -q -e "install.packages('Rcpp', repos='https://cloud.r-project.org)" \
    && Rscript -e "library('devtools'); library('Rcpp'); install_github('ramnathv/rCharts')" \
    ## Cleanup
    && rm -rf *.tgz \
            *.tar \
            *.zip \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*