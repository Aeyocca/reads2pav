#!/usr/bin/env bash

set -u


# Get the expected NCBI settings path and define the environment variable
# `NCBI_SETTINGS`.
eval "$(vdb-config -o n NCBI_SETTINGS | sed 's/[" ]//g')"

# If the user settings do not exist yet, create a file suitable for `prefetch`
# and `fasterq-dump`. If an existing settings file does not contain the required
# values, error out with a helpful message.
if [[ ! -f "${NCBI_SETTINGS}" ]]; then
    printf '/LIBS/GUID = "7bbbb590-530d-44b3-800c-4f0e3fbf29e0"\n/libs/cloud/report_instance_identity = "true"\n' > 'user-settings.mkfg'
else
    prefetch --help &> /dev/null
    if [[ $? = 78 ]]; then
        echo "You have an existing vdb-config at '${NCBI_SETTINGS}' but it is"\
        "missing the required entries for /LIBS/GUID and"\
        "/libs/cloud/report_instance_identity."\
        "Feel free to add the following to your settings file:" >&2
        echo "$(printf '/LIBS/GUID = "7bbbb590-530d-44b3-800c-4f0e3fbf29e0"\n/libs/cloud/report_instance_identity = "true"\n')" >&2
        exit 1
    fi
    fasterq-dump --help &> /dev/null
    if [[ $? = 78 ]]; then
        echo "You have an existing vdb-config at '${NCBI_SETTINGS}' but it is"\
        "missing the required entries for /LIBS/GUID and"\
        "/libs/cloud/report_instance_identity."\
        "Feel free to add the following to your settings file:" >&2
        echo "$(printf '/LIBS/GUID = "7bbbb590-530d-44b3-800c-4f0e3fbf29e0"\n/libs/cloud/report_instance_identity = "true"\n')" >&2
        exit 1
    fi
    if [[ "${NCBI_SETTINGS}" != *.mkfg ]]; then
        echo "The detected settings '${NCBI_SETTINGS}' do not have the required"\
        "file extension '.mkfg'." >&2
        exit 1
    fi
    cp "${NCBI_SETTINGS}" ./
fi

cat <<-END_VERSIONS > versions.yml
"FETCHNGS:NFCORE_FETCHNGS:SRA:FASTQ_DOWNLOAD_PREFETCH_FASTERQDUMP_SRATOOLS:CUSTOM_SRATOOLSNCBISETTINGS":
    sratools: $(vdb-config --version 2>&1 | grep -Eo '[0-9.]+')
END_VERSIONS
