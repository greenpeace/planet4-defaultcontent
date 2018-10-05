export PROJECT_NRO_GEN_PATH = /home/circleci/project/planet4-nro-generator/

git --global config user.email "circleci-bot@greenpeace.org"
git --global config user.name "CircleCI Bot"

git clone https://github.com/greenpeace/planet4-nro-generator

sed -i "s/planet4-defaultcontent_wordpress-.*.sql/planet4-defaultcontent_wordpress-v${CIRCLE_TAG}.sql/g" ${PROJECT_NRO_GEN_PATH}Dockerfile


git -C ${PROJECT_NRO_GEN_PATH} commit -m "${CIRCLE_TAG} version of the sql to use" Dockerfile


git -C ${PROJECT_NRO_GEN_PATH} push