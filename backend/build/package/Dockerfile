FROM golang:1.18 AS api-builder
LABEL stage=intermediate
COPY . /backend
WORKDIR /backend
ENV GO111MODULE=on
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /backend .

FROM alpine:latest
LABEL maintainer="Hendrik Jonas Schlehlein <hendrik.schlehlein@gmail.com>"
LABEL org.opencontainers.image.source https://github.com/speaq-app/speaq
RUN apk --no-cache add ca-certificates
WORKDIR /
COPY --from=api-builder /backend /
RUN chmod +x ./backend
ENTRYPOINT [ "./backend" ]