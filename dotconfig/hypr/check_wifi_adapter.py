import os
import sys
import subprocess


def get_nmcli_devices():
    command = ["nmcli", "dev"]
    result = subprocess.run(command, capture_output=True, text=True)
    if result.returncode == 0:
        return result.stdout
    else:
        return f"Error: {result.stderr}"


if __name__ == '__main__':
    devices = get_nmcli_devices()
    if 'wlp0s13f0u3i3' in devices:
        os.system('nmcli dev set wlo1 man no')
        print('Detected external wireless adapter: "wlp0s13f0u3i3", disabling "wlo1" by default...')
    else:
        print('No external adapter "wlp0s13f0u3i3" detected.')
        sys.exit(0)

