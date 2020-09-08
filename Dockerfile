FROM golang:1.15-alpine3.12 as bin

ARG cmd

WORKDIR /src

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY main.go main.go

RUN go install .

FROM alpine:3.12

RUN apk add git

COPY --from=bin /go/bin/demo20-gitops-plugin /usr/local/bin/app

COPY plugin.sh plugin.sh

RUN chmod u+x ./plugin.sh
RUN chmod u+x /usr/local/bin/app

ENTRYPOINT ["./plugin.sh"]
