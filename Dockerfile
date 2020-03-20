FROM citusdata/citus:9
RUN apt-get update && apt-get install -y wget make gcc protobuf-c-compiler libprotobuf-c-dev postgresql-server-dev-12 \
&& mkdir -p /build && cd /build \
&& wget https://github.com/citusdata/cstore_fdw/archive/v1.7.0.tar.gz -O cstore_fdw.tar.gz \
&& tar xf cstore_fdw.tar.gz --strip-components=1 && make && make install && rm -rf /build \
&& mkdir -p /build && cd /build \
&& wget https://github.com/pgpartman/pg_partman/archive/v4.3.0.tar.gz -O partman.tar.gz \
&& tar xf partman.tar.gz --strip-components=1 && make install && rm -rf /build \
&& apt-get remove -y --purge --auto-remove wget make gcc postgresql-server-dev-12 \
&& rm -rf /var/lib/apt/lists/*
