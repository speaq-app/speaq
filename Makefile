.PHONY: protos

protos:
	protoc --proto_path protos/ --go_out backend/internal --dart_out frontend/lib/api protos/*.proto