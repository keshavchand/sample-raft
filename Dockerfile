from golang:1.21 as builder

WORKDIR /go/
ENV GOPATH /build/
COPY go.mod go.sum ./
RUN go mod tidy
COPY . ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /build/main .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /build/main .
