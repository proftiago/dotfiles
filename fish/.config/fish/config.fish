# Starship
starship init fish | source

# Variáveis
set -gx EDITOR nano
set -gx TERMINAL foot
set -gx BROWSER google-chrome-stable

# Aliases SIMPLES
alias ll "ls -la --color=always"
alias la "ls -a --color=always"
alias .. "cd .."
alias ... "cd ../.."

# Greeting
function fish_greeting
    echo "👋 Bem-vindo, Tiago! | $(date '+%d/%m %H:%M')"
end
