.PHONY: protos

protos:
	protoc --proto_path=protos/ \
		--go_out=backend/internal --go-grpc_out=backend/internal \
		--dart_out=grpc:frontend/lib/api/protos \
		protos/*.proto