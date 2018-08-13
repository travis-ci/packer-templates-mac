from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils.six import iteritems, string_types

class XcodeException(Exception):
    pass

def installed_xcode_versions(module, xcversion_path):
    rc, out, err = module.run_command([
        xcversion_path,
        "installed"
    ])

    if rc != 0:
        raise XcodeException("Could not determine installed Xcode versions: {0}".format(err))

    lines = [line.split('\t')[0] for line in out.split('\n') if line != ""]
    return lines

def install_xcode(module, xcversion_path, version):
    rc, out, err = module.run_command([
        xcversion_path,
        "install",
        version
    ])

    if rc != 0:
        raise XcodeException("Could not install Xcode {0}: {1}".format(version, err))

def main():
    module = AnsibleModule(
        argument_spec=dict(
            version=dict(
                required=True,
                type='str'
            ),
            path=dict(
                required=False,
                default="/usr/local/bin",
                type='path'
            )
        ),
        supports_check_mode=True
    )

    p = module.params

    xcversion_path = module.get_bin_path(
        'xcversion',
        required=True,
        opt_dirs=[p['path']]
    )

    result = dict(changed=False)

    try:
        installed_versions = installed_xcode_versions(module, xcversion_path=xcversion_path)
        result['installed_versions'] = installed_versions

        if p['version'] not in installed_versions:
            result['changed'] = True

            if not module.check_mode:
                install_xcode(module, xcversion_path=xcversion_path, version=p['version'])
                result['msg'] = "Installed Xcode {0}".format(p['version'])
                result['installed_versions'] = installed_xcode_versions(module, xcversion_path=xcversion_path)

        module.exit_json(**result)
    except XcodeException as e:
        result['msg'] = str(e)
        module.fail_json(**result)

if __name__ == '__main__':
    main()
