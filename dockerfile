FROM golang:1.22 AS builder

WORKDIR /usr/src/app

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod ./
RUN go mod download && go mod verify

COPY . .
RUN go build -v -o /usr/local/bin/app ./...

FROM scratch

WORKDIR /usr/src/app

COPY --from=builder /usr/local/bin/app /usr/local/bin/app

CMD ["app"]