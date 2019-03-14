FROM golang:1.11 AS builder

COPY . /workdir
WORKDIR /workdir

RUN GO111MODULE=on go build -o apiserver


FROM ubuntu:18.04

EXPOSE 4567
EXPOSE 9000

COPY --from=builder /workdir/apiserver /usr/local/bin/apiserver

CMD apiserver
