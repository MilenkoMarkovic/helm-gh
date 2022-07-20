FROM golang:1.17.5-alpine3.15 as build
WORKDIR /source
COPY . .
ARG VER
RUN CGO_ENABLED=0 go build -ldflags "-s -w -X main.ver=${VER}" -o rest main.go
 
FROM alpine:3.15
COPY --from=build /source/rest /rest
EXPOSE 8080
ENTRYPOINT ["./rest"]
