# xcode-simulator-tool

[![Swift 5 compatible][swift-badge]][Swift] [![Xcode 10.2 compatible][xcode-badge]][Xcode] 

This is a tool to manage Xcode simulators and their [root certificates][RootCertificate]. 

If you have a certificate for your server in PEM format in a file `myhost.crt`, type:

```bash
$ xcode-simulator-tool install-ca myhost.crt
```

It will then install the certificate in all your simulators. You can also specify a specific simulator:

```bash
$ xcode-simulator-tool install-ca myhost.crt --device-name="iPhone 8"
```

There are also some other subcommands and options available. `--help` is your friend.

## Installation

#### Using Homebrew

[Homebrew] is the de-facto standard package manager for macOS open-source tools and other things.

```bash
$ brew install skagedal/formulae/xcode-simulator-tool
```

### Using Mint

[Mint] is a pretty nice package manager for Swift Package Manager-based projects, such as this one. 

```bash
$ mint install skagedal/xcode-simulator-tool
```

## Development

If you'd like to hack on `xcode-simulator-tool`, you may run `generate-xcodeproj.sh` to generate an Xcode project. 

## Acknowledgements

This tool is largely based on the work of Daniel Cerutti and his [ADVTrustStore] tool.  `xcode-simulator-tool` doesn't do much more than what his tool does at the moment.  I mostly just wanted to rewrite it in Swift.

[ADVTrustStore]: https://github.com/ADVTOOLS/ADVTrustStore
[Homebrew]: https://brew.sh
[Mint]: https://github.com/yonaskolb/Mint
[RootCertificate]: https://en.wikipedia.org/wiki/Root_certificate
[Swift]: https://developer.apple.com/swift/
[Xcode]: https://developer.apple.com/xcode/

[swift-badge]: https://img.shields.io/badge/swift-5-orange.svg?style=flat
[xcode-badge]: https://img.shields.io/badge/xcode-10.2-blue.svg?style=flat 
