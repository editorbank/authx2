#!/bin/env bash

cat /dev/null >tmp/user_pass-to-session.map
cat /dev/null >tmp/session-to-user.map
cat /dev/null >tmp/user-to-user_attributes.map
cat /dev/null >tmp/user-to-user_group.map

skip_headers=1; while IFS=, read -r user pass user_group branch fio
do
  if ((skip_headers)); then ((skip_headers--)); else
    session=$(echo $user-$RANDOM-$RANDOM|openssl md5 | cut -f2 -d " ")
    echo "\"user=$user&pass=$pass\" \"$session\";" >>tmp/user_pass-to-session.map
    echo "\"$session\" \"$user\";" >>tmp/session-to-user.map
    echo "\"$user\" '{\"user_group\":\"$user_group\",\"branch\":\"$branch\",\"fio\":\"$fio\"}';" >>tmp/user-to-user_attributes.map
    echo "\"$user\" \"$user_group\";" >>tmp/user-to-user_group.map
  fi
done < users.csv

cat /dev/null >tmp/resource-to-resource_group.map
skip_headers=1; while IFS=, read -r method uri resouce_group
do
  if ((skip_headers)); then ((skip_headers--)); else
    echo "\"$method;$uri\" \"$resouce_group\";" >>tmp/resource-to-resource_group.map
  fi
done < resources.csv

cat /dev/null >tmp/right.map
skip_headers=1; while IFS=, read -r user_group resouce_group
do
  if ((skip_headers)); then ((skip_headers--)); else
    echo "\"$user_group;$resouce_group\" 1;" >>tmp/right.map
  fi
done < right.csv
