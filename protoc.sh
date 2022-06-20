#!/bin/bash

protoc --proto_path=/protos/ --go_out=/out/go --go-grpc_out=/out/go \
    /protos/*.proto \
    && \
protoc --proto_path=/protos/ --dart_out=grpc:/out/dart \
    /usr/local/protoc/include/google/protobuf/empty.proto \
    /protos/*.proto