FROM alpine:latest as BUILDER
RUN apk add build-base curl git openssl-dev zlib-dev musl-dev linux-headers
RUN git clone --single-branch --depth 1 https://github.com/randomnerd/MTProxy.git /mtproxy
WORKDIR /mtproxy
RUN make -j$(getconf _NPROCESSORS_ONLN)
RUN mv objs/bin/mtproto-proxy /

FROM alpine:latest
COPY --from=BUILDER /mtproto-proxy /usr/bin/mtproto-proxy
RUN apk --no-cache add curl ca-certificates
EXPOSE 2398 443
VOLUME /data
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
