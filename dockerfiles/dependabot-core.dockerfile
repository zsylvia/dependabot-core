FROM dependabot/engine-base

# Install Ruby 2.5, update RubyGems, and install Bundler
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C3173AA6 \
    && echo "deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu bionic main" > /etc/apt/sources.list.d/brightbox.list \
    && apt-get update \
    && apt-get install -y ruby2.5 ruby2.5-dev \
    && gem update --system 2.7.7 \
    && gem install --no-ri --no-rdoc bundler -v 2.0.0.pre.1

RUN useradd -m dependabot
WORKDIR /home/dependabot

COPY --from=dependabot/engine-python --chown=dependabot /opt/engines/python /opt/engines/python
RUN echo "source '/opt/engines/python/env'" >> "$HOME/.bashrc"
