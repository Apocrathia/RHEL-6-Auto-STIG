#!/bin/bash

# RHEL 6 Auto-STIG

# The goal of this program is to provide a simplified and interactive way
# of hardening a RHEL 6 system without installing any additional packages

# Concept:
# Every rule gets checked, then remediate if needed.
# This can be done in an interactive mode, so that the administrator
# knows what exactly is going on. While some programs may do the whole
# process, it is sometimes unknown as to how. Which can pose future problems

# TO-DO
# Prompt user for MAC, Sensitivity, and verbosity
# Arguments

# Probably won't happen
# RHEL 5 (Just give it up. It's 2014.)

# Notes
# I'm currently working off of v1 of the RHEL 6 STIG.
# http://www.stigviewer.com/stig/b38ff180e9c248f9730f0e18eaf0391ee50afab4
# Luckily, all of the checks are the same, regardless of the profile.
# Release 2 is out, but it just has the XCCDF content and that's it.
# The content directly from DISA is available on their site without
# PKI authentication.
# http://iase.disa.mil/stigs/os/unix/u_redhat_6_v1r2_manual.zip
# A resource that I have used heavily in the past has been Fedora's
# Aqueduct project, which provides a lot of functionality similar to
# my own goals. However, it can be a bit of a convoluted mess at times.
# The entire STIG text is in each script, and it references by RHEL #'s
# rather that V (vulnerability) #'s. I will be taking a lot of code from
# there, as it's a great start. One notable issue with it, is that it
# has a heavy emphasis on Puppet. I will modify the modules to work with
# this project, as the idea is to be able to run this on a system with
# nothing on it, and no connection to the internet. Just load it from a
# disc or usb drive (which will just get blocked anyways).
# https://fedorahosted.org/aqueduct/

# Design
# I want the each check to be broken into two subroutines; check and remediate.

# The following code is from scripts I've used in the past.

function RHEL-06-000045 {
# Rule Title: Library files must have mode 0755 or less permissive.

	libs="/lib /lib64 /usr/lib /usr/lib64"

	for lib in $libs; do
		 for i in `find $lib -perm /022`; do
			chmod go-w $i
		done
	done
}

function RHEL-06-000046 {
# Rule Title: Library files must be owned by root.

	libs="/lib /lib64 /usr/lib /usr/lib64"

	for lib in $libs; do
		 for i in `find $lib \! -user root`; do
			chown root: $i
		done
	done
}

function RHEL-06-000047 {
# Rule Title: All system command files must have mode 0755 or less permissive.
	dirs="/bin /usr/bin /usr/local/bin /sbin /usr/sbin /usr/local/sbin"
	
	for dir in $dirs; do
		for i in `find $dir -perm /022`; do
			chmod go-w $i
		done
	done
}

function RHEL-06-000048 {
# Rule Title: All system command files must be owned by root.
	dirs="/bin /usr/bin /usr/local/bin /sbin /usr/sbin /usr/local/sbin"
	
	for dir in $dirs; do
		for i in `find $dir \! -user root`; do
			chown root $i
		done
	done
}

function RHEL-06-000049 {
# Rule Title: Audit log files must have mode 0640 or less permissive.

	for i in `grep "^log_file" /etc/audit/auditd.conf|sed s/^[^\/]*//|xargs stat -c %a:%n`; do
		chmod 0640 $i
	done
}

function RHEL-06-000054 {
# Rule Title: Users must be warned 14 days in advance of password expiration.
	sed -i "s/PASS_WARN_AGE   7/PASS_WARN_AGE   12/g" /etc/login.defs
}
function RHEL-06-000078 {
# Rule Title: The system must implement virtual address space randomization.
	sysctl -w kernel.randomize_va_space=1
}

function RHEL-06-000162 {
# Rule Title: The audit system must switch the system to single-user mode when 
# available audit storage volume becomes dangerously low.
	sed -i 's/admin_space_left_action\ =\ SUSPEND/admin_space_left_action\ =\ SINGLE/g' /etc/audit/auditd.conf
}

function RHEL-06-000233 {
# Rule Title: The SSH daemon must ignore .rhosts files.
	sed -i 's/#IgnoreRhosts/IgnoreRhosts/g' /etc/ssh/sshd_config
}

# Here's how all of the checks should look
function v-00000 {
	# make sure a parameter was passed
	if [ $# -eq 0 ]; then
		# Alert the user
		echo "Something went wrong"
		# Exit the program
		exit
	# determine parameter
	elif [ `echo $1 | awk '{print tolower($0)}'` == "check" ]; then
		echo "Checking for V-00000"
		# do some stuff
		result = true # or false
		if [ $result == true ]; then
			echo "Remediation required"
			# maybe prompt the user?
			v-00000 "remediate"
		else
			echo "No remediation required"
			# this seems a little bit much if we call the same function
			# after remediation. Maybe some sort of intelligence here?
		fi
	elif [ `echo $1 | awk '{print tolower($0)}'` == "remediate" ]; then
		echo "Remediating for V-00000"
		# do some stuff
		v-00000 "check"
		# hopefully, at this point, the remediation worked, and you're clear.
		
		# maybe the check should actually return true or false...
	else
		echo "Something else went wrong"
		exit
}

























