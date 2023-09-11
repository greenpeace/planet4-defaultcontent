#!/usr/bin/env bash
export PROJECT="planet4-builder"
export PROJECT_PATH="/home/circleci/project/${PROJECT}/"

echo ""
echo "Adding git user email and user name"
echo ""
git config --global user.email "circleci-bot@greenpeace.org"
git config --global user.name "CircleCI Bot"
git config --global push.default simple

echo ""
echo "Cloning the {$PROJECT} repository"
echo ""
git clone https://github.com/greenpeace/${PROJECT}

echo ""
echo "Replacing the previous sql version in the reset script with the latest one"
echo ""
CIRCLE_TAG_NUMBER=${CIRCLE_TAG#"v"}
sed -i "s/CONTENT_DB_VERSION=\".*./CONTENT_DB_VERSION=\"${CIRCLE_TAG_NUMBER}\"/g" ${PROJECT_PATH}src/bin/reset_test_instance.sh

echo ""
echo "Commiting changes in the repository"
echo ""
git -C ${PROJECT_PATH} commit -m "${CIRCLE_TAG} version of the sql to use" src/bin/reset_test_instance.sh

echo ""
echo "Pushing changes"
echo ""
git -C ${PROJECT_PATH} push
