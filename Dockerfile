FROM ubuntu:focal
ENV DEBIAN_FRONTEND noninteractive
RUN  apt-get update -y && \
     apt-get -y install build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ tmux git jq wget libncursesw5 wget

WORKDIR /tmp
RUN  wget https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz 
RUN   tar -vJxf cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz && \
   rm cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz cabal.sig && \
   mv cabal /usr/local/bin/ 

RUN  wget https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-x86_64-deb9-linux.tar.xz 
RUN tar -Jxf ghc-8.6.5-x86_64-deb9-linux.tar.xz && \
     rm ghc-8.6.5-x86_64-deb9-linux.tar.xz && \
     cd ghc-8.6.5 &&  ./configure && make install

RUN rm -rf ghc-8.6.5 

RUN cabal update
RUN git clone https://github.com/input-output-hk/cardano-node.git
# /!\ TODO FIND SWEET SPOT FOR BUILD CACHING  
WORKDIR /tmp/cardano-node
RUN  git fetch --all --tags && \
 git checkout tags/1.14.0

#RUN cabal install cardano-node cardano-cli  --installdir=/usr/local/bin
RUN cabal install cardano-node cardano-cli  --installdir=/usr/local/bin --install-method=copy --overwrite-policy=always 
ENV PATH="/usr/local/bin:${PATH}"
RUN useradd -m cardano -s /bin/bash
RUN mkdir /data && chown cardano: /data
RUN apt-get install -y netcat net-tools
VOLUME /data
USER cardano
WORKDIR /home/cardano





