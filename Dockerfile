FROM golang:1.18-alpine AS builder

ARG NEBULA_VERSION

ENV CGO_ENABLED 0
ENV GO111MODULE on
WORKDIR /tmp
RUN wget https://github.com/slackhq/nebula/archive/refs/tags/v${NEBULA_VERSION}.tar.gz -O nebula-${NEBULA_VERSION}.tar.gz
RUN tar xvfz nebula-${NEBULA_VERSION}.tar.gz
RUN cd nebula-${NEBULA_VERSION} && go mod tidy && go build -trimpath -o /tmp/nebula ./cmd/nebula && go build -trimpath -o /tmp/nebula-cert ./cmd/nebula-cert

FROM alpine:3.13
COPY --from=builder /tmp/nebula /usr/local/bin/nebula
COPY --from=builder /tmp/nebula-cert /usr/local/bin/nebula-cert
COPY entrypoint.sh /entrypoint.sh

WORKDIR /

ENTRYPOINT ["/entrypoint.sh"]