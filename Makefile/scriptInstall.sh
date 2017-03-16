#!/bin/sh

echo Script was run...
# -- 1 -- Installing HomeBrew
#/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo HomeBrew:
which -s brew
if [[ $? != 0 ]] ; then
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
brew update
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
echo !!!! We cant find .git/hooks/ folder, contact vk.com/kirillzzy please
else
echo Hook moved
fi
}

if [ -d "../.git/hooks" ]; then
moveHook
else
mkdir ../.git/hooks
moveHook
fi
# -- 6 -- carthage update
echo Carthage:
cd ../
if [ ! -f "Cartfile" ]; then
  echo 'github "realm/realm-cocoa"' >> Cartfile
  echo Cartfile created
fi
carthage update --platform iOS
if [[ $? != 0 ]] ; then
echo !!!! We cant find Cartfile, contact vk.com/kirillzzy please
fi
echo Script was ended
