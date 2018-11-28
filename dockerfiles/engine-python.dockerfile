FROM dependabot/engine-base

COPY helpers/python/setup /dependabot/
RUN /dependabot/setup /opt/engines/python

COPY helpers/python/build /dependabot/
COPY helpers/python/requirements.txt /dependabot/
RUN /dependabot/build /opt/engines/python
