# @name bashlib-key documentation
# @brief Library over cryptographic keys function
# @description Library over cryptographic keys function
#
#

source bashlib-echo.sh

# @description Extract a public or private key from a pem file into a base 64 string without any line break
# @arg $1 path - the path to a pem file
# @exitcode 1 - if no argument was passed
# @exitcode 2 - if the file does not exist
# @exitcode 3 - if the file does not have any private or public key
key::pem_to_base64() {
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
key::generate_random_secret(){

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