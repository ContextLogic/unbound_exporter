FROM golang:1.10
WORKDIR /go/src/github.com/wish/unbound_exporter/
COPY unbound_exporter.go /go/src/github.com/wish/unbound_exporter/
RUN go get  -d ./...
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo .




FROM alpine:3.7
LABEL description="Prometheus Unbound exporter"
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=0 /go/src/github.com/wish/unbound_exporter/unbound_exporter .
CMD /root/unbound_exporter
