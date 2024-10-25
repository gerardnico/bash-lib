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
* [crypto::get_file_type](#cryptoget_file_type)
* [crypto::is_rsa](#cryptois_rsa)
* [crypto::is_openssh_private_key](#cryptois_openssh_private_key)
* [crypto::is_private_key](#cryptois_private_key)
* [crypto::get_private_key_algo](#cryptoget_private_key_algo)
* [crypto::is_key](#cryptois_key)
* [crypto::is_protected_key](#cryptois_protected_key)

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

### crypto::get_file_type

Return the type of file

#### Arguments

* **$1** (string): - the path

#### Output on stdout

* kdbx or pem

### crypto::is_rsa

Return if this is RSA Key material

#### Arguments

* **$1** (string): - the path

#### Exit codes

* **0**: if true
* **1**: if false or unknown

### crypto::is_openssh_private_key

Return if this is OpenSSH Private Key
We don't known the algorithm

#### Arguments

* **$1** (string): - the path

#### Exit codes

* **0**: if true
* **1**: if false

### crypto::is_private_key

Return if this is a Private Key

#### Arguments

* **$1** (string): - the path

#### Exit codes

* **0**: if true
* **1**: if false

### crypto::get_private_key_algo

Return the private key algo

#### Arguments

* **$1** (string): - the path

#### Exit codes

* **0**: if true
* **1**: if false or unknown

### crypto::is_key

Return if this is a Key
We don't known the algorithm

#### Arguments

* **$1** (string): - the path

#### Exit codes

* **0**: if true
* **1**: if false

### crypto::is_protected_key

Return if the key is protected

#### Example

```bash
STATUS=$(crypto::is_protected_key "$FILE" && echo $? || echo $?)
# note the `&& echo $? || echo $?` is to get the status in all case
# and not exit bash if the bash is set to fail for any error (ie `set -e`)
```

#### Arguments

* **$1** (string): - the path

#### Exit codes

* **0**: if true
* **1**: if false
* **2**: if this is not a Open SSH private key or not supported

