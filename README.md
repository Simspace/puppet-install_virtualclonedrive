# install_virtualclonedrive

#### Table of Contents
1. [Overview](#overview)
2. [Description](#description)
3. [Dependencies](#dependencies)
4. [Development](#development)

## Overview
This module will install virtual clone drive  on Windows hosts

## Description
In params.pp is the location to the installer.
In your site.pp
```puppet
node 'cheese.com' {
  class {'install_virtualclonedrive':}
}
```

## Dependencies
Note: You will need to extract the signing certificate from the installer and save it with the installer. This is because of how virtual clone drive is presenting itself to the OS.  
staging  
ACL  
windows_facts  
