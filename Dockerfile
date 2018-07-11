# Pull the base image with given version.
ARG BUILD_TERRAFORM_VERSION="0.11.1"
FROM microsoft/terraform-test:${BUILD_TERRAFORM_VERSION}

ARG MODULE_NAME="terraform-azurerm-database"

# Declare default build configurations for terraform.
ARG BUILD_ARM_SUBSCRIPTION_ID=""
ARG BUILD_ARM_CLIENT_ID=""
ARG BUILD_ARM_CLIENT_SECRET=""
ARG BUILD_ARM_TENANT_ID=""
ARG BUILD_ARM_TEST_LOCATION="WestEurope"
ARG BUILD_ARM_TEST_LOCATION_ALT="WestUS"

# Set environment variables for terraform runtime.
ENV ARM_SUBSCRIPTION_ID=${BUILD_ARM_SUBSCRIPTION_ID}
ENV ARM_CLIENT_ID=${BUILD_ARM_CLIENT_ID}
ENV ARM_CLIENT_SECRET=${BUILD_ARM_CLIENT_SECRET}
ENV ARM_TENANT_ID=${BUILD_ARM_TENANT_ID}
ENV ARM_TEST_LOCATION=${BUILD_ARM_TEST_LOCATION}
ENV ARM_TEST_LOCATION_ALT=${BUILD_ARM_TEST_LOCATION_ALT}

RUN mkdir /usr/src/${MODULE_NAME}
COPY . /usr/src/${MODULE_NAME}

WORKDIR /usr/src/${MODULE_NAME}
# RUN ["bundle", "install", "--gemfile", "./Gemfile"]
RUN ["apt-get", "install", "-y", "golang-go"]
RUN ["apt-get", "install", "-y", "unzip"]
RUN ["wget", "https://releases.hashicorp.com/terraform/0.11.1/terraform_0.11.1_linux_amd64.zip"]
RUN ["wget", "https://storage.googleapis.com/golang/go1.9.2.linux-amd64.tar.gz"]
RUN ["unzip", "terraform_0.11.1_linux_amd64.zip"]
RUN ["tar", "-zxvf", "go1.9.2.linux-amd64.tar.gz", "-C", "/usr/local/"]
RUN ["mv", "terraform", "/usr/local/bin"]
# RUN ["export", "GOPATH=$HOME/go"]
# RUN ["export", "PATH=$PATH:$GOROOT/bin:$GOPATH/bin"]
# RUN ["go", "get", "github.com/denisenkom/go-mssqldb"]
# RUN ["go", "get", "github.com/gruntwork-io/terratest/modules/retry"]
# RUN ["go", "get", "github.com/gruntwork-io/terratest/modules/terraform"]