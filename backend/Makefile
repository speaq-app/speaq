test:
	go install github.com/golang/mock/mockgen@v1.6.0
	go generate ./...
	go test -race -timeout 10s ./...

dev:
	docker-compose -p speaq-be-dev -f deployments/docker-compose.dev.yml up --renew-anon-volumes --force-recreate --remove-orphans

run:
	go run -race . -c ./configs/config.dev.yml

compile:
	go build .