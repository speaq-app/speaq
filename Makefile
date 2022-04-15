.PHONY: protos

protos:
	docker-compose -p protos -f protos/docker-compose.yml build --force-rm
	docker-compose -p protos -f protos/docker-compose.yml up --force-recreate --remove-orphans

protos-local:
	protoc --proto_path=protos/ \
		--go_out=backend/internal --go-grpc_out=backend/internal \
		--dart_out=grpc:frontend/lib/api/protos \
		protos/*.proto