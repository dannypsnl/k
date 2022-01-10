# k

[![Test](https://github.com/racket-tw/k/actions/workflows/test.yml/badge.svg)](https://github.com/racket-tw/k/actions/workflows/test.yml)
[![Coverage Status](https://coveralls.io/repos/github/racket-tw/k/badge.svg?branch=develop)](https://coveralls.io/github/racket-tw/k?branch=develop)
[![Documentation](https://img.shields.io/badge/docs-published-blue)](https://docs.racket-lang.org/k/)

K is a theorem prover based on Racket ecosystem, interact with Racket in useful way is the major purpose of the project.

### Installation

1. only want core language
    ```shell
    raco pkg install --auto k-core
    ```
2. wants standard library
    ```shell
    raco pkg install --auto k-core
    raco pkg install --auto k-lib
    ```

### For developer

The following commands might be helpful for your development

```shell
raco pkg install --auto ./k-core
raco pkg install --auto ./k-lib
raco pkg install --auto ./k-doc
raco pkg install --auto ./k-test
raco pkg install --auto ./k-example
# apply git config of the project
git config commit.template $(pwd)/.gitmessage
```
