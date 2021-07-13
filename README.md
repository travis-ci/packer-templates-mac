# macOS Packer Templates for Travis CI

This repo contains the [Packer](https://packer.io) templates for building images for Travis CI's macOS build environment.

## Build Process

Our Packer templates are stored in `templates/` as YAML files. Packer natively reads JSON, though, so our build process will convert these templates to JSON before feeding them to Packer.

The Rakefile will look for templates in the `templates/` directory and produce a Rake task to build that image. For instance, `templates/xcode10.0.yml` can be built by running `rake xcode10.0`.

We don't typically run Packer builds on our development machines. Instead, we have a dedicated `image-builder` host VM that already has a proper build environment set up inside our MacStadium network.

To support this workflow, instead of running your Packer builds with `rake`, use `bin/build-image` instead. This will:

1. Use `rsync` to copy your local changes over to the `image-builder` machine.
2. Open an SSH session to `image-builder`.
3. Open a `tmux` session for running the build.
4. `source` some environment variables that are needed for connecting to vSphere and the Apple Developer Portal.
5. Run `rake`, passing along any arguments you provided to `bin/build-image`.

You can think of the `bin/build-image` script as a version of `rake` that runs remotely on the image builder.

## Provisioning

We use [Ansible](https://ansible.com) to provision the macOS images. This makes it easier to maintain a common set of provisioning scripts that can be reused across various images. The idempotency provided by a tool like Ansible also makes it easier for us to iterate on changes in our provisioning by not requiring a blank slate for every change.

All Ansible related content is stored in the `playbooks/` directory. You do not need Ansible installed in order to build a Packer image. We install Ansible on the image being built, and use the `ansible-local` provisioner to run playbooks from inside the guest VM. That said, if you want to clone one of the vanilla VMs and work on the playbooks outside of a Packer build, perhaps to be able to rerun the provisioning without starting over every time, you can install Ansible locally and run it against an existing VM.

### A playbook for every image

Each Packer template in `templates/` should have a corresponding Ansible playbook in `playbooks/`. For instance, the Xcode 10 image template in `templates/xcode10.0.yml` is configured to run the playbook at `playbooks/xcode10.0.yml`.

The top-level playbook for a particular image should do two things:

* Import the `site.yml` common playbook for all images.
* Override any variables specific to that image.

  At a minimum, this means specifying an `xcode_version` for the image, but you should also specify any explicit versions of any tools installed by the image, since these are likely to change over time.

### What's in the common playbook?

The common `site.yml` playbook is imported the the playbooks for each image and specifies a few things:

* Which hosts the playbook should run on. This should always be `hosts: builders`. The `ansible-local` provisioner in the Packer template is configured to put the host in the `builders` group.
* Which user to run tasks as. This should always be `remote_user: travis`.
* Which roles to run tasks from. The different aspects of provisioning the image are broken down into logical Ansible roles. The order of these roles matters: they will run in the order they are listed, and some roles depend on others having already run.

  Each role also has a matching tag associated with it so that it's possible to limit which tasks run when running Ansible manually.

  Each role should have a `README.md` inside its corresponding directory in `playbooks/roles/` that explains what it does in more detail.


 