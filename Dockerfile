FROM ubuntu:16.04

# Setup application environment variables
ARG DBTYPE=""
ARG SQLHOST=""
ARG SQLPORT=""
ARG SQLUSER=""
ARG SQLPWD=""
ARG DBNAME=""
ARG DEFECTDOJO_ADMIN_PASSWORD=""
ARG DEFECTDOJO_ADMIN_USER=""
ARG DOJO_ADMIN_EMAIL=""
ARG C_FORCE_ROOT=""

ENV DBTYPE=$DBTYPE
ENV SQLHOST=$SQLHOST
ENV SQLPORT=$SQLPORT
ENV SQLUSER=$SQLUSER
ENV SQLPWD=$SQLPWD
ENV DBNAME=$DBNAME
ENV DEFECTDOJO_ADMIN_PASSWORD=$DEFECTDOJO_ADMIN_PASSWORD
ENV DEFECTDOJO_ADMIN_USER=$DEFECTDOJO_ADMIN_USER
ENV BATCH_MODE=""
ENV DOJO_ADMIN_EMAIL=$DOJO_ADMIN_EMAIL
ENV C_FORCE_ROOT=$C_FORCE_ROOT

# Update and install basic requirements
RUN apt-get update && apt-get install -y \
    postgresql \
    postgresql-contrib \
    python \
    python-pip \
    apt-transport-https \
    nodejs-legacy \
    npm \
    mysql-client \
    libmysqlclient-dev \
    sudo \
    curl \
    git \
    expect \
    wget \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Upload The DefectDojo application
WORKDIR /opt
RUN git clone -b dev https://github.com/lisfo4ka/django-DefectDojo.git

# Install application dependencies
WORKDIR /opt/django-DefectDojo
RUN pip install -r requirements.txt
RUN /bin/bash -c "cd /opt/django-DefectDojo && source entrypoint_scripts/common/dojo-shared-resources.sh && install_os_dependencies && install_yarn_packages"
RUN chmod 777 -R /opt/django-DefectDojo

# Add entrypoint script
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
