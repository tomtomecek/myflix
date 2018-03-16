#!/bin/bash

wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh

cat >~/.netrc <<EOF
machine api.heroku.com
  login $HEROKU_EMAIL
  password $HEROKU_API_TOKEN
machine git.heroku.com
  login $HEROKU_EMAIL
  password $HEROKU_API_TOKEN
EOF

heroku git:remote -a $HEROKU_APP