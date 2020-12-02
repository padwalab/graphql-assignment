# Build the cipher service binary
FROM golang:1.13.5-stretch as base

# add the working directory for the project
WORKDIR /go/src/github.com/padwalab/graphql-assignment

# Copy the service code
COPY graph graph
COPY internal internal
COPY server.go .
COPY gqlgen.yml .
COPY db.sh .
COPY vendor vendor
COPY go.mod go.mod
COPY go.sum go.sum

RUN ./db.sh

# building service binary at path discovergy/www
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GOFLAGS=-mod=vendor go build -o ./bin/graphql server.go

## Using the multi-stage image to just run the binary
FROM alpine:latest as final

# Init working directory to root /
WORKDIR /

# Copy just the binary from the base image
COPY --from=base /go/src/github.com/padwalab/graphql-assignment/bin/graphql .

# just an indication that this port will be exposed by this container
EXPOSE 8080

# command to run at the immediate start of the container
ENTRYPOINT ["./graphql"]
