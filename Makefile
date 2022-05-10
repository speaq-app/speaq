.PHONY: protos

clean:
	git clean -df

protos:
	docker build --force-rm -t protoc:dev -f Dockerfile.protoc .
	docker run --rm --name protoc \
		-v "${CURDIR}/protos:/protos" \
		-v "${CURDIR}/backend/internal:/out/go" \
		-v "${CURDIR}/frontend/lib/api/grpc/protos:/out/dart" \
		protoc:dev

build: protos
	cd backend && go get && make test
	cd frontend && flutter pub get && make hive

dev:
	docker-compose -p speaq-dev -f backend/deployments/docker-compose.dev.yml up --renew-anon-volumes --force-recreate --remove-orphans

test:
	docker-compose -p speaq-test up --renew-anon-volumes --force-recreate --remove-orphans
