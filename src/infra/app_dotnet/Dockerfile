FROM centos:8

# Fix yum repo list and adjust mirrors to point to vault.centos.org due to CentOS 8 EOL
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# Install OS Utils
RUN yum install -y wget tar which gzip git

# Run OS Updates
RUN yum -y update


# Download a dotnet project 
RUN mkdir /app

WORKDIR /app

RUN git clone https://github.com/DigitecGalaxus/ProjectsRuler.git

WORKDIR /

# Prepare entrypoint to keep container running
COPY entrypoint.sh /

RUN chmod 755 entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]
