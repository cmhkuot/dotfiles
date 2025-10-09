#!/bin/bash

# these are the defaults for the commandline-options
FILENAME=~/.ssh/id_test
KEYTYPE=ed25519
KEYSIZE=4096
PASSPHRASE=

#
# NO MORE CONFIG SETTING BELOW THIS LINE
#

function usage() {
	echo "Specify some parameters, valid ones are:"
	echo "  -f (--file)       <file>,     default: ${FILENAME}"
	echo "  -k (--keysize)    <size>,     default: ${KEYSIZE}"
	echo "  -t (--keytype)    <type>,     default: ${KEYTYPE}, typical values are 'ed25519' or 'rsa'"
	echo "  -P (--passphrase) <key-passphrase>, default: ${PASSPHRASE}"
	exit 2
}

if [[ $# < 1 ]]; then
	usage
fi

while [[ $# > 0 ]]; do
	key="$1"
	shift
	case $key in
	-f* | --file)
		FILENAME="$1"
		shift
		;;
	-k* | --keysize)
		KEYSIZE="$1"
		shift
		;;
	-t* | --keytype)
		KEYTYPE="$1"
		shift
		;;
	-P* | --passphrase)
		PASSPHRASE="$1"
		shift
		;;
	*)
		# unknown option
		usage "unknown parameter: $key, "
		;;
	esac
done

echo "Creating key ${FILENAME} using options keysize ${KEYSIZE} and keytype: ${KEYTYPE}"
echo "Press ENTER to continue or CTRL-C to abort"
read

# check that we have all necessary parts
SSH_KEYGEN=$(which ssh-keygen)
SSH=$(which ssh)
SSH_COPY_ID=$(which ssh-copy-id)

if [ -z "${SSH_KEYGEN}" ]; then
	echo Could not find the 'ssh-keygen' executable
	exit 1
fi
if [ -z "${SSH}" ]; then
	echo Could not find the 'ssh' executable
	exit 1
fi

# perform the actual work
if [ -f "${FILENAME}" ]; then
	echo Using existing key
else
	echo Creating a new key using ${SSH-KEYGEN}
	${SSH_KEYGEN} -t $KEYTYPE -b $KEYSIZE -f "${FILENAME}" -N "${PASSPHRASE}"
	RET=$?
	if [ ${RET} -ne 0 ]; then
		echo ssh-keygen failed: ${RET}
		exit 1
	fi
fi

if [ ! -f "${FILENAME}.pub" ]; then
	echo Did not find the expected public key at ${FILENAME}.pub
	exit 1
fi

# echo "Host *\n AddKeysToAgent yes\n UseKeychain yes\n IdentityFile ~/.ssh/id_ed25519" | tee ~/.ssh/config
