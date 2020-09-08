all:
	go fmt ./...
	docker run \
		-e VALUES=iam.tag=foo,iam.image=bar \
		-e VALUES_FILE=apps/values.yaml \
		-e DRY_RUN=1 \
		--rm $$(docker build -q .)
