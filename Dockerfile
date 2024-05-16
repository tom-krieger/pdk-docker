FROM ruby:3.0.6-bullseye

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y curl build-essential cmake openssh-client

# install onceover
RUN gem install puppet -v 7.27.0
RUN gem install puppetlabs_spec_helper -v 6.0.1
RUN gem install rspec-puppet -v 3.0.0
RUN gem install --no-document onceover
RUN gem install --no-document onceover-codequality
RUN gem install --no-document onceover-octocatalog-diff
RUN gem install --no-document onceover-lookup
RUN gem install --no-document pry
RUN gem install --no-document ra10ke
RUN gem install --no-document rest-client
RUN gem install --no-document hiera-eyaml
RUN gem install --no-document toml
RUN gem install --no-document toml-rb
RUN gem uninstall rspec-puppet -v 4.0.1

RUN apt-get purge -y curl  && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /root/.ssh
ADD ssh-config /root/.ssh/config
ADD id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

CMD /bin/bash
