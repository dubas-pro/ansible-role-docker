Ansible Role: Docker
====================

[![CI](https://github.com/dubas-pro/ansible-role-docker/actions/workflows/ci.yml/badge.svg)](https://github.com/dubas-pro/ansible-role-docker/actions/workflows/ci.yml)

Ansible role which installs Docker on Dubas Cloud's managed servers.

It is a wrapper around the [official Docker installation][docker_installation]
instructions for Debian-based distributions. It is designed to be as simple as possible, while still being flexible enough to allow for customizations.

- [Ansible Role: Docker](#ansible-role-docker)
  - [Requirements](#requirements)
  - [Supported Platforms](#supported-platforms)
  - [Role Variables](#role-variables)
  - [`defaults/main/main.yml`](#defaultsmainmainyml)
  - [`defaults/main/debian.yml`](#defaultsmaindebianyml)
  - [Dependencies](#dependencies)
  - [Example Playbook](#example-playbook)
  - [License](#license)
  - [Author Information](#author-information)

Requirements
------------

- Ansible 2.13 or higher.

Supported Platforms
-------------------

- Debian
  - bullseye, bookworm
- Ubuntu
  - focal, jammy

Role Variables
--------------

Variables with a suffix `_default` are defined in `vars` and should not be changed. To override them, define the variable without the suffix in your playbook.

`defaults/main/main.yml`
------------------------

- `docker_version`
  - Default: `latest`
  - Description: Docker version to install. Does not apply when `docker_packages_default` is overridden, so you will need to set this manually per package.
  - Type: `string`
  - Example: `5:24.0.6-1~ubuntu.22.04~jammy`
- `docker_packages_absent`
  - Default: `unset`
  - Description: Packages to remove. If unset, the role will use `docker_packages_absent_default`.
  - Type: `list`
  - Example: `['containerd', 'docker-compose', 'docker.io', 'runc']`
- `docker_packages`
  - Default: `unset`
  - Description: Packages to install. If unset, the role will use `docker_packages_default`.
  - Type: `list`
  - Example: `['docker-ce', 'docker-ce-cli', 'containerd.io']`
- `docker_users`
  - Default: `[]`
  - Description: Users to add to the `docker` group.
  - Type: `list`
  - Example: `['ansible']`
- `docker_daemon_options`
  - Default: `{}`
  - Description: Options to add to the Docker daemon configuration.
  - Type: `dict`
  - Example:

    ```yaml
    docker_daemon_options:
      log-driver: json-file
      log-opts:
        max-size: 10m
        max-file: 3
    ```

- `docker_daemon_management_disabled`
  - Default: `false`
  - Description: Disable daemon management. Useful if you want to manage the daemon yourself.
  - Type: `bool`
  - Example: `true`
- `docker_service_management_disabled`
  - Default: `false`
  - Description: Disable service management. Useful if you want to manage the service yourself.
  - Type: `bool`
  - Example: `true`
- `docker_service_state`
  - Default: `started`
  - Description: State of the Docker service.
  - Type: `string`
  - Example: `stopped`
- `docker_service_enabled`
  - Default: `true`
  - Description: Enable the Docker service on boot.
  - Type: `bool`
  - Example: `false`
- `docker_repository`
  - Default: `https://download.docker.com/linux`
  - Description: Docker repository to use. Useful if you want to use a different trusted repository.
  - Type: `string`
- `docker_architecture_mapping`
  - Default:

    ```yaml
    docker_architecture_mapping:
      aarch64: arm64
      armv7l: armhf
      x86_64: amd64
    ```

  - Description: Mapping of Ansible architecture to Docker architecture.
  - Type: `dict`
- `docker_distribution_mapping`
  - Default:

    ```yaml
    docker_distribution_mapping:
      Linux Mint: Ubuntu
      elementary OS: Ubuntu
      Pop!_OS: Ubuntu
    ```

  - Description: Mapping of Ansible distribution to Docker distribution. This is used to determine the correct repository to use for the Ubuntu-based distributions, but not limited to that.
  - Type: `dict`

`defaults/main/debian.yml`
--------------------------

- `docker_apt_dependencies`
  - Default: `['ca-certificates', 'curl', 'gnupg', 'lsb-release']`
  - Description: Dependencies listed in the Docker Engine installation instructions, excluding `lsb-release` which is needed for determining the distribution release.
  - Type: `list`
  - Example: `['ca-certificates', 'curl', 'gnupg']`
- `docker_apt_key_url`
  - Default: `{{ docker_repository }}/{{ docker_ansible_distribution | lower }}/gpg`
  - Description: URL to the Docker GPG key.
  - Type: `string`
  - Example: `https://download.docker.com/linux/ubuntu/gpg`
- `docker_apt_key_directory`
  - Default: `/etc/apt/keyrings`
  - Description: Directory to store the Docker GPG key as listed in the Docker Engine installation instructions.
  - Type: `string`
  - Example: `/usr/share/keyrings`
- `docker_apt_key_file`
  - Default: `docker.gpg`
  - Description: Filename of the Docker GPG key as listed in the Docker Engine installation instructions.
  - Type: `string`
  - Example: `docker-archive-keyring.gpg`
- `docker_apt_repository_channel`
  - Default: `stable`
  - Description: Channel of the Docker repository to use.
  - Type: `string`
  - Example: `nightly`
- `docker_apt_repository_arch`
  - Default: `{{ docker_architecture_mapping[ansible_architecture] | default(ansible_architecture) }}`
  - Description: Architecture of the Docker repository to use.
  - Type: `string`
  - Example: `arm64`
- `docker_apt_repository`
  - Default: `deb [arch={{ docker_apt_repository_arch }} signed-by={{ docker_apt_key_directory }}/{{ docker_apt_key_file }}] {{ docker_repository }}/{{ docker_ansible_distribution | lower }} {{ ansible_distribution_release }} {{ docker_apt_repository_channel }}`
  - Description: Docker repository to use, you can override this to use a different trusted repository.
  - Type: `string`
  - Example: `deb [arch=arm64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu focal stable`
- `docker_apt_repository_file`
  - Default: `docker`
  - Description: Filename of the Docker repository as listed in the Docker Engine installation instructions.
  - Type: `string`
  - Example: `docker-ce`

Dependencies
------------

None.

Example Playbook
----------------

Create a `requirements.yml` file in your project:

```yaml
---
roles:
  - name: dubas.docker
    src: https://github.com/dubas-pro/ansible-role-docker.git
    version: 1.0.0
```

Install the role:

```bash
ansible-galaxy install --role-file requirements.yml
```

Create a playbook `playbook.yml`:

```yaml
---
- name: Example
  hosts: all
  become: true
  roles:
    - role: dubas.docker
```

License
-------

This project is licensed under the terms of the [EUPL-1.2 or later](LICENSE).

Author Information
------------------

[arkadiyasuratov][author_url]

[author_url]: https://github.com/arkadiyasuratov
[docker_installation]: https://docs.docker.com/engine/install/
