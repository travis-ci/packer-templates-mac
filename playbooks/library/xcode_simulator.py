from ansible.module_utils.basic import AnsibleModule
import os
import os.path
import glob

class XcodeException(Exception):
    pass

def all_simulators(module, xcversion_path):
    rc, out, err = module.run_command([
        xcversion_path,
        'simulators'
    ])

    if rc != 0:
        raise XcodeException('Cannot determine available simulators: {0}'.format(err))

    simulators = {}
    current_xcode = None

    lines = out.split('\n')
    for line in lines:
        if not line:
            continue
        elif line.startswith('Xcode '):
            # parse new Xcode version
            words = line.split(' ')
            current_xcode = words[1]
            simulators[current_xcode] = {}
        else:
            # parse simulator version
            index = line.find(' Simulator')
            if index == -1:
                continue
            else:
                is_installed = '(installed)' in line
                name = line[0:index]
                simulators[current_xcode][name] = is_installed

    return simulators

def xcode_simulators(module, xcversion_path, xcode):
    sims = all_simulators(module, xcversion_path)

    if xcode not in sims:
        raise XcodeException('Xcode {0} is not installed. Found Xcodes: {1}'.format(xcode, sims.keys().join(', ')))

    return sims[xcode]

def simulators_to_install(module, simulators, requested):
    if requested:
        sims = []
        for sim in requested:
            if sim not in simulators:
                raise XcodeException('{0} simulator is not an available simulator runtime.'.format(sim))
            elif not simulators[sim]:
                sims.append(sim)
        return sims
    else:
        return [sim for (sim, installed) in simulators.items() if not installed]

def install_simulator(module, xcversion_path, simulator):
    rc, out, err = module.run_command([
        xcversion_path,
        'simulators',
        '--install={0}'.format(simulator)
    ])

    if rc != 0:
        raise XcodeException('Could not install {0} simulator: {1}'.format(simulator, err))

    # Remove the installer files as they take up a lot of disk space
    cache_dir = os.path.expanduser('~/Library/Caches/XcodeInstall')
    files_to_remove = glob.glob(os.path.join(cache_dir), '*.pkg') + glob.glob(os.path.join(cache_dir), '*.dmg')
    for f in files_to_remove:
        os.remove(f)

    return out

def main():
    module = AnsibleModule(
        argument_spec=dict(
            simulator=dict(
                type='list'
            ),
            xcode=dict(
                required=True,
                type='str'
            ),
            path=dict(
                default='/usr/local/bin',
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
        simulators = xcode_simulators(module, xcversion_path=xcversion_path, xcode=p['xcode'])
        result['simulators'] = simulators
        sims_to_install = simulators_to_install(module, simulators, p['simulator'])
        result['simulators_to_install'] = sims_to_install

        result['changed'] = bool(sims_to_install)
        result['msg'] = '{0} new simulators'.format(len(sims_to_install))

        if not module.check_mode:
            for sim in sims_to_install:
                install_simulator(module, xcversion_path, sim)

        module.exit_json(**result)
    except XcodeException as e:
        result['msg'] = str(e)
        module.fail_json(**result)


if __name__ == '__main__':
    main()
