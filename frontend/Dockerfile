FROM debian:bookworm AS builder
RUN apt update && \
    apt install -y git curl unzip make zip file xz-utils which

ENV PB_REL="https://github.com/protocolbuffers/protobuf/releases"
ENV PB_VER="3.4.0"
RUN curl -LO $PB_REL/download/v$PB_VER/protoc-$PB_VER-linux-x86_64.zip && \
    unzip protoc-$PB_VER-linux-x86_64.zip -d /usr/local/protoc
ENV PATH="$PATH:/usr/local/protoc/bin"

RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter
ENV PATH="$PATH:/usr/local/flutter/bin"
RUN dart pub global activate protoc_plugin
ENV PATH="$PATH:/root/.pub-cache/bin"

COPY frontend/ /speaq/frontend
COPY protos/ /speaq/protos
WORKDIR /speaq
RUN ls protos/

RUN protoc --proto_path=protos/ --dart_out=grpc:frontend/lib/api/grpc/protos/ \
    google/protobuf/empty.proto \
    protos/*.proto
RUN flutter packages pub run build_runner build
RUN flutter build web

FROM nginx:1.21.1-alpine
COPY --from=builder /speaq/app/build/web /usr/share/nginx/html