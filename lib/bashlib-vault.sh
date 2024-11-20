# @name bashlib-vault documentation
# @brief Library to retrieve secret from vault expression
# @description
#    Retrieve secrets from vault or pass secret manager
#

# shellcheck source=./bashlib-echo.sh
source "${BASHLIB_LIBRARY_PATH:-}${BASHLIB_LIBRARY_PATH:+/}bashlib-echo.sh"

# Declare an associative array to store the field values
declare -A BASHLIB_SECRETS_MAP
BASHLIB_SECRETS_MAP=()

# @description
#    Return a field from a Hashicorp Vault secret
#
#    Note: The vault returns data at the secret level (that contains fields),
#    we cache them in the global BASHLIB_SECRETS_MAP associative array
#    If the secret has already been retrieved, the field will be retrieved from it
#
# @args $1 string A vault path in the form: `vault:$ENGINE/path/to/secret/field`
# @example
#    # Get a Github token store in the secret engine, github secret, token field
#    vault::get_secret_from_vault vault:secret/github/token
#
# @stdout Return the secret field value
# @exitcode 1 if the secret or the field was not found
vault::get_secret_from_vault() {

  SECRET_FIELD_PATH=${1}
  export BASHLIB_SECRETS_MAP

  # Check if we have already the value
  VALUE=${BASHLIB_SECRETS_MAP["$SECRET_FIELD_PATH"]:-}
  if [ "$VALUE" != "" ]; then
    echo "$VALUE";
    return
  fi

  # Extract the FIELD (last part of the remaining path)
  IFS='/' read -ra PATH_PARTS <<< "$SECRET_FIELD_PATH"
  FIELD=${PATH_PARTS[-1]}

  # Remove the FIELD from the SECRET_PATH
  SECRET_PATH=${SECRET_FIELD_PATH%/"$FIELD"}

  # Make a Vault call to get the actual value using the extracted MOUNT
  if ! SECRET_KV_JSON=$(vault kv get -format=json "$SECRET_PATH"); then
    echo::err "Error: Failed to retrieve secret from Vault for mount: $MOUNT, path: $SECRET_PATH"
    exit 1
  fi

  # Extract the data portion of the secret
  SECRET_FIELDS=$(echo "$SECRET_KV_JSON" | jq -r '.data.data')

  # Iterate through each field in the secret and store in the associative array
  while IFS="=" read -r key value; do
      map_key="${SECRET_PATH}/${key}"
      BASHLIB_SECRETS_MAP["$map_key"]="$value"
  done < <(echo "$SECRET_FIELDS" | jq -r 'to_entries[] | "\(.key)=\(.value)"')

  # Do we got the field
  VALUE=${BASHLIB_SECRETS_MAP["$SECRET_FIELD_PATH"]:-}
  if [ "$VALUE" == "" ]; then
    echo::err "Error: No field found in the secret $SECRET_PATH"
    exit 1
  fi

  # Return the value
  echo "$VALUE";

}

# @description
#   If the value is a vault expression, get the value from the vault
#   or return the raw value otherwise
# @example
#    VALUE=$(vault::filter "$VALUE")
# @exitcode 1 if the vault value was not found
vault::filter(){

  VALUE="$1"

  # Set the VAULT_PREFIX variable
  local VAULT_PREFIX="vault:"
  # Check if VALUE starts with VAULT_PREFIX
  if [[ $VALUE == $VAULT_PREFIX* ]]; then

      # Extract the FULL QUALIFIED SECRET_PATH
      SECRET_FIELD_PATH=${VALUE#"$VAULT_PREFIX"}
      SECRET_FIELD_PATH=$(string::trim "$SECRET_FIELD_PATH")

      # Get the value from the vault
      if ! VALUE=$(vault::get_secret_from_vault "$SECRET_FIELD_PATH"); then
        echo::err "Vault value not found at the path  $SECRET_FIELD_PATH"
        echo $SECRET_FIELD_PATH
        exit 1;
      fi

  fi
  echo "$VALUE"

}

# @description
#   A wrapper to the pass store manager
#   You can choose the cli between
#   * [pass](https://www.passwordstore.org/) (Default)
#   * [gopass](https://www.gopass.pw/)
#
#   To use `gopass`, you need to set the env `BASHLIB_VAULT_PASS_CLI` to `gopass`
#   ```bash
#   export BASHLIB_VAULT_PASS_CLI=gopass
#   ```
#
# @example
#    export BASHLIB_VAULT_PASS_CLI=gopass
#    vault::pass path/to/my/secret
#
vault::pass(){
  ${BASHLIB_VAULT_PASS_CLI:-pass} "$@"
}
