dev:
	docker-compose -p speaq-fe-dev -f ../backend/deployments/docker-compose.test.yml up --renew-anon-volumes --force-recreate --remove-orphans

hive: 
	flutter packages pub run build_runner build

gen:
	flutter packages pub run build_runner build
	protoc --proto_path=../protos/ --dart_out=grpc:lib/api/grpc/protos/ \
		google/protobuf/empty.proto \
		../protos/*.proto

compile:
	flutter build apk