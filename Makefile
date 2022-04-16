.PHONY: protos

dev: protos
	cd backend && go get
	cd frontend && flutter pub get

protos:
	docker build --force-rm -t protoc:dev -f Dockerfile.protoc .
	docker run --rm --name protoc \
		-v "${CURDIR}/protos:/protos" \
		-v "${CURDIR}/backend/internal:/out/go" \
		-v "${CURDIR}/frontend/lib/api/protos:/out/dart" \
		protoc:dev
