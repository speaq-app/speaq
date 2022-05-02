#!/bin/bash

protoc --proto_path=/protos/ --go_out=/out/go --go-grpc_out=/out/go \
    /protos/resource.proto \
    /protos/user.proto \
    /protos/settings.proto \
    && \
protoc --proto_path=/protos/ --dart_out=grpc:/out/dart \
    /usr/local/protoc/include/google/protobuf/empty.proto \
    /protos/resource.proto \
    /protos/user.proto \
    /protos/settings.proto \