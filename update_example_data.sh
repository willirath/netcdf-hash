#!/bin/bash

urls=("https://www.unidata.ucar.edu/software/netcdf/examples/madis-sao.nc")

for url in ${urls[*]}; do
    output_file=example_data/"`basename ${url}`"

    curl ${url} -o ${output_file}

    for kind in 3 4 6 7; do
        nccopy -${kind} ${output_file} ${output_file}.${kind}
    done
done
