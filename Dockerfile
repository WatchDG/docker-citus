FROM citusdata/citus:9
RUN apt-get update && apt-get install -y wget make gcc protobuf-c-compiler libprotobuf-c-dev postgresql-server-dev-12 \
&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /build && cd /build \
&& wget https://github.com/citusdata/cstore_fdw/archive/v1.7.0.tar.gz -O cstore_fdw.tar.gz \
&& tar xf cstore_fdw.tar.gz --strip-components=1 && make && make install && rm -rf /build

RUN mkdir -p /build && cd /build \
&& wget https://github.com/pgpartman/pg_partman/archive/v4.3.0.tar.gz -O partman.tar.gz \
&& tar xf partman.tar.gz --strip-components=1 && make install && rm -rf /build

RUN apt-get remove -y --purge --auto-remove wget make gcc protobuf-c-compiler libprotobuf-c-dev postgresql-server-dev-12

RUN sed -i -E "s/^shared_preload_libraries='citus'/shared_preload_libraries='citus, cstore_fdw, pg_partman_bgw, pg_stat_statements'/" /usr/share/postgresql/postgresql.conf.sample && \
echo "pg_partman_bgw.dbname='postgres'" >> /usr/share/postgresql/postgresql.conf.sample && \
echo "pg_partman_bgw.interval=86400" >> /usr/share/postgresql/postgresql.conf.sample && \
echo "pg_partman_bgw.role='partman'" >> /usr/share/postgresql/postgresql.conf.sample && \
echo "pg_partman_bgw.analyze='off'" >> /usr/share/postgresql/postgresql.conf.sample && \
echo "pg_partman_bgw.jobmon='off'" >> /usr/share/postgresql/postgresql.conf.sample
