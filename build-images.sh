docker build -t dependabot/engine-base   -f dockerfiles/engine-base.dockerfile   .
docker build -t dependabot/engine-python -f dockerfiles/engine-python.dockerfile .
docker build -t dependabot/dependabot-core-new -f dockerfiles/dependabot-core.dockerfile .

#docker build -t dependabot/dependabot-core-base -f images/dependabot-core-base.dockerfile images
#docker build -t dependabot/dependabot-core-full -f images/dependabot-core-full.dockerfile .
