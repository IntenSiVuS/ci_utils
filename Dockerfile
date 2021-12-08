# dind based on Ubuntu
FROM cruizba/ubuntu-dind

ARG BUILD_DEB_PKGS='bzip2 gnupg2'
ARG RUNTIME_DEB_PKGS='ca-certificates git jq python3 python3-pip zip curl unzip'
RUN set -eux; \
  apt-get -qy update; \
  apt-get -qy install --no-install-recommends $BUILD_DEB_PKGS $RUNTIME_DEB_PKGS;

ENV TERRAFORM_VERSION=1.0.11 \
    AWS_CLI_V2_VERSION=2.0.30 \
    CONFTEST_VERSION=0.24.0 \
    PLUGIN_DOWNLOAD_URL=https://releases.hashicorp.com 

# Install terraform
RUN set -eux; \
  curl -sSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o /tmp/terraform.zip; \
  unzip /tmp/terraform.zip -d /usr/local/bin; \
  rm -rf /tmp/terraform.zip; 

# Install awscli v2
RUN set -eux; \
 curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_V2_VERSION}.zip" -o "awscli-bundle.zip" && \
 unzip -q awscli-bundle.zip && \
 ./aws/install -i /usr/local/aws-cli -b /usr/local/bin && \
 rm -rf ./awscli-bundle*

# Install inspec tool 
RUN set -eux; \
  curl -L https://packages.chef.io/chef.asc | apt-key add - && \
  echo "deb https://packages.chef.io/repos/apt/stable buster main" > /etc/apt/sources.list.d/chef-stable.list && \
  apt-get update && apt-get install inspec -y

# Install conftest 
RUN set -eux; \
  curl -OL https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz && \
  tar -xzf conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz && \
  mv conftest /usr/local/bin && \
  rm -rf conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz

RUN set -eux; \
  apt-get purge -y --auto-remove $BUILD_DEB_PKGS; \
  apt-get clean; \
  rm -rf /var/lib/apt/lists/* /var/log/dpkg.log;

RUN ln -sf bash /bin/sh
RUN ln -sf python3 /usr/bin/python


COPY yaml2json /usr/local/bin
COPY yaml_to_wrapped_json.sh /usr/local/bin

# Just to silence pip warnings
RUN pip install --upgrade pip setuptools

##### Install python packages
COPY requirements.txt . 

RUN pip install -r requirements.txt
