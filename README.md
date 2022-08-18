<div align="center">
  <h1>lndart.clnapp</h1>

  <img src="https://raw.githubusercontent.com/dart-lightning/lndart.clnapp/main/assets/launcher_icon/web/icon-512.png" width="130" />

  <p>
    <strong> :dart: Cross platform app to manage remotely and locally a core lightning node :dart: </strong>
  </p>

  <h4>
    <a href="https://github.com/dart-lightning">Project Homepage</a> | <a href="https://dart-lightning.github.io/lndart.clnapp">CLNAPP webapp</a>
  </h4>

   <a>
      <img alt="GitHub Workflow Status" src="https://github.com/dart-lightning/lndart.clnapp/actions/workflows/build-ci.yml/badge.svg">
   </a>

   <a>
        <img alt="Github Pages" src="https://github.com/dart-lightning/lndart.clnapp/actions/workflows/gh_pages.yml/badge.svg">
   </a>

   <a>
       <img alt="Integeration Testing" src="https://github.com/dart-lightning/lndart.clnapp/actions/workflows/testing.yml/badge.svg">
   </a>
</div>



## Table of Content

- [Introduction](#introduction)
- [How to Build](#how-to-build)
    - [Installation](#installation)
        - [Linux](#linuxdesktop)
        - [Chrome](#chromeweb)
        - [Android](#android)
- [How to Contribute](#how-to-contribute)
- [License](#license)


## Introduction

A cross platform application to effortlessly manage your core lightning node using multiple cln clients.

Core lightning clients which are supported by lndart.clnapp:

| Core Lightning Client        | Description                                                     | Version    |
|----------------|-----------------------------------------------------------------|------------|
| <ul><li> [x] [cln_grpc](https://github.com/dart-lightning/lndart.cln_grpc)</li></ul>  | A dart library which facilitates dart gRPC client for core lightning.      | ![Pub Version (including pre-releases)](https://img.shields.io/pub/v/cln_grpc?include_prereleases&style=flat-square) |
| <ul><li> [x] [lnlambda](https://github.com/dart-lightning/lndart.cln/tree/main/packages/lnlambda)</li></ul>  | Minimal interface to run lnlambda function with dart. | ![Pub Version (including pre-releases)](https://img.shields.io/pub/v/lnlambda?include_prereleases&style=flat-square) |
| <ul><li> [x] [cln_rpc](https://github.com/dart-lightning/lndart.cln/tree/main/packages/rpc)</li></ul>  | A RPC wrapper around the core lightning API.                    | ![Pub Version (including pre-releases)](https://img.shields.io/pub/v/clightning_rpc?include_prereleases&style=flat-square) |

## How to Build

### Installation

- Clone the lndart.clnapp repository.

```bash
sudo git clone https://github.com/dart-lightning/lndart.clnapp.git
```
- Get flutter dependencies

```bash
make dep
make get
```

#### Linux(desktop)

- Enable the linux desktop to run the application

```bash
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
flutter config --enable-linux-desktop
flutter run -d linux
```

#### Chrome(web)

```bash
flutter run -d chrome
```

- The clnapp webapp is also deployed using github pages [Checkout here](https://dart-lightning.github.io/lndart.clnapp).

#### Android

##### Emulator

- Find the device-id of android/emulator device connected

```bash
flutter devices
```

- Run the flutter application using device-id
```bash
flutter run -d <device-id>
```

##### Andoid(Mobile)

- Build the .apk file for android application
```bash
flutter build apk
```

- The apk file generated can be found inside `[project]/build/app/outputs/bundle/release/`


## How to Contribute

Read our [Hacking guide](https://github.com/dart-lightning/lndart.clnapp/blob/main/docs/dev/MAINTAINERS.md)

## License
