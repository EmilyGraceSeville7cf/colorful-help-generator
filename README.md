# Colored help

Colorful help message generator.

## Usage

```bash
colored-help [--help|-h] [--version|-v] [--completion|-C <shell>]
colored-help [--text-color|-t] [--header-color|-H] [--option-color|-o] [--option-description-color|-O] [--preview|-p] [--copy|-c] <description> -- (-<short-option>|--<long-option>|-<short-option>/--<long-option>)=<description>...
```

- `--help`|`-h`: Print help.
- `--version`|`-v`: Print version.
- `--text-color`|`-t`: Specify text color.
- `--header-color`|`-H`: Specify header color.
- `--option-color`|`-o`: Specify option color.
- `--option-description-color`|`-O`: Specify option description color.
- `--preview`|`-p`: Whether to preview generated message.
- `--copy`|`-c`: Whether to copy generated function to clipboard.
- `--completion`|`-C`: Generate completion for shell.

## Examples

```bash
colored-help 'Snippet generator.' -- '-h/--help=Print help' '-v/--version=Print version' '-p/--path=Specify path for manually written snippets'
```

Result:

```bash
help() {
        echo -e "\e[30mSnippet generator.

\e[36mOptions:
        \e[31m--help|-h     \e[35mPrint help
        \e[31m--version|-v  \e[35mPrint version
        \e[31m--path|-p     \e[35mSpecify path for manually written snippets"
}
```

## Notes

This is my first script intended to be as much as portable as it could be. But
unfortunately it doesn't currently work with `#!/usr/bin/env sh` shebang.
