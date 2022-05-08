FROM alpine:3.15

ENV BAUD=38400
ENV DEV=/dev/ttyS0
ENV IP_SERVER=10.0.1.1
ENV IP_CLIENT=10.0.1.2
ENV PPP_PHONE=5559000

RUN apk update && apk --no-cache add ppp iptables dnsmasq
WORKDIR /
RUN apk add --no-cache build-base git && \
    git clone https://github.com/FozzTexx/tcpser.git && \
    cd tcpser && \
    sed -i '4 i#include <sys/select.h>' src/ip232.c && \
    make && \
    cp tcpser /usr/bin/ && \
    cd .. && \
    rm -Rf tcpser && \
    apk del build-base git
COPY start.sh /start.sh
COPY ppp_options /ppp_options
COPY pap-secrets /etc/ppp/pap-secrets
RUN chmod +x /start.sh

CMD ["/start.sh"]
