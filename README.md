# exist_docs
[![License][license-img]][license-url]
[![GitHub release][release-img]][release-url]
[![NPM version][npm-image]][npm-url]
[![Build Status][travis-image]][travis-url]
[![Dependency Status][daviddm-image]][daviddm-url]
[![Coverage percentage][coveralls-image]][coveralls-url]

<img src="icon.png" align="left" width="25%"/>

new documentation prototype based on pretty-docs theme.

## Why
This prototype is based on recent discussions about how to improve exist-db's documentation. While it is working, it is far from complete. There are some screenshots and thoughts on how this would be an improvement in the [wiki](https://github.com/duncdrum/exist-docs/wiki)

## Requirements
*   [exist-db](http://exist-db.org/exist/apps/homepage/index.html) version: ``3.0.4`` or greater
*   [ant](http://ant.apache.org) version: ``1.10.1`` \(for building from source\)

## Installation
1.  Download  the ``exist_docs-3.0.0.xar`` file from GitHub [releases](https://github.com/duncdrum/exist-docs/releases) page.
2.  Open the [dashboard](http://localhost:8080/exist/apps/dashboard/index.html) of your eXist-db instance and click on ``package manager``.
    1.  Click on the ``add package`` symbol in the upper left corner and select the ``.xar`` file you just downloaded.
3.   You have successfully installed exist_docs into exist.

### Building from source
1.  Download, fork or clone this GitHub repository
2.  There are two default build targets in ``build.xml``:
    *   ``dev`` including *all* files from the source folder including those with potentially sensitive information.
    *   ``deploy`` is the official release. It excludes files necessary for development but that have no effect upon deployment.
3.  Calling ``ant``in your CLI will build both files:    
```bash
cd exist_docs
ant
```
   1. to only build a specific target call either ``dev`` or ``deploy`` like this:
   ```bash   
   ant deploy
   ```   

If you see ``BUILD SUCCESSFUL`` ant has generated a ``exist_docs-3.0.0.xar`` file in the ``build/`` folder. To install it, follow the instructions [above](#installation).

## Contributing
You can take a look at our [Contribution guidelines](.github/CONTRIBUTING.md) and [Style Guide](.github/STYLE_GUIDE.md).


## License

AGPL-3.0 © [Duncan Paterson](https://github.com/duncdrum)
CC-BY 3.0 [Xiaoying Riley](https://twitter.com/3rdwave_themes)


[license-img]: https://img.shields.io/badge/license-AGPL%20v3-blue.svg
[license-url]: https://www.gnu.org/licenses/agpl-3.0
[release-img]: https://img.shields.io/badge/release-3.0.0-green.svg
[release-url]: https://github.com/duncdrum/exist-docs/releases/latest
[npm-image]: https://badge.fury.io/js/exist-docs.svg
[npm-url]: https://npmjs.org/package/exist-docs
[travis-image]: https://travis-ci.org/duncdrum/exist-docs.svg?branch=master
[travis-url]: https://travis-ci.org/duncdrum/exist-docs
[daviddm-image]: https://david-dm.org/duncdrum/exist-docs.svg?theme=shields.io
[daviddm-url]: https://david-dm.org/duncdrum/exist-docs
[coveralls-image]: https://coveralls.io/repos/duncdrum/exist-docs/badge.svg
[coveralls-url]: https://coveralls.io/r/duncdrum/exist-docs
