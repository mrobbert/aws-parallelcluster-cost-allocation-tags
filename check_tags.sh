#!/bin/bash

# This script runs every minute from cron on the compute node
source /etc/profile

region=$(curl -s http://169.254.169.254/latest/meta-data/placement/region)
aws configure set region $region

update=0
tag_userid=""
tag_jobid=""
tag_project=""

if [ ! -f /tmp/jobs/jobs_users ] || [ ! -f /tmp/jobs/jobs_ids ]; then
  exit 0
fi

active_users=$(cat /tmp/jobs/jobs_users | sort | uniq )
active_jobs=$(cat /tmp/jobs/jobs_ids | sort )
echo $active_users > /tmp/jobs/tmp_jobs_users
echo $active_jobs > /tmp/jobs/tmp_jobs_ids
if [ -f /tmp/jobs/jobs_projects ]; then
  active_projects=$(cat /tmp/jobs/jobs_projects | sort | uniq )
  echo $active_projects > /tmp/jobs/tmp_jobs_projects
fi


if [ ! -f /tmp/jobs/tag_userid ] || [ ! -f /tmp/jobs/tag_jobid ]; then

  echo $active_users > /tmp/jobs/tag_userid
  echo $active_jobs > /tmp/jobs/tag_jobid
  echo $active_projects > /tmp/jobs/tag_project
  update=1

else

  active_users=$(cat /tmp/jobs/tmp_jobs_users)
  active_jobs=$(cat /tmp/jobs/tmp_jobs_ids)
  if [ -f /tmp/jobs/tmp_jobs_projects ]; then
    active_projects=$(cat /tmp/jobs/tmp_jobs_projects)
  fi 
  tag_userid=$(cat /tmp/jobs/tag_userid)
  tag_jobid=$(cat /tmp/jobs/tag_jobid)
  if [ -f /tmp/jobs/tag_project ]; then
    tag_project=$(cat /tmp/jobs/tag_project)
  fi
  
  if [ "${active_users}" != "${tag_userid}" ]; then
    tag_userid="${active_users}"
    echo ${tag_userid} > /tmp/jobs/tag_userid
    update=1
  fi
  
  if [ "${active_jobs}" != "${tag_jobid}" ]; then
    tag_jobid="${active_jobs}"
    echo ${tag_jobid} > /tmp/jobs/tag_jobid
    update=1
  fi
  
  if [ "${active_projects}" != "${tag_project}" ]; then
    tag_project="${active_projects}"
    echo ${tag_project} > /tmp/jobs/tag_project
    update=1
  fi

fi

#Only update tags if something has changed
if [ ${update} -eq 1 ]; then
  
  # Instance ID
  MyInstID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
  tag_userid=$(cat /tmp/jobs/tag_userid)
  tag_jobid=$(cat /tmp/jobs/tag_jobid)
  tag_project=$(cat /tmp/jobs/tag_project)
  tag_cluster="apex"
  aws ec2 create-tags --resources ${MyInstID} --tags Key=mines-ciarc-username,Value="${tag_userid}"
  aws ec2 create-tags --resources ${MyInstID} --tags Key=mines-ciarc-jobid,Value="${tag_jobid}"
  aws ec2 create-tags --resources ${MyInstID} --tags Key=mines-ciarc-project,Value="${tag_project}"
  aws ec2 create-tags --resources ${MyInstID} --tags Key=mines-ciarc-cluster,Value="${tag_cluster}"
  
fi