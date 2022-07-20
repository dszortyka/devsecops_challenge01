FROM centos:8 as base_image


# Change Below Variables if required:
ARG AWS_CORRETTO_VERSION="11.0.15.9.1"
ARG MAVEN_VERSION="3.8.6"




# Define bash as default shell
SHELL ["/bin/bash", "-c"]

# Create a folder to store downloaded files
RUN mkdir -p /usr/local/install_apps

# Define workdir
WORKDIR /usr/local/install_apps


# Fix yum repo list and adjust mirrors to point to vault.centos.org due to CentOS 8 EOL
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*


# Install os utils
RUN yum install -y wget libicu python39 python39-pip tar which gzip git dotnet-sdk-6.0

# Run OS Updates
RUN yum -y update

# syft
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin


# Install cyclonedx for python
RUN pip3 install cyclonedx-bom

# cyclonedx-cli
RUN wget https://github.com/CycloneDX/cyclonedx-cli/releases/download/v0.24.0/cyclonedx-linux-x64 && \
    chmod 755 cyclonedx-linux-x64 && \
    mv cyclonedx-linux-x64 /usr/bin/cyclonedx-cli


# Install Node and Cyclone/bom NPM Package
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash && \
    source ~/.bash_profile && \
    nvm install v16.16.0
#    npm install -g @cyclonedx/bom


# Install Amazon Corretto 11
#RUN wget -nv https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.tar.gz 
RUN wget -nv "https://corretto.aws/downloads/resources/${AWS_CORRETTO_VERSION}/amazon-corretto-${AWS_CORRETTO_VERSION}-linux-x64.tar.gz"
RUN tar -xzvf "amazon-corretto-${AWS_CORRETTO_VERSION}-linux-x64.tar.gz"
RUN mv amazon-corretto-${AWS_CORRETTO_VERSION}-linux-x64 /usr/local/

# Add Java to Path
ENV PATH="/usr/local/amazon-corretto-${AWS_CORRETTO_VERSION}-linux-x64/bin:${PATH}"


# Install Maven
RUN wget -nv "https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz"
RUN tar -xzvf "apache-maven-${MAVEN_VERSION}-bin.tar.gz"
RUN mv "apache-maven-${MAVEN_VERSION}" /usr/local/
ENV PATH="/usr/local/apache-maven-${MAVEN_VERSION}/bin:${PATH}"


# Install cyclonedx-core-java
RUN git clone https://github.com/CycloneDX/cyclonedx-core-java.git
RUN cd cyclonedx-core-java && mvn clean install



# CycloneDX DotNet specific requirements
RUN mkdir dotnet_install
WORKDIR /usr/local/install_apps/dotnet_install
RUN curl -L https://aka.ms/install-dotnet-preview -o install-dotnet-preview.sh
RUN bash install-dotnet-preview.sh
RUN wget https://download.visualstudio.microsoft.com/download/pr/56d9250f-97df-4786-b33e-a8e34b349e86/dcf054ca00899a70a80aa1a7d3072b52/dotnet-runtime-6.0.5-linux-x64.tar.gz
RUN wget https://download.visualstudio.microsoft.com/download/pr/a0e9ceb8-04eb-4510-876c-795a6a123dda/6141e57558eddc2d4629c7c14c2c6fa1/aspnetcore-runtime-6.0.5-linux-x64.tar.gz
RUN wget https://download.visualstudio.microsoft.com/download/pr/dc930bff-ef3d-4f6f-8799-6eb60390f5b4/1efee2a8ea0180c94aff8f15eb3af981/dotnet-sdk-6.0.300-linux-x64.tar.gz
RUN mkdir dotnet
RUN tar -C dotnet -xf dotnet-sdk-6.0.300-linux-x64.tar.gz
RUN mv dotnet /usr/local/
ENV DOTNET_ROOT="/usr/local/dotnet"
ENV PATH="${PATH}:/usr/local/dotnet"
RUN mv /usr/bin/dotnet /usr/bin/olddotnet
RUN ln -s /usr/local/dotnet/dotnet /usr/bin/dotnet


# Install dotnet and cyclonedx
RUN dotnet tool install --global CycloneDX --version 2.3.0
ENV PATH="/root/.dotnet/tools:${PATH}"


WORKDIR /


# Prepare entrypoint to keep container running
COPY entrypoint.sh /

RUN chmod 755 entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]



# docker image build -t base_image .
# docker tag base_image:latest base_image:latest
# docker run base_image


# docker volume create sbom-tests
# docker run -it -v sbom-tests:/shared-volume  ubuntu

# docker run -t -d -v sbom-tests:/shared-volume centos-test-run:10


# docker build -t groot .
# docker tag groot:latest groot:staging
