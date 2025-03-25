# pikavirus-sim-data
Generate simulated data for pikavirus banchmarks

Input is a csv file `species_input.csv` as below with ncbi accession ids and coverages of the desired simulated dataset.



| accession | taxon | coverage |
| --------- | ----- | ------- |
| GCF_015277775.1 | acidobacteriota | 20 |
| GCA_023169805.1 | abditibacteriota | 30 |

The data will be downloaded from ncbi, unzipped, combined for adequate input for the InSilicoSeq.

## Example output
folder `ncbi_data` contains both the downladed data and also the simulated `.fastq` files.

## Dependencies
```
# ncbi CLI tool, https://www.ncbi.nlm.nih.gov/datasets/docs/v2/command-line-tools/download-and-install/
conda install -c conda-forge ncbi-datasets-cli

# used to actually simulate the data https://github.com/HadrienG/InSilicoSeq
conda install -c bioconda insilicoseq
```