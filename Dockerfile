FROM golang:latest

RUN go get github.com/joewalnes/websocketd

CMD ["su", "-", "tripleee"]
