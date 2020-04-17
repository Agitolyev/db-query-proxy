FROM debian:buster-slim as build

RUN apt-get update
RUN apt-get install -y qt4-default qt4-dev-tools make
RUN apt-get install -y g++

COPY . /db-query-proxy

WORKDIR /db-query-proxy/src
RUN qmake-qt4
RUN make

FROM gcr.io/distroless/base-debian10:debug
COPY --from=build /db-query-proxy/etc/db-query-proxy.conf /etc
COPY --from=build /db-query-proxy/bin/db-query-proxy /app/
WORKDIR /app

ENTRYPOINT [ "./db-query-proxy" ]