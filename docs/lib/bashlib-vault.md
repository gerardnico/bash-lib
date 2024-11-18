% bashlib-vault(1) Version Latest | bashlib-vault
# bashlib-vault documentation

Library to retrieve secret from vault expression

## DESCRIPTION

Retrieve secrets from vault or pass secret manager

## Index

* [vault::get_secret_from_vault](#vaultget_secret_from_vault)
* [vault::filter](#vaultfilter)
* [vault::pass](#vaultpass)

### vault::get_secret_from_vault

Return a field from a Hashicorp Vault secret

Note: The vault returns data at the secret level (that contains fields),
we cache them in the global BASHLIB_SECRETS_MAP associative array
If the secret has already been retrieved, the field will be retrieved from it

#### Example

```bash
# Get a Github token store in the secret engine, github secret, token field
vault::get_secret_from_vault vault:secret/github/token
```

#### Exit codes

* **1**: if the secret or the field was not found

#### Output on stdout

* Return the secret field value

### vault::filter

If the value is a vault expression, get the value from the vault
or return the raw value otherwise

#### Example

```bash
VALUE=$(vault::filter "$VALUE")
```

### vault::pass

A wrapper to the pass store manager
You can choose the cli between
* [pass](https://www.passwordstore.org/) (Default)
* [gopass](https://www.gopass.pw/)

To use `gopass`, you need to set the env `BASHLIB_VAULT_PASS_CLI` to `gopass`
```bash
export BASHLIB_VAULT_PASS_CLI=gopass
```

#### Example

```bash
export BASHLIB_VAULT_PASS_CLI=gopass
vault::pass path/to/my/secret
```

