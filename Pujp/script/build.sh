#!/bin/sh

carton install
carton exec local/bin/wallflower --environment production --application script/pujp-server --destination ../static/
exit 0
