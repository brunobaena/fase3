FROM golang:1.26.5-alpine AS builder

WORKDIR /app

COPY go.mod .
COPY *.go .

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    go mod tidy

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 go build -ldflags="-s -w" -o evaluation-service .

FROM alpine:3.22

RUN apk add --no-cache ca-certificates \
    && addgroup -S app && adduser -S -G app app \
    && chmod 755 /root

WORKDIR /app

COPY --from=builder /app/evaluation-service .

ENV HOME=/root

USER app

EXPOSE 8004

CMD ["./evaluation-service"]
