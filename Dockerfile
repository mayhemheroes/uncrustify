FROM fuzzers/afl:2.52 as builder

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev python3-dev
ADD . /uncrustify
WORKDIR /uncrustify
RUN mkdir ./build
WORKDIR /uncrustify/build
RUN cmake -DCMAKE_C_COMPILER=afl-clang -DCMAKE_CXX_COMPILER=afl-clang++ ..
RUN make

FROM fuzzers/afl:2.52
COPY --from=builder /uncrustify/build/uncrustify /
COPY --from=builder /uncrustify/tests/config/c/*.cfg /testsuite/
COPY --from=builder /uncrustify/tests/input/c/brace.c /

ENTRYPOINT ["afl-fuzz", "-i", "/testsuite", "-o", "/uncrustifyOut"]
CMD  ["/uncrustify", "-c", "@@", "-f", "/brace.c"]
