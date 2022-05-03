# GitHub

## Description

GitHub is a simple bash script which provides a collection of most used **git** Commands to create, clone, uptate and delete repository when using the **GitHub API**.
In order to encrypt GitHub access token, GitHub uses symmetric (password-based) authentication based on a trusted crypto implementation (openssl).

## Use

First, you should create a personal access token to use in place of a password withing the script - see [How to create a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).

Run `init.sh` script and tape your GitHub token previously generated. Copy the encrypted token and paste it into `GitHub.sh` in **encryptedPassword** variable.

#### Example usage:

```console
./GitHub create "<new_repository>"
```
Creates new repository.

```console
./GitHub -r "<repository_name>"
```
Push the locally committed changes to the remote branch.

```console
./GitHub -r "<repository_name>" -t <tag_name>
```
Push the locally committed changes to the remote branch with a tag name.

```console
./GitHub -p -r "<repository_name>"
```

Pull changes from remote repository.

Use **help** command for additional options.
