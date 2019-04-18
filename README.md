# Private Contact Discovery Service (Beta)

The private contact discovery micro-service allows clients to discover which of their
contacts are registered users, but does not reveal their contacts to the service operator
or any party that may have compromised the service.

## Building the SGX enclave (optional)

### Building reproducibly with Docker

#### Prerequisites:
- GNU Make
- Docker (able to run debian image)

`````
$ make -C <repository_root>/enclave
`````

The default docker-install target will create a reproducible build environment image using
enclave/Dockerfile, build the enclave inside a container based on the image, and install
the resulting enclave and jni libraries into service/src/main/resources/. The Dockerfile
will download a stock debian Docker image and install exact versions of the build tools
listed in enclave/docker/build-deps. Make will then be run inside the newly built Docker
Debian image as in the [Building with Debian](#building-with-debian) section below:

If you need to update a package in the build environment, remove it from
enclave/docker/build-deps, run `make docker`, and check in the resulting changes to the
build-deps file.

If you need to add a package to the build environment, add it to enclave/debian/control
and repeat the same steps.

### Building with Debian

#### Prerequisites:
- GNU Make
- gcc-6
- devscripts (debian package)
- [Intel SGX SDK v2.1.3 SDK](https://github.com/intel/linux-sgx/tree/sgx_2.1.3) build dependencies

`````
$ make debuild derebuild
`````

`debuild` is a debian tool used to build debian packages after it sanitizes the
environment and installs build dependences. The primary advantage of using debian
packaging tools in this case is to leverage the [Reproducible
Builds](https://wiki.debian.org/ReproducibleBuilds) project. While building a debian
package, `debuild` will record the names and versions of all detected build dependencies
into a *.buildinfo file. The Reproducible Builds Project's `derebuild.pl` script can then
read the buildinfo file to drill down in the [Debian Snapshot
Archive](http://snapshot.debian.org/) to output the list of packages and generate an apt
sources.list which should contain all of those packages. The list of packages should then
be checked in as build-deps in the enclave/docker/ folder, along with sources.list and
buildinfo, which will then be used to reproduce the build when running `make docker`
again in the future.

The `debuild` target also builds parts needed from the Intel SGX SDK v2.1.3 after cloning it
from github.

### Building without Docker or Debian:

#### Prerequisites:
- GNU Make
- gcc-6
- [Intel SGX SDK v2.1.3 SDK](https://github.com/intel/linux-sgx/tree/sgx_2.1.3) (or its build dependencies)
- [Intel End-to-End Example](https://software.intel.com/en-us/articles/code-sample-intel-software-guard-extensions-remote-attestation-end-to-end-example)

`````
$ make -C <repository_root>/enclave all install
`````

The `all` target will probably fail to reproduce the same binary as above, but doesn't
require Docker or Debian Linux.

If `SGX_SDK_DIR`, or `SGX_INCLUDEDIR` and `SGX_LIBDIR`, are not specified, the Intel SGX SDK
will be cloned from github and any required libraries will be built. The SDK build
prerequisites should be present in this case.

The `install` target copies the enclave and jni libraries to service/src/resources/, which
should potentially be checked in to be used with the service.

NB: the installed enclave will be signed with `SGX_FLAGS_DEBUG` enabled by an automatically
generated signing key. Due to Intel SGX licensing requirements, a debug enclave can
currently only be run with the SGX debug flag enabled, allowing inspection of its
encrypted memory, and invalidating its security properties. To use an enclave in
production, the generated libsabd-enclave.signdata file must be signed using a signing key
whitelisted by Intel, which can then be saved as libsabd-enclave.sig with public key at
libsabd-enclave.pub, and signed using `make signed install`.

## Prerequisites

### Check the SGX is working and and enable SGX driver
- [check supports Intel SGX](https://github.com/ayeks/SGX-hardware)
- [enable sgx-driver by c++ coding](https://github.com/ericfjl/signal-test.git)

### Redis Sentinel
- [Redis Sentinel — High Availability: Everything you need to know from DEV to PROD: Complete Guide](https://medium.com/@amila922/redis-sentinel-high-availability-everything-you-need-to-know-from-dev-to-prod-complete-guide-deb198e70ea6
)


`````
$ sudo apt-get update
$ sudo apt-get install build-essential tcl
$ sudo apt-get install libjemalloc-dev  (Optional)
$ curl -O http://download.redis.io/redis-stable.tar.gz
$ tar xzvf redis-stable.tar.gz
$ cd redis-stable
$ make
$ make test
$ sudo make install
$ cp && edit redis.conf + sentinel.conf
`````
file|master|slave1|slave2
----|:----:|:-----:|:------:
redis.conf|6379|6380|6381
sentinel.conf|26379|26380|26381

### running the redis && sentinel
`````
$ sudo ./src/redis-server redis-master.conf &
$ sudo ./src/redis-server redis-slave1.conf &
$ sudo ./src/redis-server redis-slave2.conf &
$ sudo ./src/redis-server sentinel-master.conf --sentinel &
$ sudo ./src/redis-server sentinel-slave1.conf --sentinel &
$ sudo ./src/redis-server sentinel-slave2.conf --sentinel &

  notice:must input sudo password, then do the command(sudo ./src/redis-server sentinel-master.conf --sentinel &)

`````

## Building the service

`````
$ cd <repository_root>
$ mvn package
`````

## Running the service

### Runtime requirements:
- [Intel SGX SDK v2.1.3 PSW](https://github.com/intel/linux-sgx/tree/sgx_2.1.3#install-the-intelr-sgx-psw)

`````
$ cd <repository_root>
$ java -jar service/target/contactdiscovery-<version>.jar server service/config/yourconfig.yml
`````

## fix [ContactDiscoveryService](https://github.com/signalapp/ContactDiscoveryService) 's bugs 
### fix bug(`couldn’t read pen certificate`) in `org.whispersystems.contactdiscovery.client.IntelClient`
`````
  private static byte[] initializeKeyStore(String pemCertificate, String pemKey)
      throws IOException, KeyStoreException, CertificateException
  {
    // PEMParser             certificateReader = new PEMParser(new InputStreamReader(new ByteArrayInputStream(pemCertificate.getBytes())));
    final Reader filereader = new FileReader(pemCertificate);
    final PEMParser certificateReader = new PEMParser(filereader);
    X509CertificateHolder certificateHolder = (X509CertificateHolder) certificateReader.readObject();
    if (certificateHolder == null) {
      throw new CertificateException("couldn't read pem certificate");
    }

    X509Certificate       certificate       = new JcaX509CertificateConverter().getCertificate(certificateHolder);
    Certificate[]         certificateChain  = {certificate};

    // PEMParser  keyReader  = new PEMParser(new InputStreamReader(new ByteArrayInputStream(pemKey.getBytes())));
    final Reader frKey = new FileReader(pemKey);
    PEMParser  keyReader  = new PEMParser(frKey);
    PEMKeyPair pemKeyPair = (PEMKeyPair) keyReader.readObject();
    if (pemKeyPair == null) {
      throw new KeyStoreException("couldn't read pem private key");
    }
`````
### fix build error `Failure to find org.whispersystems:signal-service-java` version `2.7.8` to `2.12.8` in client.pom.xml [signal-service-java versioin](https://mvnrepository.com/artifact/com.github.turasa/signal-service-java)
`````
        <dependency>
            <groupId>org.whispersystems</groupId>
            <artifactId>signal-service-java</artifactId>
            <version>2.12.8</version>
        </dependency>
`````
### fix build error `Failure to find org.whispersystems:dropwizard-simpleauth` version `0.4.1` to `0.4.0` in service.pom.xml [issues : Not available in maven repository](https://github.com/signalapp/dropwizard-simpleauth/issues/4)
`````
        <dependency>
            <groupId>org.whispersystems</groupId>
            <artifactId>dropwizard-simpleauth</artifactId>
            <version>0.4.0</version>
        </dependency>
`````
