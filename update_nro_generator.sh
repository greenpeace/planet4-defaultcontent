export PROJECT_NRO_GEN_PATH=/home/circleci/project/planet4-nro-generator/

echo ""
echo "Adding git user email and user name"
echo ""
git config --global user.email "circleci-bot@greenpeace.org"
git config --global user.name "CircleCI Bot"

echo ""
echo "Cloning the planet4-nro-generator repository"
echo ""
git clone https://github.com/greenpeace/planet4-nro-generator

echo ""
echo "Replacing the previous sql file in the Dockerfile tag with the latest one"
echo ""
sed -i "s/planet4-defaultcontent_wordpress-.*.sql/planet4-defaultcontent_wordpress-v${CIRCLE_TAG}.sql/g" ${PROJECT_NRO_GEN_PATH}Dockerfile

echo ""
echo "Commiting changes in the repository"
echo ""
git -C ${PROJECT_NRO_GEN_PATH} commit -m "${CIRCLE_TAG} version of the sql to use" Dockerfile

echo ""
echo "Pushing changes"
echo ""
git -C ${PROJECT_NRO_GEN_PATH} push