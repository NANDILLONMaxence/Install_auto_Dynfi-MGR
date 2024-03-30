# Automated for Dynfi Manager Installation on Debian 11/12...

This script automates the installation process for setting up Java 11, MongoDB, and Dynfi Manager on any Linux system. It downloads and installs the necessary components, sets up environment variables, and starts the required services for a functional setup.

## Prerequisites

- `sudo` or administrative privileges on your Linux system.
- Internet connection to download packages.
- Compatible Linux distribution: Debian (tested on Debian 11/12).

## Features

- Downloads and installs Java 11 from the official OpenJDK repository.
- Sets Java 11 as the default Java version and adds to the system PATH.
- Installs Dynfi Manager for network monitoring and management.
- Configures MongoDB Server for database operations.

## Installation Instructions

1. Clone the repository or download the `001_Dynfi_MGR_Debian.bash` script:

    ```bash
    git clone https://github.com/NANDILLONMaxence/Install_auto_Dynfi-MGR.git
    ```

2. Navigate to the script directory:

    ```bash
    cd Install_auto_Dynfi-MGR
    ```

3. Make the script executable:

    ```bash
    chmod +x 001_Dynfi_MGR_Debian.bash
    ```

4. Run the script:

    ```bash
    ./001_Dynfi_MGR_Debian.bash
    ```

5. Follow the on-screen instructions to complete the installation of Java 11, MongoDB, and Dynfi Manager.

## Configuration

- Default Java version is set to Java 11.
- Dynfi Manager configuration file: `/etc/dynfi.conf`

  # Config dynfi.conf
  
  ```bash
  echo "
  # This is DynFi Manager configuration file.
  # This file must follow properties format: https://en.wikipedia.org/wiki/.properties.
  # Run \`dynfi help\` or visit http://dynfi.com for more help.

  # Configuration Portal and connection BDD
  ipAndPort= 0.0.0.0:9090
  useHttps=false
  mongoClientUri=mongodb://localhost        #[ip]:[port: 27017]
  mongoDatabase=dynfi" | sudo tee /etc/dynfi.conf > /dev/null

  sudo systemctl restart dynfi.service 
  ```
  
- MongoDB configuration file: `/etc/mongod.conf`

  ```bash
  # New config MongoDB
  echo "
  # mongod.conf

  # for documentation of all options, see:
  #   http://docs.mongodb.org/manual/reference/configuration-options/

  # Where and how to store data.
  storage:
    dbPath: /var/lib/mongodb
    journal:
      enabled: true
  #  engine:
  #  wiredTiger:

  # where to write logging data.
  systemLog:
    destination: file
    logAppend: true
    path: /var/log/mongodb/mongod.log

  # network interfaces
  net:
    port: 27017
    bindIp: 0.0.0.0


  # how the process runs
  processManagement:
    timeZoneInfo: /usr/share/zoneinfo

  security:
    authorization: enabled # For bdd externe

  #operationProfiling:

  #replication:

  #sharding:

  ## Enterprise-Only Options:

  #auditLog:

  #snmp:" | sudo tee /etc/mongod.conf > /dev/null

  sudo systemctl restart mongod
  sudo systemctl daemon-reload
  ```

## Notes

- This script is tested on Debian 10/11 and Ubuntu. Additional steps may be needed for other distributions.
- Ensure that you configure Dynfi Manager and MongoDB according to your requirements after installation.

## Contributions

#### Contributions are welcome! If you have suggestions or improvements, feel free to open an issue or submit a pull request.
----

