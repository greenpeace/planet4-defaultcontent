export PROJECT_DOCKER_COMPOSE_PATH=/home/circleci/project/planet4-docker-compose/

echo ""
echo "Adding git user email and user name"
echo ""
git config --global user.email "circleci-bot@greenpeace.org"
git config --global user.name "CircleCI Bot"
git config --global push.default simple

echo ""
echo "Cloning the planet4-docker-compose repository"
echo ""
git clone https://github.com/greenpeace/planet4-docker-compose

echo ""
echo "Replacing the previous sql file in the Dockerfile tag with the latest one"
echo ""
sed -i "s/DEFAULTCONTENT_DB_VERSION ?= .*./DEFAULTCONTENT_DB_VERSION ?= ${CIRCLE_TAG}/g" ${PROJECT_DOCKER_COMPOSE_PATH}Makefile

echo ""
echo "Commiting changes in the repository"
echo ""
git -C ${PROJECT_DOCKER_COMPOSE_PATH} commit -m "${CIRCLE_TAG} version of the sql to use" Makefile

echo ""
echo "Pushing changes"
echo ""
git -C ${PROJECT_DOCKER_COMPOSE_PATH} push