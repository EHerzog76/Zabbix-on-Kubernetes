ARG BASEOS=ubi8
ARG BASEVER=0
ARG PG_FULL=13.7
FROM registry.developers.crunchydata.com/crunchydata/crunchy-postgres:${BASEOS}-${PG_FULL}-${BASEVER}
#FROM registry.developers.crunchydata.com/crunchydata/crunchy-postgres:ubi8-13.7-0

# For RHEL8 all arguments used in main code has to be specified after FROM
ARG PG_FULL=13.7
ARG BASEOS=ubi8
ARG PACKAGER=microdnf

# ===== Early lines ordered for leveraging cache, reorder carefully =====
ARG PG_MAJOR=13

USER  root

COPY timescaledb.repo /etc/yum.repos.d/timescale_timescaledb.repo

RUN  ${PACKAGER} --disablerepo=epel --disablerepo=crunchypg${PG_MAJOR} update -y &&  \
${PACKAGER} --disablerepo=epel --disablerepo=crunchypg${PG_MAJOR} install --nodocs -y timescaledb-2-postgresql-${PG_MAJOR} timescaledb-2-loader-postgresql-${PG_MAJOR} &&  \
${PACKAGER} -y clean all --enablerepo="epel" --enablerepo=crunchypg${PG_MAJOR}

USER 26
