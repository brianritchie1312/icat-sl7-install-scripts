# icat-sl7-install-scripts
Bash scripts to install ICAT and/or IDS on Scientific Linux 7.

The starting point should be an SL7 VM as created under STFC's SCD Cloud service.
The scripts will install and configure the following components:

  * Java JDK 1.8
  * MySQL 14.14 (if ICAT is requested)
  * Python pip and the python requests module (ICAT)
  * Glassfish 4.0
  * MySQL DB connector (5.1.39) for Glassfish (ICAT)
  * ICAT DB authenticator 1.2.0 (ICAT)
  * ICAT LDAP authenticator 1.2.0 (ICAT)
  * ICAT server 4.8.0 (if requested)
  * IDS storage_file plugin 1.3.3 (if IDS requested)
  * IDS server 1.7.0 (if requested)

For Glassfish and subsequent components, a dedicated glassfish user is created and used.

## Configuration

The script config.bash can be used to control the installation and to
define properties used by it.  See the file for details.  As supplied,
it is configured to install ICAT but not IDS.

## Warning

These scripts are not future-proof.  They may be upset by changes to
the basic SL7 image. They are not designed to be repeatable: if the
installation fails, recovery will almost certainly be convoluted, and
not just a matter of fixing a configuration setting and re-running.
They will almost certainly not work for other versions of the ICAT
components without modification and care.
