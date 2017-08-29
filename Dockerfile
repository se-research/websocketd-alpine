FROM golang:latest

# Use static linking, as suggested here:
# http://www.blang.io/posts/2015-04_golang-alpine-build-golang-binaries-for-alpine-linux/
ENV CGO_ENABLED 0
RUN go get github.com/joewalnes/websocketd

CMD ["su", "-", "tripleee"]
