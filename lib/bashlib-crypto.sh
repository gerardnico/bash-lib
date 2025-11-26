# @name bashlib-crypto documentation
# @brief Library over cryptographic function (key, certificate, ...)
# @description Library over cryptographic function (key, certificate, ...)
#
#

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}" || echo "${BASH_SOURCE[0]}")")" && pwd)"
# shellcheck source=./bashlib-echo.sh
source "${SCRIPT_DIR}/bashlib-echo.sh"

# @description Extract a public or private key from a pem file into a base 64 string without any line break
# @arg $1 path - the path to a pem file
# @exitcode 1 - if no argument was passed
# @exitcode 2 - if the file does not exist
# @exitcode 3 - if the file does not have any private or public key
crypto::pem_to_base64() {
  if [ "$#" -ne 1 ]; then
      echo::err "Usage: $0 <pem_file>"
      echo::err  "  pem_file: Path to the PEM file"
      return 1
  fi

  PEM_FILE=$1

  # Check if the PEM file exists
  if [ ! -f "$PEM_FILE" ]; then
      echo::err "PEM file does not exist: $PEM_FILE"
      return 2
  fi

  # Detect key type and extract
  if grep -q "PRIVATE KEY" "$PEM_FILE"; then
      echo::info "Detected private key. Extracting and encoding:"
  elif grep -q "PUBLIC KEY" "$PEM_FILE"; then
      echo::info "Detected public key. Extracting and encoding:"
  else
      echo::err "Error: Unable to determine key type. Ensure the file contains a valid PEM-encoded key."
      return 3
  fi

  # Extract the key content and base64 encode it
  grep -v --fixed-strings -- '-----BEGIN' "$PEM_FILE" | \
  grep -v --fixed-strings -- '-----END' | \
  grep -v "^$" | \
  tr -d '\n'
  # already in base64
  # Add a newline at the end for better readability
  echo

}


# @description - Generate a random secret key
# @arg $1 number the number of bits (32 by default)
# @arg $2 string the output format:
#    * `base64` (default)
#    * or `hex`
# @exitcode 1 if the format is unknown
crypto::generate_random_secret(){

  BIT_NUMBER=${1:-32}
  OUTPUT_FORMAT=${1:-'base64'}

  case $OUTPUT_FORMAT in
    'base64')
      openssl rand -base64 "$BIT_NUMBER" # base b64 transform
      ;;
    'hex')
      openssl rand -hex "$BIT_NUMBER" # hexa transform
      ;;
    *)
      echo::err "The output format ($OUTPUT_FORMAT) is unknown"
      return 1
  esac

}

# @description
#    Print a single pem file in human text with one or more certificates
#
#    This function is capable to print all certificate
#    from bundled file such as:
#    ```
#    -----BEGIN CERTIFICATE-----
#    xxxxxxxxxxxxxxxxxxxxxx
#    -----END CERTIFICATE-----
#    -----BEGIN CERTIFICATE-----
#    xxxxxxxxxxxxxxxxxxxxxx
#    -----END CERTIFICATE-----
#    ```
# @arg $1 string one or more URI (ie a path)
# @example
#    crypto:cert_print /path/to/my/pem/file
#
crypto::cert_print(){

  # A file in a chain (ie bundle of certificate) such as

  CRT_FILE=$1
  # https://serverfault.com/questions/590870/how-to-view-all-ssl-certificates-in-a-bundle
  # https://www.openssl.org/docs/man1.1.1/man1/openssl-storeutl.html
  # OpenSSL 1.1.1.
  openssl storeutl -noout -text -certs "$CRT_FILE"
  # The storeutl command can be used to display the contents fetched from the given URIs
  # -noout prevents output of the PEM data
  # -text prints out the objects in text form,
  # -certs Only select the certificates from the given URI

}

# @description
#   print as text each certificate in a bundle
#   deprecated for openssl storeutl
# @arg $1 string the certificate in pem format (ie -----BEGIN CERTIFICATE-----, -----END CERTIFICATE-----)
crypto::print_bundled_certificate_old(){

    local CERTIFICATES=$1
    # Go into a temporary directory because we split the certificates into 2 files
    TEMP_DIR=$(path::create_temp_directory "kube")
    pushd "$TEMP_DIR" > /dev/null 2>&1 || exit 1

    # csplit to split the PEM certificates in 2
    # csplit [option]… input pattern…
    # https://www.gnu.org/software/coreutils/manual/html_node/csplit-invocation.html#csplit-invocation
    INPUT=-
    PATTERN="-----BEGIN CERTIFICATE-----"
    PREFIX="xx"
    REPEAT_COUNT_PATTERN='{*}'
    csplit  "--prefix=$PREFIX" --elide-empty-files "$INPUT" "/$PATTERN/" "$REPEAT_COUNT_PATTERN" <<< "$CERTIFICATES" > /dev/null 2>&1

    # Loop over the create files and print them in plain
    INDEX=1
    for FILE in ./"$PREFIX"*; do
          echo::echo ""
          echo::echo "####################################"
          echo::echo "# Certificate $INDEX"
          echo::echo "####################################"
          echo::echo ""
          openssl x509 -text -noout < "$FILE"
          ((INDEX++))

    done

    # Go back
    popd > /dev/null 2>&1 || exit 1

    # Clean things up
    rm -rf "$TEMP_DIR"
}

# @description
#     Print the expiration from certs in a directory in ascendant order
# @arg $1 string - the directory (current if not specified)
crypto::certs_expiration(){
    CERT_DIR=${1:-'.'}
    for crt in "$CERT_DIR"/*.crt; do
      printf '%s: %s\n'    "$(date --date="$(openssl x509 -enddate -noout -in "$crt"|cut -d= -f 2)" --iso-8601)" "$crt";
    done | sort
}


# @description
#     Return the type of file
# @arg $1 string - the path
# @stdout kdbx or pem
crypto::get_file_type() {

    local file="$1"

    # Check if file exists
    if [ ! -f "$file" ]; then
        echo "Error: File '$file' not found"
        exit 1
    fi

    # Get the file type
    FILE_TYPE=$(file "$file")

    if ( shopt -s nocasematch; [[ $FILE_TYPE =~ KDBX ]] ); then
      echo "kdbx"
      return;
    fi

    if ( shopt -s nocasematch; [[ $FILE_TYPE =~ OpenSSH ]] ); then
        # Example of value:
        # OpenSSH RSA public key
        # OpenSSH private key
        echo "pem"
        return;
    fi

    echo::err "We are unable to determine the type of file"
    return 1

}

# @description
#     Return if this is RSA Key material
# @arg $1 string - the path
# @exitcode 0 if true
# @exitcode 1 if false or unknown
crypto::is_rsa(){
  # When the file is a public key
  # When the file is a private key, `file` does not return the algorithm. It returns `OpenSSH private key`
  if [[ $(file -b "$1") == "OpenSSH RSA public key" ]]; then
    return;
  fi
  if ! crypto::is_openssh_private_key "$1"; then
    return 1
  fi
  (
    shopt -s nocasematch;
    [[ $(crypto::get_private_key_algo "$1") =~ rsa ]]
  )
}

# @description
#     Return if this is OpenSSH Private Key
#     We don't known the algorithm
# @arg $1 string - the path
# @exitcode 0 if true
# @exitcode 1 if false
crypto::is_openssh_private_key(){

  [[ $(file -b "$1") == "OpenSSH private key" ]]

}

# @description
#     Return if this is a Private Key
# @arg $1 string - the path
# @exitcode 0 if true
# @exitcode 1 if false
crypto::is_private_key(){

  [[ $(file -b "$1") =~ "private key" ]]

}

# @description
#     Return the private key algo
# @arg $1 string - the path
# @exitcode 0 if true
# @exitcode 1 if false or unknown
crypto::get_private_key_algo(){
  ssh-keygen -l -f "$1" | sed -n 's/.*(\(.*\)).*/\1/p'
}

# @description
#     Return if this is a Key
#     We don't known the algorithm
# @arg $1 string - the path
# @exitcode 0 if true
# @exitcode 1 if false
crypto::is_key(){

  [[ $(file -b "$1") =~ "key" ]]

}

# @description
#     Return if the key is protected
# @arg $1 string - the path
# @exitcode 0 if true
# @exitcode 1 if false
# @exitcode 2 if this is not a Open SSH private key or not supported
# @example
#   STATUS=$(crypto::is_protected_key "$FILE" && echo $? || echo $?)
#   # note the `&& echo $? || echo $?` is to get the status in all case
#   # and not exit bash if the bash is set to fail for any error (ie `set -e`)
crypto::is_protected_key(){

    if ! crypto::is_openssh_private_key "$1"; then
        echo::debug "The file $1 is not a OpenSSH private key"
        return 2
    fi

    # Try to read the key with ssh-keygen
    # -y flag attempts to read the private key and output the public key
    # -P "" specifies an empty password
    if ssh-keygen -y -P "" -f "$1" &>/dev/null; then
        echo::debug "Key is NOT password protected"
        return 1
    fi

    return 0;

}