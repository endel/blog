#!/bin/bash

# Define urls and https
from_url=http://localhost:2368
to_url=https://blog.endel.me
to_https=true

sudo rm -R static


# Copy blog content
# wget --recursive --no-host-directories --directory-prefix=static --adjust-extension --timeout=30 --no-parent --convert-links ${from_url}/
wget --recursive --no-host-directories --directory-prefix=static --adjust-extension --timeout=30 --no-parent ${from_url}/

# Copy 404 page
wget --no-host-directories --directory-prefix=static --adjust-extension --timeout=30 --no-parent --convert-links --content-on-error --timestamping ${from_url}/404.html

# Copy sitemaps
wget --recursive --no-host-directories --directory-prefix=static --adjust-extension --timeout=30 --no-parent --convert-links ${from_url}/sitemap.xsl
wget --recursive --no-host-directories --directory-prefix=static --adjust-extension --timeout=30 --no-parent --convert-links ${from_url}/sitemap.xml
wget --recursive --no-host-directories --directory-prefix=static --adjust-extension --timeout=30 --no-parent --convert-links ${from_url}/sitemap-pages.xml
wget --recursive --no-host-directories --directory-prefix=static --adjust-extension --timeout=30 --no-parent --convert-links ${from_url}/sitemap-posts.xml
wget --recursive --no-host-directories --directory-prefix=static --adjust-extension --timeout=30 --no-parent --convert-links ${from_url}/sitemap-authors.xml
wget --recursive --no-host-directories --directory-prefix=static --adjust-extension --timeout=30 --no-parent --convert-links ${from_url}/sitemap-tags.xml

# Replace localhost with real domain
if [ "${to_https}" == true ]; 
  then LC_ALL=C find ./static -type f -not -wholename *.git* -exec sed -i '' -e "s,http://${from_url},https://${to_url},g" {} +; 
fi
if [ "${to_https}" == false ]; 
  then LC_ALL=C find ./static -type f -not -wholename *.git* -exec sed -i '' -e "s,http://${from_url},http://${to_url},g" {} +; 
fi

LC_ALL=C find ./static -type f -not -wholename *.git* -exec sed -i '' -e "s,${from_url},${to_url},g" {} +
LC_ALL=C find ./static -type f -not -wholename *.git* -exec sed -i '' -e 's,http://www.gravatar.com,https://www.gravatar.com,g' {} +

# move file.css?v=xxx into file.css, etc
for file in $(find ./static -type f -name "*\?*"); do
  mv $file $(echo "$file" | sed "s/\?.*//");
  echo "$file -> $(echo "$file" | sed "s/\?.*//")"
done

# Set up Github Pages CNAME
echo "${to_url}" > static/CNAME
