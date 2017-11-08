#!/bin/sh
echo "Generating Solidity files from './Contracts/*'. If this script fails due to already existing files, re-run it with '--force'. Beware though, this will delete every file that is contained in './Heimdall/Solidity'."
# $1 is the first argument passed to this script. Useful only if --force is used, other flags will not be recognized by bivrost.
mint run gnosis/bivrost-swift@0.0.4 "bivrost --input './Contracts/*' --output './Heimdall/Solidity/' $1"
