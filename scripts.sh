SOURCE_DIR="$(pwd)"

THEME_DIRECTORY='hello-friend'
THEME_BUILD='npm run build'
SERVE_BLOG='hugo serve .-d'
BUILD_THEME="cd $SOURCE_DIR/themes/$THEME_DIRECTORY && $THEME_BUILD"

# bash scripts.sh [-b, -build]
if [[ -n "$1" ]]; then
    eval "$BUILD_THEME && cd $SOURCE_DIR"
fi
eval "$SERVE_BLOG"