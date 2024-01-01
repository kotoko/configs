# This is a theme for gitprompt.sh,
# it uses the default Gentoo bash prompt style.

# Mixed with: https://maximomussini.com/posts/bash-git-prompt/


override_git_prompt_colors() {
  Bold="\e[1m"
  Orange="\e[38;5;208m"
  BoldOrange="${Bold}${Orange}"

  GIT_PROMPT_THEME_NAME="Custom_Gentoo_Emoji"
  GIT_PROMPT_BRANCH="${Cyan}"
  GIT_PROMPT_MASTER_BRANCH="${GIT_PROMPT_BRANCH}"

  # Add a few emojis to make it fun!
  GIT_PROMPT_STAGED="${BoldYellow}👍${ResetColor}"
  GIT_PROMPT_CONFLICTS="${BoldRed}❌ ${ResetColor}"
  GIT_PROMPT_CHANGED="${BoldOrange}🖉 ${ResetColor}"
  GIT_PROMPT_UNTRACKED="${BoldMagenta}❔ ${ResetColor}"
  GIT_PROMPT_STASHED="${BoldOrange}📦${ResetColor}"
  GIT_PROMPT_CLEAN="${BoldGreen}✔️ ${ResetColor}"
  GIT_PROMPT_SYMBOLS_NO_REMOTE_TRACKING="${White}🔒${ResetColor}" # Displayed for untracked branches

  # Use red and green for behind and ahead origin
  GIT_PROMPT_SYMBOLS_BEHIND="${BoldRed}↓${ResetColor}"
  GIT_PROMPT_SYMBOLS_AHEAD="${BoldGreen}↑${ResetColor}"

  GIT_PROMPT_START_USER="${BoldGreen}\u@\h ${BrightBlue}\w${ResetColor}"
  GIT_PROMPT_START_ROOT="${BoldRed}\h ${BrightBlue}\w${ResetColor}"

  GIT_PROMPT_END_USER="${BrightBlue} \$ ${ResetColor}"
  GIT_PROMPT_END_ROOT="${BrightBlue} \$ ${ResetColor}"
}

reload_git_prompt_colors "Custom_Gentoo_Emoji"

