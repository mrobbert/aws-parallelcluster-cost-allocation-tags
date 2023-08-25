#!/bin/bash
#slurm directory
export SLURM_ROOT=/sw/apps/slurm/active
sed -i "0,/${SLURM_JOB_USER}/d" /tmp/jobs/jobs_users
sed -i "0,/${SLURM_JOBID}/d" /tmp/jobs/jobs_ids
sed -i "0,/${SLURM_JOB_ACCOUNT}/d" /tmp/jobs/jobs_projects