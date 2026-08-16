# Load Angular CLI autocompletion.
source <(ng completion script)

# add go binary folder to the path variable
export PATH=$PATH:~/go/bin

# add local llm being served from localhost
# export ANTHROPIC_BASE_URL="http://localhost:8080/v1"
export CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH="$HOME/.local/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# node 22 (brew keg-only formula) ahead of the pkg-installed node 18 in /usr/local/bin
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"

# times
export today="$(date +%Y-%m-%d)"
export now="$(date +%Y-%m-%dT%H-%M-%S)"
