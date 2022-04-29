.PHONY: build test deploy db-migration codegen dirty-check build-deploy lint

build:
	@go mod tidy -compat=1.18

	@goreleaser --snapshot --rm-dist

single:
	@go mod tidy -compat=1.18

	@goreleaser build --snapshot --rm-dist --id=$(id)

dirty-check:
	# Ensures no files have been changed (used in ci)
	@git diff HEAD
	@git diff --stat HEAD | xargs -0 cat
	@git diff --quiet HEAD

lint:
	@go mod tidy -compat=1.18
	@go fmt ./...
	@go vet ./...
	
test:
	@go test ./...

deploy: 
	@sls deploy --verbose

db-migration:
	@go run ./cmd/ent-migrate/main.go

codegen:
	@go generate ./ent
	@go generate ./api/rest/v1

build-deploy: build deploy
