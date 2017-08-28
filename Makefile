SHA := awk '/Successfully built/ { sha=$$3 } END { print sha }'

websocketd: docker-build.log
	$(SHA) $< | xargs -I {} docker run --rm -t {} /bin/sh -c 'sleep 30' &
	docker ps -l -q | xargs -I {} docker cp {}:/go/bin/websocketd .

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
