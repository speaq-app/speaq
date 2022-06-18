FROM golang:1.18-bullseye AS builder
LABEL stage=intermediate
COPY backend/ /speaq/backend
COPY protos/ /speaq/protos
WORKDIR /speaq
RUN apt update && \
    apt install -y curl unzip

ENV PB_REL="https://github.com/protocolbuffers/protobuf/releases"
ENV PB_VER="3.4.0"
RUN curl -LO $PB_REL/download/v$PB_VER/protoc-$PB_VER-linux-x86_64.zip && \
    unzip protoc-$PB_VER-linux-x86_64.zip -d /usr/local/protoc
ENV PATH="$PATH:/usr/local/protoc/bin"
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28 && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2

RUN protoc --proto_path=protos/ --go_out=backend/internal --go-grpc_out=backend/internal protos/*.proto
ENV GO111MODULE=on
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /main backend/

FROM alpine:latest
LABEL maintainer="Hendrik Jonas Schlehlein <hendrik.schlehlein@gmail.com>"
LABEL org.opencontainers.image.source https://github.com/speaq-app/speaq
RUN apk --no-cache add ca-certificates
WORKDIR /
COPY --from=builder /main ./
RUN chmod +x ./main
ENTRYPOINT [ "./main" ]