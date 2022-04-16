.PHONY: protos

protos:
	docker build --force-rm -t protoc:dev -f Dockerfile.protoc .
	docker run --rm --name protoc \
		-v "${CURDIR}/protos:/protos" \
		-v "${CURDIR}/backend/internal:/out/go" \
		-v "${CURDIR}/frontend/lib/api/protos:/out/dart" \
		protoc:dev

build: protos
	cd backend && go get
	cd frontend && flutter pub get

dev:
	docker-compose -p speaq -f backend/deployments/docker-compose.dev.yml up --renew-anon-volumes --force-recreate --remove-orphans
