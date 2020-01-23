FROM citusdata/citus:9.1

RUN apt-get update && apt-get install -y make postgresql-server-dev-12 gcc wget
RUN mkdir -p /build && cd /build && wget https://github.com/pgpartman/pg_partman/archive/v4.2.2.tar.gz && \
tar xf v4.2.2.tar.gz && cd pg_partman-4.2.2 && make install && rm -rf /build && \
apt-get purge -y --auto-remove make postgresql-server-dev-12 gcc wget && rm -rf /var/lib/apt/lists/*

RUN sed -i -E "s/^shared_preload_libraries='citus'/shared_preload_libraries='citus, pg_partman_bgw, pg_stat_statements'/" /usr/share/postgresql/postgresql.conf.sample && \
echo "pg_partman_bgw.dbname='postgres'" >> /usr/share/postgresql/postgresql.conf.sample && \
echo "pg_partman_bgw.interval=3600" >> /usr/share/postgresql/postgresql.conf.sample && \
echo "pg_partman_bgw.role='postgres'" >> /usr/share/postgresql/postgresql.conf.sample && \
echo "pg_partman_bgw.analyze='off'" >> /usr/share/postgresql/postgresql.conf.sample && \
echo "pg_partman_bgw.jobmon='off'" >> /usr/share/postgresql/postgresql.conf.sample
