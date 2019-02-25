FROM golang:1.11 AS builder

COPY . /workdir
WORKDIR /workdir

RUN go build


FROM ubuntu:18.04

EXPOSE 4567

COPY --from=builder /work/apiserver /usr/local/bin/apiserver

CMD apiserver
