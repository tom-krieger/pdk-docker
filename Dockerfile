FROM ubuntu:jammy-20230126

WORKDIR /root

ADD gf Gemfile 
ADD install-pdk-release.sh .
ADD install-onceover.sh .
ADD pdk-release.env .
# ADD pdk_2.7.1.0-1bionic_amd64.deb .
ADD pdk_3.0.1.3-1bionic_amd64.deb .

RUN apt-get update && \
    apt-get install -y curl openssh-client build-essential

# RUN dpkg -i pdk_2.7.1.0-1bionic_amd64.deb && \
#    rm -f pdk_2.7.1.0-1bionic_amd64.deb

RUN dpkg -i pdk_3.0.1.3-1bionic_amd64.deb && \
    rm -f pdk_3.0.1.3-1bionic_amd64.deb

# install onceover
RUN pdk_ruby_bindir="$(dirname "$(ls -dr /opt/puppetlabs/pdk/private/ruby/*/bin/gem | head -1)")" && \
    "${pdk_ruby_bindir}/gem" install --no-document onceover && \
    ln -s "${pdk_ruby_bindir}/onceover" /usr/local/bin/onceover && \
    ln -s "${pdk_ruby_bindir}/bundle" /usr/local/bin/bundle

# Prep a module to make sure we have all of
# the required dependencies.
RUN pdk new module docker --skip-interview && \
    cd docker && \
    pdk new class test && \
    pdk validate

RUN cp Gemfile docker && \
    cd docker && \
    pdk bundle install

RUN apt-get purge -y curl  && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="${PATH}:/opt/puppetlabs/pdk/private/git/bin"
ENV PDK_DISABLE_ANALYTICS=true
ENV LANG=C.UTF-8

ENTRYPOINT ["/opt/puppetlabs/pdk/bin/pdk"]
