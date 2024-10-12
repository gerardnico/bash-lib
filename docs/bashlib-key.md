# bashlib-key documentation

Library over cryptographic keys function

## Overview

Library over cryptographic keys function

## Index

* [key::pem_to_base64](#keypem_to_base64)

### key::pem_to_base64

Extract a public or private key from a pem file into a base 64 string without any line break

#### Arguments

* **$1** (-): the path to a pem file

#### Exit codes

* **1**: - if no argument was passed
* **2**: - if the file does not exist
* **3**: - if the file does not have any private or public key

