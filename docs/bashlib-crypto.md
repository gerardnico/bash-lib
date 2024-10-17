# bashlib-crypto documentation

Library over cryptographic function (key, certificate, ...)

## Overview

Library over cryptographic function (key, certificate, ...)

## Index

* [crypto::pem_to_base64](#cryptopem_to_base64)
* [crypto::generate_random_secret](#cryptogenerate_random_secret)
* [crypto::certificate_to_text](#cryptocertificate_to_text)
* [crypto::print_bundled_certificate_old](#cryptoprint_bundled_certificate_old)

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

### crypto::certificate_to_text

- Print certificate even if they are bundled

#### Arguments

* **$1** (string): one or more URI (ie a path)

### crypto::print_bundled_certificate_old

print as text each certificate in a bundle
deprecated for openssl storeutl

#### Arguments

* **$1** (string): the certificate in pem format (ie -----BEGIN CERTIFICATE-----, -----END CERTIFICATE-----)

