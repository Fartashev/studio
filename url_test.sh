#!/bin/bash

url=http://localhost:8080
url2=http://localhost:2019/ExperienceService

if curl --output /dev/null --silent --head --fail "$url"; then
  echo "THINGWORX URL is UP and Running"
else
  echo "THINGWORX URL is DOWN, please check the URL"
fi;


if curl --output /dev/null --silent --head --fail "$url2"; then
  echo "STUDIO/TES URL is UP and Running"
else
  echo "STUDIO/TES URL is DOWN, please check the URL"
fi

