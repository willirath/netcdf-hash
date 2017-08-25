#!/bin/bash

# set up tmp dir
tmp_dir=/tmp/nchash_demo_ncks_`date -Ins`
mkdir -p ${tmp_dir}
cd ${tmp_dir}

# get example data and convert to 4 different representations (classic, full
# netCDF4, 64-bit-offset, netCDF4-classic).  Use deflation level 1 with
# shuffling for the netCDF4* files.
example_file_url="https://www.unidata.ucar.edu/software/netcdf/examples/smith_sandwell_topo_v8_2.nc"
example_file=`basename ${example_file_url}`
curl ${example_file_url} -o ${example_file}
for kind in 4 7; do
    nccopy -s -d 1 -${kind} ${example_file} ${example_file}.${kind}
done
for kind in 3 6; do
    nccopy -${kind} ${example_file} ${example_file}.${kind}
done

# for each of the four and for the original file, create a copy containing the
# nco md5-hash attributes
for kind in "" ".3" ".4" ".6" ".7"; do
    file_name=${example_file}${kind}
    time ncks -a -C --md5_write_attribute -O ${file_name} md5_${file_name}
done

# Show what ncks did to the original file
diff <(ncdump -h ${example_file}) <(ncdump -h md5_${example_file})

# For each of the .3 to .7 files, diff the header against the md5-digested
# original file
for kind in ".3" ".4" ".6" ".7"; do
    diff <(ncdump -h md5_${example_file}${kind}) \
        <(ncdump -h md5_${example_file})
done

# report versions
echo "nccopy version: " \
    "`nccopy --version 2> /dev/null || nccopy 2>&1 | grep version`"
echo "ncdump version: `ncdump 2>&1 | grep version`"
echo "ncks version: `ncks --version 2>&1`"

# go back and clean up
cd - &>/dev/null
rm -rf ${tmp_dir}
