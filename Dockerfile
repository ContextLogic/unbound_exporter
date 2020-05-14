FROM --platform=$BUILDPLATFORM golang:1.14

ARG BUILDPLATFORM
ARG TARGETARCH
ARG TARGETOS

ENV GO111MODULE=on
WORKDIR /go/src/github.com/kumina/unbound_exporter

# Cache dependencies
COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . /go/src/github.com/kumina/unbound_exporter/

RUN CGO_ENABLED=0 GOARCH=${TARGETARCH} GOOS=${TARGETOS} go build -o ./unbound_exporter -a -installsuffix cgo .

FROM alpine:3.11
LABEL description="Prometheus Unbound exporter"
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=0 /go/src/github.com/kumina/unbound_exporter/unbound_exporter /root/unbound_exporter
CMD /root/unbound_exporter
