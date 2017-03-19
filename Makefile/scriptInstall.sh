#!/bin/sh

echo Script was run...
# -- 1 -- Installing HomeBrew
#/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo HomeBrew:
echo HomeBrew checking running...
which -s brew
if [[ $? != 0 ]] ; then
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo brew installed
else
brew update
echo brew updated
fi
# -- 2 -- Installing swiftLint
brew install swiftLint
# -- 3 -- Installing natalie
brew install natalie
# -- 4 -- Installing carthage
brew install carthage
# -- 5 -- move hook
echo Hook:
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd
cd $DIR

moveHook() {
cp prepare-commit-msg ../.git/hooks/
if [[ $? != 0 ]] ; then
echo !!!! We cant find .git/hooks/ folder, contact github.com/kirillzzy please
else
echo Hook moved
fi
}

if [ ! -d "../.git/hooks" ]; then
mkdir ../.git/hooks
fi
moveHook
# -- 6 -- carthage update
echo Carthage:
cd ../
if [ ! -f "Cartfile" ]; then
  touch Cartfile
  echo Cartfile created
fi
carthage update --platform iOS
echo carthage updated
echo "Now you should write necessary libs in Cartfile and run command 'carthage update --platform iOS'"

echo Script was ended
echo "Questions? Ask github.com/kirillzzy"
