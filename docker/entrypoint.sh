#!/bin/sh
ls -la
# Give time to cln to boostrap
sleep 5m
make dep
export TLS_PATH=/.lightning/testnet/
export RPC_PATH=/.lightning/testnet/lightning-rpc
make check