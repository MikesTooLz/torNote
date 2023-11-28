FROM golang:alpine AS build
MAINTAINER Vladimir Osintsev <osintsev@gmail.com>

WORKDIR /go/src/app
COPY . .
RUN go install -v ./...

FROM alpine
COPY --from=build /go/src/app/templates /templates
COPY --from=build /go/src/app/public /public
COPY --from=build /go/bin/tornote /usr/bin/tornote

ENV DATABASE_URL='postgres://User:Password@DatabaseName?sslmode=disable'
ENV PRODUCTION=true
ENV DATABASE_NAME=database
ENV SECRET_KEY=123456789

RUN apk add --no-cache curl
HEALTHCHECK CMD curl -sS http://localhost:8000/healthz || exit 1

EXPOSE 8000

CMD ["tornote"]
