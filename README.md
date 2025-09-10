# gotestprjtmpl

This is my playground go project where I test stuff(mostly ci related).

## Installation
### Binary
If none of the options listed below work for you, you can always just download
a statically linked executable for your platform from the [releases page](https://github.com/asciimoth/gotestprjtmpl/releases/latest).
### Nix
Nix users can install gotestprjtmpl with flake:
```sh
# Install to sys profile
nix profile add github:asciimoth/gotestprjtmpl
# Remove from sys profile
nix profile remove gotestprjtmpl

# Add to temporal shell
nix shell github:asciimoth/gotestprjtmpl
```
### Deb/Rpm
You can download deb/rmp packages from [releases page](https://github.com/asciimoth/gotestprjtmpl/releases/latest)
or use my [deb/rpm repo](https://repo.moth.contact/).
### Arch
Arch users can download `.pkg` files from [releases page](https://github.com/asciimoth/gotestprjtmpl/releases/latest) too.  
AUR is on the way.
### Go
You can also install it with go:
```sh 
go install github.com/asciimoth/gotestprjtmpl@latest
```

## License
This project is licensed under either of

- Apache License, Version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or http://www.apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

at your option.

