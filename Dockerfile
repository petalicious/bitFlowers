FROM debian:9 AS builder
COPY . /root/bitflowers/
WORKDIR /root/bitflowers/src/
RUN apt-get update && apt-get install -y build-essential libboost-all-dev libssl1.0-dev libdb-dev libdb++-dev zlib1g-dev
RUN make -j $(nproc) -f makefile.unix

FROM debian:9-slim
COPY --from=builder /root/bitflowers/src/bitFlowersd /usr/local/bin/bitFlowersd
RUN apt-get update && apt-get install -y libboost-filesystem1.62.0 libboost-system1.62.0 libboost-program-options1.62.0 libboost-thread1.62.0 libdb5.3++ libssl1.0
RUN bitFlowersd 2>/dev/null > /dev/null
RUN bitFlowersd 2>&1 | grep ^rpc >> ~/.bitFlowers/bitFlowers.conf
CMD ["/usr/local/bin/bitFlowersd"]
