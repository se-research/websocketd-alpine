SHA := awk '/Successfully built/ { sha=$$3 } END { print sha }'

# FIXME: MacOS wants base64 -D while GNU wants base64 -d
websocketd: docker-build.log
	$(SHA) $< | xargs -I {} docker run --rm -t {} /bin/sh -c \
		'base64 /go/bin/$@ ' | base64 -D >$@
	chmod 755 $@

docker-build.log: Dockerfile
	docker build . | tee $@


.PHONY: clean realclean distclean
clean:
	$(RM) websocketd
realclean: clean
	$(RM) docker-build.log
distclean: realclean
	docker image ls -q golang:latest \
	| xargs -I {} docker images --filter since={} -q \
	| xargs docker inspect --format='{{.Id}}' \
	| xargs docker rmi
