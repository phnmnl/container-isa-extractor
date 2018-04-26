# Make sure this Docker file follow the PhenoMeNal Docker file guide at https://github.com/phnmnl/phenomenal-h2020/wiki/Dockerfile-Guide.
# Don't forget to update resource (CPU and memory) usage specifications in PhenoMeNal Galaxy container (see https://github.com/phnmnl/phenomenal-h2020/wiki/Setting-up-Galaxy-wrappers-on-PhenoMeNal-Galaxy-Container#tool-cpu-and-memory-usage-requests-and-limits) if necessary.

FROM ubuntu:16.04

MAINTAINER PhenoMeNal-H2020 Project ( phenomenal-h2020-users@googlegroups.com )

ENV TOOL_NAME=isa-extractor
ENV TOOL_VERSION=1.0.1
ENV CONTAINER_VERSION=1.0
ENV CONTAINER_GITHUB=https://github.com/phnmnl/container-isa-extractor

LABEL version="${CONTAINER_VERSION}"
LABEL software.version="${TOOL_VERSION}"
LABEL software="${TOOL_NAME}"
LABEL base.image="ubuntu:16.04"
LABEL description="Extracts collections of files from an ISA archive (mzML, mzData, netCDF, etc.)."
LABEL website="${CONTAINER_GITHUB}"
LABEL documentation="${CONTAINER_GITHUB}"
LABEL license="${CONTAINER_GITHUB}"
LABEL tags="Metabolomics"

# Update, install dependencies, clone repos and clean
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y software-properties-common git && \
    git clone --depth 1 --single-branch -b v${TOOL_VERSION} https://github.com/workflow4metabolomics/isa-extractor /files/isa-extractor && \
    apt-get purge -y git software-properties-common && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*

# Make tool accessible through PATH
ENV PATH=$PATH:/files/isa-extractor

# Make test script accessible through PATH
ENV PATH=$PATH:/files/isa-extractor/test

# Define Entry point script
ENTRYPOINT ["/files/isa-extractor/extract-from-isa"]
