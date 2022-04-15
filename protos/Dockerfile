FROM golang:1.18-bullseye
RUN apt update && \
    apt install -y protobuf-compiler
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28 && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
RUN export PATH="$PATH:$(go env GOPATH)/bin"
WORKDIR /
ENTRYPOINT [ "protoc", "--proto_path=protos/", "--go_out=out", "--go-grpc_out=out", "protos/resource.proto" ]