#!/usr/bin/env sh

declare packages=( 
    "gocode:github.com/nsf/gocode"
    "gotags:github.com/jstemmer/gotags"
    "goimports:code.google.com/p/go.tools/cmd/goimports"
    "godef:code.google.com/p/rog-go/exp/cmd/godef"
    "golint:github.com/golang/lint/golint"
    "gotype:code.google.com/p/go.tools/cmd/gotype"
)


if which go > /dev/null 2>&1; then
    if [ ! -z ${GOPATH} ]; then
        for package in ${packages[@]}; do
            key=${package%%:*}
            value=${package##*:}
            echo "Install ${key}..."
            go get -u ${value}
        done
    else
        echo "Please setup GOPATH environment virable. And add '\${GOPATH}/bin' to your PATH"
    fi
else
    echo "No go command detected."
fi
