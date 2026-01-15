# public-keys
Repository to manage the public keys of authorized employees. These keys will be synced to the different VPS's so the access is easily managed.

## Creating ssh key
Run the following command for creating your ssh key pair. Fill in a strong password.
```
ssh-keygen -t ed25519 -C "name@leblo.nl"
```
After the key pair is created store your password somewhere safe, for example in LastPass.

> [!CAUTION]
> Do not us a key whithout a password.

## Guidelines and requirements
- The authorized_key file is in alphabetical order.
- Comments ALWAYS refer to a person or/and device.
- A password needs at least 12 characters
- A password needs at least 1 uppercase character, lowercase character, number and a symbol