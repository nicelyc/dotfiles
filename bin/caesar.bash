#!/bin/bash

# Generate SSL/TLS Certificate Signing Requests (CSR) for a set of domains
# represented as subdirectories in the current working directory.
#
# CSRs and private keys will be created in each subdirectory, with a timestamp.

O="Helix OpCo LLC"
L="San Francisco"
ST="California"

## Usage: caeser [options]
##
##     -a    Match all directories
##     -d    Match a specific directory 
##     -o    Organization (CSR)
##     -l    Locality/City (CSR)
##     -s    State (CSR)
##     -t    Match all directories ending in a specified tld (e.g. com)

help=$(grep "^## " "${BASH_SOURCE[0]}" | cut -c 4-)

# get command line args
while getopts "ac:d:hl:o:s:t:" opt; do
  case $opt in
    a) pattern="*"
       ;;
    d) pattern="$OPTARG"
       ;;
    h) echo "$help"
       exit 0;
       ;;
    l) l="${OPTARG}"
       ;;
    o) o="${OPTARG}"
       ;;
    s) st="${OPTARG}"
       ;;
    t) pattern="*.${OPTARG/./}"  # trim dot if included
       ;;
  esac
done

for d in ${pattern}; do
  if [[ -d "${d}" ]]; then
    dd=${d//./_}_`date +%Y%m%d`
    csr="${d}/${dd}.csr"
    key="${d}/${dd}.key"
    cn="${d/wildcard/*}"

    echo "# ${d}"

    # prompt to overwrite csr, if present (unless "all" option previously selected)
    if [ -f "${csr}" ] && ! [[ $csr_overwrite =~ ^([aA][lL][lL]|[aA])$ ]]; then
      printf "Certificate Signing Request exists for ${d}. Overwrite? (Y, y, N, n, A, a): " 
      read csr_overwrite
    else
      csr_new=true
    fi

    # generate new key by default
    key_switch="-newkey rsa:2048 -nodes -keyout" 

    # create or overwrite csr?
    if [ "$csr_new" = true ] || [[ $csr_overwrite =~ ^([yY][eE][sS]|[yY])$ ]] || [[ $csr_overwrite =~ ^([aA][lL][lL]|[aA])$ ]]; then

      # key present?
      if [ -f "${key}" ]; then

       # prompt to overwrite key, if present (unless "all" options previously selected)
       if ! [[ $key_overwrite =~ ^([aA][lL][lL]|[aA])$ ]]; then
         printf "Key exists for ${d}. Overwrite? (Y, n, N, n, A, a): "
         read key_overwrite
       fi

       # use existing key (if not overwrite)
       if ! ( [[ $key_overwrite =~ ^([yY][eE][sS]|[yY])$ ]] || [[ $key_overwrite =~ ^([aA][lL][lL]|[aA])$ ]] ); then
         # use existing key
         key_switch="-key"
       fi 
      fi
      
      # generate csr (and key, if applicable)
      openssl req -new -out "${csr}" ${key_switch} "${key}" -subj "/C=US/ST=${st}/L=${l}/O=${o}/CN=${cn}"
    fi
      
    echo
  fi
done
