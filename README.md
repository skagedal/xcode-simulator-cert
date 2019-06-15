# xcode-simulator-cert

[![Swift 5 compatible][swift-badge]][Swift] [![Xcode 10.2 compatible][xcode-badge]][Xcode] [![Xcode 10.2 compatible][xcode-beta-badge]][Xcode] 

This is a tool to manage [root certificates][RootCertificate] in Xcode simulators.  Installing a certificate in all your simulators is as easy as:

```bash
$ xcode-simulator-cert install myhost.crt
```

It will then install the certificate in all your simulators. 

## Installation

#### Using Homebrew

[Homebrew] is the de-facto standard package manager for macOS open-source tools and other things.

```bash
$ brew install skagedal/formulae/xcode-simulator-cert
```

### Using Mint

[Mint] is a pretty nice package manager for Swift Package Manager-based projects, such as this one. 

```bash
$ mint install skagedal/xcode-simulator-cert
```

## Usage

`xcode-simulator-tool` basically does CRUD actions for certificates in simulators: install new ones, export existing ones, remove certificates, and list them. 

Use `xcode-simulator-tool --help` to get a quick overview of how it works.

### Installing certificates

The `install` subcomand takes a parameter where you give the certificate in PEM format. 

```bash
$ xcode-simulator-cert install myhost.crt
```

You can also specify a specific simulator:

```bash
$ xcode-simulator-cert install myhost.crt --device-name="iPhone 8"
```

This will install the certificate in simulators whose name exactly matches "iPhone 8". There are some other ways of filtering into which simulators to affect, please see `xcode-simulator-cert install --help`. 

It will skip installing in simulators where this exact certificate already exist. 

### Exporting certificates

The `export` subcommand exports existing root certificate that it finds in the trust store of selected devices, creating a PEM file for each unique certificate.

```
$ xcode-simulator-cert export 
```

### Removing certificates

The `remove` subcommand removes all root certificates from selected devices. 

### List certificates

The `list` subcommand lists all simulator devices and what certificates are available for each.

## Caveats

This tool edits a SQLite database managed by iOS in the simulator.  It is not using officially blessed APIs.  I have tested it on Xcode 10.2.1 and the Xcode 11 beta 1 (at the time of writing, the latest) and it works well, but I can of course not give any guarantees.  In some situations you may still need to manually go in and trust the certificate manually. I recommend not running the Xcode simulator while you run the tool.  

## Development

If you'd like to hack on `xcode-simulator-cert`, you may run `generate-xcodeproj.sh` to generate an Xcode project. 

## Acknowledgements

This tool is largely based on the work of Daniel Cerutti and his [ADVTrustStore] tool and documentation.  

[ADVTrustStore]: https://github.com/ADVTOOLS/ADVTrustStore
[Homebrew]: https://brew.sh
[Mint]: https://github.com/yonaskolb/Mint
[RootCertificate]: https://en.wikipedia.org/wiki/Root_certificate
[Swift]: https://developer.apple.com/swift/
[Xcode]: https://developer.apple.com/xcode/

[swift-badge]: https://img.shields.io/badge/swift-5-orange.svg?style=flat
[xcode-badge]: https://img.shields.io/badge/xcode-10.2-blue.svg?style=flat 
[xcode-beta-badge]: https://img.shields.io/badge/xcode-11_beta1-blue.svg?style=flat 
