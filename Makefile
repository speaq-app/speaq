.PHONY: protos

protos:
	docker build --force-rm -t protoc:dev -f Dockerfile.protoc .
	docker run --rm --name protoc \
		-v "${CURDIR}/protos:/protos" \
		-v "${CURDIR}/backend/internal:/out/go" \
		-v "${CURDIR}/frontend/lib/api/protos:/out/dart" \
		protoc:dev

protos-local:
	protoc --proto_path=protos/ \
		--go_out=backend/internal --go-grpc_out=backend/internal \
		--dart_out=grpc:frontend/lib/api/protos \
		protos/*.proto