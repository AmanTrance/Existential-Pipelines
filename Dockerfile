FROM haskell:latest

RUN mkdir /build

WORKDIR /build

COPY . .

RUN cabal update

RUN cabal install --enable-static --enable-executable-static --disable-debug-info --installdir=./

RUN cp /build/existential /

CMD [ "sleep", "1d" ]
