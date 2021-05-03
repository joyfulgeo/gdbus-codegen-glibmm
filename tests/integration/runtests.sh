#!/bin/bash

DIR="$(cd $(dirname "$0"); pwd)/../.."

echo
echo "== Build Stub"
echo
cd stub
mkdir -p build
cd build
cd .. ; rm -rf build ; mkdir build; cd build; cmake .. -DCODEGEN="$DIR/gdbus-codegen-glibmm.py" -DCMAKE_BUILD_TYPE=Debug
make

echo
echo "== Build Proxy"
echo

cd ../../proxy
mkdir -p build
cd build
cd .. ; rm -rf build ; mkdir build; cd build; cmake .. -DCODEGEN="$DIR/gdbus-codegen-glibmm.py" -DCMAKE_BUILD_TYPE=Debug

make

cd ../../

echo
echo "== Run Stub"
echo

./stub/build/stubtest &
STUB_PID=$!

trap 'kill $STUB_PID' EXIT

sleep 3

echo
echo "== Run Proxy"
echo

./proxy/build/proxytest
