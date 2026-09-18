#!/bin/bash

# SSH key generator
#
# Usage:
#   ./bin/ssh.sh [options]
#
# The script creates an SSH key pair when the requested private key does not
# already exist. It pauses for confirmation before creating the key and checks
# that ssh-keygen, ssh, and the generated public key are available.
#
# Options:
#   -f, --file <file>         Output private key path (default: ~/.ssh/id_test)
#   -k, --keysize <size>      Key size in bits (default: 4096)
#   -t, --keytype <type>      Key type, usually ed25519 or rsa
#                             (default: ed25519)
#   -P, --passphrase <value>  Passphrase for the private key (default: empty)
#
# Examples:
#   ./bin/ssh.sh
#   ./bin/ssh.sh --file ~/.ssh/id_work --keytype ed25519
#   ./bin/ssh.sh -f ~/.ssh/id_rsa -t rsa -k 4096 -P 'change-me'
#
# When the private key already exists, it is reused and no new key is created.

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
