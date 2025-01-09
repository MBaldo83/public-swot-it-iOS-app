#!/bin/bash

swift build --package-path ./AIGenerator/ -c release
./AIGenerator/.build/release/AIGenerator