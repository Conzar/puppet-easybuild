import sys
import subprocess
import yaml

def helper():
    sys.stdout.write(
"""Usage of this script:
python install.py [software set] [EasyBuild version]

- The [software set] argument is mandatory and to be chosen among the software sets you defined in your YAML file. (At Uni.lu: core and experimental)
- The [EasyBuild version] argument is optional, and the format is simply the three digit version number of the EasyBuild version you want to use. (e.g. 1.15.2 to use EasyBuild version 1.15.2).
If not specified, the script will use the version chosen by default by your module command.

Example: To install the "core" set of softwares using the 1.15.2 version of Easybuild, simply use:
python install.py core 1.15.2
"""
    ) 

if len(sys.argv) >= 2 and len(sys.argv) <= 3:
    softwareSet = sys.argv[1]
    isPresent = False
    EBversion = '' if len(sys.argv) == 2 else '/' + sys.argv[2]

    stream = file('softwares.yaml', 'r')
    softList = yaml.load(stream)

    process = subprocess.Popen('/bin/bash', stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    process.stdin.write('module load EasyBuild' + EBversion + '\n')
    
    # We check that the software set exists in the YAML file.
    for k in softList.iteritems():
        if softwareSet in k:
            isPresent = True

    # If it actually exist, we install the listed software.
    if isPresent:
        for software in softList[softwareSet]:
            process.stdin.write('eb ' + software + ' -D --robot\n')
            process.stdin.write('echo $?\n')
            out = ""
            while True:
                out = process.stdout.readline()
                try:
                    i = int(out)
                except ValueError:
                    i = -1
                if i < 0:
                    sys.stdout.write(out)
                else:
                    if i == 0:
                        sys.stdout.write('Operation successful\n')
                    else:
                        sys.stdout.write('Operation failed with return code ' + out)
                        exit(out)
                    break

        sys.stdout.write("Finishing EasyBuild software installation step.\n")
    # If it doesn't, we print an error message as well as an help to use the script.
    else:
        sys.stdout.write("Error: Invalid set of software, please use either core or experimental. (Instead of " + softwareSet  + ")\n")
        helper()
        exit(20)
else:
    sys.stdout.write("Error: Invalid number of arguments.\n")
    helper()
    exit(10)
