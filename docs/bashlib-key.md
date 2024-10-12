# bashlib-key documentation

Library over cryptographic keys function

## Overview

Library over cryptographic keys function

## Index

* [key::pem_to_base64](#keypem_to_base64)
* [key::generate_random_secret](#keygenerate_random_secret)

### key::pem_to_base64

Extract a public or private key from a pem file into a base 64 string without any line break

#### Arguments

* **$1** (path): - the path to a pem file

#### Exit codes

* **1**: - if no argument was passed
* **2**: - if the file does not exist
* **3**: - if the file does not have any private or public key

### key::generate_random_secret

- Generate a random secret key

#### Arguments

* **$1** (number): the number of bits (32 by default)
* **$2** (string): the output format:

#### Exit codes

* **1**: if the format is unknown

