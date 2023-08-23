#!/usr/bin/env sh

reset='\e[0m'
red='\e[31m'
background_red='\e[41m'

black_color='\e[30m'
red_color='\e[31m'
magenta_color='\e[35m'
cyan_color='\e[36m'

text_color="$black_color"
header_color="$cyan_color"
option_color="$red_color"
option_description_color="$magenta_color"

valid_options='--help|-h --version|-v --text-color|-t --header-color|-H --option-color|-o --option-description-color|-O --preview|-p --copy|-c --completion|-C --'
valid_colors='black red green yellow blue magenta cyan light-gray gray light-red light-green light-yellow light-blue light-magenta light-cyan white'

error() {
    e_in_message="$1"
    printf "${background_red}error:$reset$red %s$reset" "$e_in_message" >&2
    exit "$failed"
}

error_when_option_is_not_supported() {
    ewoins_in_option="$1"
    ewoins_in_previous_option="$2"

    error "'$ewoins_in_option' option is not supported (right after '$ewoins_in_previous_option'), expected one of: $valid_options"
}

error_when_color_is_not_supported() {
  ewcins_in_color="$1"

  ewcins_colors='black red green yellow blue magenta cyan light-gray gray light-red light-green light-yellow light-blue light-magenta light-cyan white'

  for color in $ewcins_colors; do
    [ "$color" = "$ewcins_in_color" ] && return
  done

  error "'$ewcins_in_color' is color not supported, expected one of: $ewcins_colors"
}

error_when_format_is_not_supported() {
  ewfins_in_format="$1"
  ewfins_in_previous_format="$2"

  [ "" = "$(echo "$ewfins_in_format" | sed -E -n '/^(--?[^-=\/]+|-[^-=\/]+\/--[^=\/]+)=[^=]+$/p')" ] &&
    error "'$ewfins_in_format' format is not supported (right after '$ewfins_in_previous_format'), expected one of: -<short-option>=<description> --<long-option>=<description> -<short-option>/--<long-option>=<description>"
}

error_when_shell_is_not_supported() {
  ewsins_in_option="$1"

  ewsins_valid_options='bash fish'

  [ "" = "$(echo "$ewsins_in_option" | sed -E -n '/^(bash|fish)$/p')" ] &&
    error "'$ewsins_in_option' shell is not supported, expected one of: $ewsins_valid_options"
}

# shellcheck disable=SC2028
color_to_ascii_code() {
  ctac_in_color="$1"

  error_when_color_is_not_supported "$ctac_in_color"

  case "$ctac_in_color" in
    black)
      echo '\e[30m'
      ;;
    red)
      echo '\e[31m'
      ;;
    green)
      echo '\e[32m'
      ;;
    yellow)
      echo '\e[33m'
      ;;
    blue)
      echo '\e[34m'
      ;;
    magenta)
      echo '\e[35m'
      ;;
    cyan)
      echo '\e[36m'
      ;;
    light-gray)
      echo '\e[37m'
      ;;
    gray)
      echo '\e[100m'
      ;;
    light-red)
      echo '\e[101m'
      ;;
    light-green)
      echo '\e[102m'
      ;;
    light-yellow)
      echo '\e[103m'
      ;;
    light-blue)
      echo '\e[104m'
      ;;
    light-magenta)
      echo '\e[105m'
      ;;
    light-cyan)
      echo '\e[106m'
      ;;
    white)
      echo '\e[107m'
      ;;
  esac
}

help() {
  echo "Colorful help message generator.

Usage:
  $0 [--help|-h] [--version|-v] [--completion|-C <shell>]
  $0 [--text-color|-t] [--header-color|-H] [--option-color|-o] [--option-description-color|-O] [--preview|-p] [--copy|-c] <description> -- (-<short-option>|--<long-option>|-<short-option>/--<long-option>)=<description>...

Options:
  --help|-h                      Print help.
  --version|-v                   Print version.
  --text-color|-t                Specify text color.
  --header-color|-H              Specify header color.
  --option-color|-o              Specify option color.
  --option-description-color|-O  Specify option description color.
  --preview|-p                   Whether to preview generated message.
  --copy|-c                      Whether to copy generated function to clipboard.
  --completion|-C                Generate completion for shell.

Examples:
  $0 'Snippet generator.' '-h/--help=Print help' '-v/--version=Print version' '-p/--path=Specify path for manually written snippets'"
}

version() {
  echo "1.0.0"
}

# shellcheck disable=SC2317,SC2046
generate_completion() {
  gc_in_shell="$1"

  gc_tool="$(echo "$0" | sed 's|./||')"

  error_when_shell_is_not_supported "$gc_in_shell"

  case "$gc_in_shell" in
    bash)
      echo complete -W \'$(echo "$valid_options" | sed 's/|/ /g')\' "$gc_tool"
      ;;
    fish)
      echo "set colors $valid_colors

complete -c $gc_tool -s h -l help -d \"Print help\"
complete -c $gc_tool -s v -l version -d \"Print version\"
complete -c $gc_tool -s t -l text-color -d \"Specify text color\" -x -a '\$colors'
complete -c $gc_tool -s H -l header-color -d \"Specify header color\" -x -a '\$colors'
complete -c $gc_tool -s o -l option-color -d \"Specify option color\" -x -a '\$colors'
complete -c $gc_tool -s O -l option-description-color -d \"Specify option description color\" -x -a '\$colors'
complete -c $gc_tool -s p -l preview -d \"Whether to preview generated message\"
complete -c $gc_tool -s c -l copy -d \"Whether to copy generated function to clipboard\"
complete -c $gc_tool -s C -l completion -d \"Generate completion for shell\" -x -a 'bash fish'"
      ;;
  esac

  exit
}

succeded=0
failed=1

description=
preview=
copy=
shell=

previous_option="$0"

while [ -n "$1" ]; do
  option="$1"
  argument="$2"

  case "$option" in
    --help|-h)
      help
      exit "$succeded"
      ;;
    --version|-v)
      version
      exit "$succeded"
      ;;
    --text-color|-t)
      text_color="$(color_to_ascii_code "$argument")"
      shift
      ;;
    --header-color|-H)
      header_color="$(color_to_ascii_code "$argument")"
      shift
      ;;
    --option-color|-o)
      option_color="$(color_to_ascii_code "$argument")"
      shift
      ;;
    --option-description-color|-O)
      option_description_color="$(color_to_ascii_code "$argument")"
      shift
      ;;
    --preview|-p)
      preview=true
      ;;
    --copy|-c)
      copy=true
      ;;
    --completion|-C)
      shell="$argument"
      generate_completion "$shell"
      ;;
    --)
      shift
      break
      ;;
    -*)
      error_when_option_is_not_supported "$option" "$previous_option"
      ;;
    *)
      description="$option"
      shift
      break
      ;;
  esac
  previous_option="$option"
  shift
done

[ "" = "$description" ] &&
  error "Non-empty '<description>' is not provided (right after '$0'), expected: <description>"
[ -- != "$1" ] &&
  error "'--' is not provided (right after '$description'), expected: --"

previous_format="$1"
shift

[ -z "$1" ] &&
  error "'(-<short-option>|--<long-option>|-<short-option>/--<long-option>)=<description>...' is not provided (right after '$previous_format'), expected: (-<short-option>|--<long-option>|-<short-option>/--<long-option>)=<description>..."

message="${text_color}${description}

${header_color}Options:
"

message_options=

while [ -n "$1" ]; do
  format="$1"
  error_when_format_is_not_supported "$format" "$previous_format"

  options="$(echo "$format" | sed -E 's/=.*//; s/(.+)\/(.+)/\2|\1/')"
  option_description="$(echo "$format" | sed -E 's/.*=//')"

  message_options="${message_options}$(printf '\t')$option_color$options $option_description_color$option_description"
  [ -n "$2" ] && message_options="${message_options}
"

  previous_format="$1"
  shift
done

message="$message$(echo "$message_options" | column -t -s " " -l 2)"

rendered_message="$(echo "help() {"
  printf '\techo -e "'
  printf "%s\"\n" "$message"
  echo "}"
)"

[ -n "$copy" ] && echo "$rendered_message" | xclip -selection clipboard

# shellcheck disable=SC2059
if [ -n "$preview" ]; then
  printf "$message"
else
  echo "$rendered_message"
fi
