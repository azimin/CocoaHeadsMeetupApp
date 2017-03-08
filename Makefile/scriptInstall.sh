#!/bin/sh

echo Script was run...
# -- 1 -- Installing HomeBrew
#/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

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
cp prepare-commit-msg ../.git/hooks/
if [[ $? != 0 ]] ; then
echo !!!!___ We cant find .git/hooks/ folder ___
fi

# -- 6 -- carthage update
cd ../
carthage update --platform iOS
if [[ $? != 0 ]] ; then
echo !!!!___ We cant find Cartfile ___
fi

echo Script was ended
