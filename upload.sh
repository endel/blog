#!/bin/bash
cd static
git init .
git remote add origin git@github.com:endel/blog.git
git checkout -b gh-pages
git add .
git commit -m "update build"
git push origin gh-pages --force
