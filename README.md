# netcdf-hash

This aims at becoming a proof of concept for hashing netCDF data sets based on
their contents rather than on their binary representation on disk.


## Problem

For a data set (being defined by variables, dimensions, attributes, their
order, etc.), there is an almost infinite number of ways to be represented as a
netCDF file:  With different levels of deflation, different chunking,
shuffling, etc., the exact same data can have many representations which on a
higher level (think of a full `ncdump` dump) are completely equivalent.

There are tools that *compare* the contents of two netCDF files: [cdo's
diff](https://code.zmaw.de/projects/cdo/embedded/index.html#x1-470002.1.3) or
[nccmp](http://nccmp.sourceforge.net/).  These tools do, however, rely on both
files being present on the same file system and at the same time and hence
remote comparison of two or more netCDF files or verification of the integrity
of the contents of a data set is not possible.


## Existing discussion and partial solutions

- <https://www.esrl.noaa.gov/psd/people/dave.allured/data/netcdf/scripts/nc-add-checksum>
  adds an MD5 checksum of a netCDF file to the global attributes of the same
  netCDF file and
  <https://www.esrl.noaa.gov/psd/people/dave.allured/data/netcdf/scripts/nc-verify-checksum>
  verifies the checksum against a version of the file with the attribute set to
  an emtpy string.

- <http://www.unidata.ucar.edu/mailing_lists/archives/netcdfgroup/2005/thread.html#00016>
  looks like the mailing list thread leading to the tools above.  But there's
  also some discussion about incorporating the functionality directly into
  `ncks`.

- <https://gehrcke.de/2013/07/bitwise-identity-of-netcdf-data-hashing-numpy-arrays/>
  outlines a Python-based approach to hashing netCDF variables.

- <https://github.com/aidanheerdegen/nchash> aims at hashing the cheaper parts
  (CDL header, time stamps, file sizes) as a quick plausibility check for very
  large files.

- <https://github.com/Unidata/netcdf4-python/issues/646> was a first attempt to
  (re)-start the discussion.


## Example data

Example data sets have been copied from
<https://www.unidata.ucar.edu/software/netcdf/examples/files.html>.

There are example data sets in [example_data/](example_data/).  Update them by
running
```bash
./update_example_data.sh
```
from within the root of this repository.


## First Demo

[demo_001.ipynb](demo_001.ipynb) contains a short demonstration calculating a
global content-based hash from four different representations of an example
data set, storing it in an global attribute of the files, and re-calculates and
verifies the hashes against the global attribute.


## Solution?

On the netcdfgroup mailing list, Charlie Zender pointed out that NCO
essentially does what I wanted:  <http://nco.sf.net/nco.html#md5>

[ncks_digest_demo.sh](ncks_digest_demo.sh) puts this into a demo file.
