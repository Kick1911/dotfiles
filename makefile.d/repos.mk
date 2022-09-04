TARGETS += repos
REPO_DIR := ${HOME}/Documents
GITHUB_URL = git@github.com:Kick1911
GITLAB_URL = git@gitlab.com:Kickness

GITHUB_REPOS = python-tidal dotfiles WorkForce freeswitch-cluecon-lab Hash_Table
GITLAB_REPOS = cpm json gaze kickc kick-display tcphttp unitest

GITHUB_PATHS := ${GITHUB_REPOS:%=${REPO_DIR}/%}
GITLAB_PATHS := ${GITLAB_REPOS:%=${REPO_DIR}/%}

${GITHUB_PATHS}:
	${call clone,${GITHUB_URL},$@}

${GITLAB_PATHS}:
	${call clone,${GITLAB_URL},$@}

repos: ${GITLAB_PATHS} ${GITHUB_PATHS}

define clone
	${call print,${CYAN}GITHUB:CLONE ${BRIGHT_CYAN}${notdir ${2}}}
	${call as_user, git clone ${1}/${notdir ${2}}.git ${2}}
endef

.PHONY: repos
