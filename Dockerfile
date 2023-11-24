FROM ubuntu:22.04

LABEL maintainer="a-mymt"

ARG GITHUB_USER_NAME
ARG GITHUB_USER_EMAIL
ARG GITHUB_USER_TOKEN
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY

ENV AWS_ACCESS_KEY_ID ${AWS_ACCESS_KEY_ID}
ENV AWS_SECRET_ACCESS_KEY ${AWS_SECRET_ACCESS_KEY}
ENV N_PREFIX ${HOME}/.n
ENV PATH ${N_PREFIX}/bin:$PATH

EXPOSE 3000/tcp

# install package
RUN apt update && apt upgrade -y
RUN apt install -y git python3 python3-pip golang-go vim zip less curl unzip sudo nodejs npm
RUN apt autoremove -y &&\
    apt clean &&\
    rm -rf /usr/local/src/*

# install nodejs & use nodejs@latest
RUN npm install -g n next
RUN n stable && n latest

# install aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2
.zip"
RUN unzip awscliv2.zip
RUN sudo ./aws/install
RUN sudo pip install aws-sam-cli

# clone training repository
WORKDIR /work

RUN git config --global user.name ${GITHUB_USER_NAME}
RUN git config --global user.email ${GITHUB_USER_EMAIL}
RUN git clone https://${GITHUB_USER_NAME}:${GITHUB_USER_TOKEN}@github.com/a-mymt
/golang-training-1.git
RUN git clone https://${GITHUB_USER_NAME}:${GITHUB_USER_TOKEN}@github.com/a-mymt
/nextjs-training-1.git

# install module nextjs-training
WORKDIR nextjs-training-1
RUN npm install
