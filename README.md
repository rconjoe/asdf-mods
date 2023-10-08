<div align="center">

# asdf-mods [![Build](https://github.com/rconjoe/asdf-mods/actions/workflows/build.yml/badge.svg)](https://github.com/rconjoe/asdf-mods/actions/workflows/build.yml) [![Lint](https://github.com/rconjoe/asdf-mods/actions/workflows/lint.yml/badge.svg)](https://github.com/rconjoe/asdf-mods/actions/workflows/lint.yml)

[mods](https://github.com/charmbracelet/mods) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add mods
# or
asdf plugin add mods https://github.com/rconjoe/asdf-mods.git
```

mods:

```shell
# Show all installable versions
asdf list-all mods

# Install specific version
asdf install mods latest

# Set a version globally (on your ~/.tool-versions file)
asdf global mods latest

# Now mods commands are available
mods --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/rconjoe/asdf-mods/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [rconjoe](https://github.com/rconjoe/)
