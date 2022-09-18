FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev python3-dev
RUN git clone https://github.com/uncrustify/uncrustify.git
WORKDIR /uncrustify
RUN mkdir ./build
WORKDIR /uncrustify/build
RUN cmake -DCMAKE_C_COMPILER=afl-clang -DCMAKE_CXX_COMPILER=afl-clang++ ..
RUN make
RUN mkdir /uncfgCorpus
RUN cp /uncrustify/tests/config/c/*.cfg /uncfgCorpus

ENTRYPOINT ["afl-fuzz", "-i", "/uncfgCorpus", "-o", "/uncrustifyOut"]
CMD  ["/uncrustify/build/uncrustify", "-c", "@@", "-f", "/uncrustify/tests/input/c/brace.c"]
