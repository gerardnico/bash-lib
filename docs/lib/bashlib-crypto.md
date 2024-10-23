% bashlib-crypto(1) Version Latest | bashlib-crypto
# bashlib-crypto documentation

Library over cryptographic function (key, certificate, ...)

## DESCRIPTION

Library over cryptographic function (key, certificate, ...)

## Index

* [crypto::pem_to_base64](#cryptopem_to_base64)
* [crypto::generate_random_secret](#cryptogenerate_random_secret)
* [crypto::cert_print](#cryptocert_print)
* [crypto::print_bundled_certificate_old](#cryptoprint_bundled_certificate_old)
* [crypto::certs_expiration](#cryptocerts_expiration)

### crypto::pem_to_base64

Extract a public or private key from a pem file into a base 64 string without any line break

#### Arguments

* **$1** (path): - the path to a pem file

#### Exit codes

* **1**: - if no argument was passed
* **2**: - if the file does not exist
* **3**: - if the file does not have any private or public key

### crypto::generate_random_secret

- Generate a random secret key

#### Arguments

* **$1** (number): the number of bits (32 by default)
* **$2** (string): the output format:

#### Exit codes

* **1**: if the format is unknown

### crypto::cert_print

Print a single pem file in human text with one or more certificates

This function is capable to print all certificate
from bundled file such as:
```
-----BEGIN CERTIFICATE-----
xxxxxxxxxxxxxxxxxxxxxx
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
xxxxxxxxxxxxxxxxxxxxxx
-----END CERTIFICATE-----
```

#### Example

```bash
crypto:cert_print /path/to/my/pem/file
```

#### Arguments

* **$1** (string): one or more URI (ie a path)

### crypto::print_bundled_certificate_old

print as text each certificate in a bundle
deprecated for openssl storeutl

#### Arguments

* **$1** (string): the certificate in pem format (ie -----BEGIN CERTIFICATE-----, -----END CERTIFICATE-----)

### crypto::certs_expiration

Print the expiration from certs in a directory in ascendant order

#### Arguments

* **$1** (string): - the directory (current if not specified)

