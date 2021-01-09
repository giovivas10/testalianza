#!/bin/bash

pwd
echo "Deleting old dist folder ..."
rm -rf ./dist
echo "Old dist folder deleted"

echo "Deleting old ../main/webapp folder ..."
rm -rf ../main/webapp
echo "Old ../main/webapp folder deleted"

echo "Creating new ../main/webapp folder ..."
mkdir -p ../main/webapp
echo "New ../main/webapp folder created"

