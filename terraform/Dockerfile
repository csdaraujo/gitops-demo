FROM ubuntu:20.04

ENV TERRAFORM_VERSION 0.13.5

RUN apt update && apt install -y ca-certificates wget unzip --no-install-recommends
RUN wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip --no-check-certificate
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin/ && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

ARG ENV

COPY ./demo-api/ /terraform/demo-api/
COPY ./${ENV}/ /terraform/${ENV}/

WORKDIR /terraform/${ENV}

CMD terraform init -backend-config=./backend.tfvars && terraform validate && terraform apply -auto-approve
