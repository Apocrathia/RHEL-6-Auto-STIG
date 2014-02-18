RHEL-6-Auto-STIG
================

A series of scripts designed to automate the remediation process of a fresh RHEL or CentOS 6 install.

The goal of this program is to provide a simplified and interactive way of hardening a RHEL 6 system without installing any additional packages

## Concept:
Every rule gets checked, then remediate if needed. This can be done in an interactive mode, so that the administrator knows what exactly is going on. While some programs may do the whole process, it is sometimes unknown as to how. Which can pose future problems

## To-Do
* Prompt user for MAC, Sensitivity, and verbosity
* Arguments

## Probably won't happen
* RHEL 5 (Just give it up. It's 2014.)

## Notes
* I'm currently working off of v1 of the [RHEL 6 STIG](http://www.stigviewer.com/stig/b38ff180e9c248f9730f0e18eaf0391ee50afab4). Luckily, all of the checks are the same, regardless of the profile. Release 2 is out, but it just has the XCCDF content and that's it.
# The content [directly from DISA](http://iase.disa.mil/stigs/os/unix/u_redhat_6_v1r2_manual.zip) is available on their site without PKI authentication.
* A resource that I have used heavily in the past has been [Fedora's Aqueduct](https://fedorahosted.org/aqueduct/) project, which provides a lot of functionality similar to my own goals. However, it can be a bit of a convoluted mess at times. The entire STIG text is in each script, but it references by RHEL #'s rather that V (vulnerability) #'s. I will be taking a lot of code from there, as it's a great start. One notable issue with it, is that it has a heavy emphasis on Puppet. I will modify the modules to work with this project, as the idea is to be able to run this on a system with nothing on it, and no connection to the internet. Just load it from a disc or usb drive (which will just get blocked anyways).

## Design
* I want the each check to be broken into two subroutines; check and remediate. The script will automatically run the check, apply the remediation if required, then recheck.
* By default, the script will run in an interactive mode, prompting the user before making any changes to the system. However, I will create a flag that can be used to jun run with no intervention, as this will make more sense if you have several machines they you're trying to setup at once.
