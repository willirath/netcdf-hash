#!/bin/bash

urls=("https://www.unidata.ucar.edu/software/netcdf/examples/madis-sao.nc")

for url in ${urls[*]}; do
    curl ${url} -o example_data/"`basename ${url}`"
done
