export PROJECT_UI_TESTS_PATH=/home/circleci/project/planet4-uitests/

echo ""
echo "Adding git user email and user name"
echo ""
git config --global user.email "circleci-bot@greenpeace.org"
git config --global user.name "CircleCI Bot"
git config --global push.default simple

echo ""
echo "Cloning the planet4-uitests repository"
echo ""
git clone https://github.com/greenpeace/planet4-uitests

echo ""
echo "Commiting release tag in the repository"
echo ""
git tag -a ${CIRCLE_TAG} -m "${CIRCLE_TAG} version of the sql to use"

echo ""
echo "Pushing changes"
echo ""
git -C ${PROJECT_UI_TESTS_PATH} push origin ${CIRCLE_TAG}