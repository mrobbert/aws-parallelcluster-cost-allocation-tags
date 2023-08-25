#!/bin/bash

#slurm directory
export SLURM_ROOT=/sw/apps/slurm/active
echo "${SLURM_JOB_USER}" >> /tmp/jobs/jobs_users
echo "${SLURM_JOBID}" >> /tmp/jobs/jobs_ids
echo "${SLURM_JOB_ACCOUNT}" >> /tmp/jobs/jobs_projects