#!/bin/bash
#slurm directory
export SLURM_ROOT=/sw/apps/slurm/active
sed -i "0,/${SLURM_JOB_USER}/d" /tmp/jobs/jobs_users
sed -i "0,/${SLURM_JOBID}/d" /tmp/jobs/jobs_ids

#load the comment of the job.
Project=$($SLURM_ROOT/bin/scontrol show job ${SLURM_JOB_ID} | grep Comment | awk -F'=' '{print $2}')
Project_Tag=""
if [ ! -z "${Project}" ];then
  sed -i "0,/${Project}/d" /tmp/jobs/jobs_projects
fi