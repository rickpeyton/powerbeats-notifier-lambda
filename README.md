# PowerBeats Notifier Lambda

When PowerBeats are in stock send myself a text message

## Usage

A Ruby Lambda triggered by a Cloudwatch event

Utilizes my Apple Store Inventory Checker gem (https://github.com/rickpeyton/apple-store-inventory-checker)

## Building

```bash
$ ./build_lambda_zip.sh
```

This will use the Dockerfile in the root of the project to package the function inside an environment approxmating the AWS Ruby Lambda server.
