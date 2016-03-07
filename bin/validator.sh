#!/usr/bin/env bash

SCORE=${SCORE:-40}

if [[ -z $GITDIFF ]]; then
  ruby_files="lib/ spec/"
  app_files="lib/"
else
  ruby_files=`git diff --diff-filter ACMRTUXB --name-only $GITDIFF lib/ spec/ | xargs`
  app_files=`git diff --diff-filter ACMRTUXB --name-only $GITDIFF lib/ | xargs`
fi

echo -e "\n\n\nCode style guide compliance results\n"
bundle exec warder --style-guide --stats $ruby_files
style_guide_exit_code=$?

echo -e "\n\n\nMagic numbers results\n"
bundle exec warder --magick-numbers --stats $app_files
magick_numbers_exit_code=$?

echo -e "\n\n\nCode duplication results\n"
bundle exec warder --code-duplication --stats $app_files
code_duplication_exit_code=$?

echo -e "\n\n\nCode complexity results\n"
bundle exec warder --code-complexity --stats $app_files
code_complexity_exit_code=$?

echo -e "\n\n\nCode smells detector result\n"
bundle exec warder --code-smell --stats $app_files
code_smells_exit_code=$?

if [[ -z $GITREF ]]; then
  exit $(($style_guide_exit_code+$magick_numbers_exit_code+$code_smells_exit_code)); # +$code_complexity_exit_code+$code_duplication_exit_code
else
  exit 0; # $(($style_guide_exit_code+$magick_numbers_exit_code+$code_complexity_exit_code+$code_smells_exit_code+$code_duplication_exit_code));
fi
