# pikavirus-sim-data
Generate simulated data for pikavirus banchmarks

Input is a csv file `species_input.csv` as below with ncbi accession ids and relative abundance (has to sum to 1) of the desired simulated dataset.

| accession | taxon | abundance |
| --------- | ----- | ------- |
| GCF_015277775.1 | acidobacteriota | 0.4 |
| GCA_023169805.1 | abditibacteriota | 0.6 |

The data will be downloaded from ncbi, unzipped, combined for adequate input for the InSilicoSeq. See [Parametrize](#parametrize) section for more.

## Run
Once you have the dependencies listed in the [Dependencies](#dependencies) section, you can run the workflow as:
```
nextflow run nf_simulate_data.nf
```

## Parametrize
parameter are
* --outdir (default `ncbi_data_example`)
* --nReads (default `1M`)
* --model (default `miseq`, see InSilicoSeq for more options)
* --input (default `species_input_example.csv`)

You can change these defaults at the top of the `nf_simulate_data.nf` workflow file. 

## Example output
folder `ncbi_data` contains both the downladed data and also the simulated `.fastq` files.

There is also a log file which is located in `outdir/logs.txt` and records all the inputs to the workflow.

## Dependencies
```
# ncbi CLI tool, https://www.ncbi.nlm.nih.gov/datasets/docs/v2/command-line-tools/download-and-install/
conda install -c conda-forge ncbi-datasets-cli

# used to actually simulate the data https://github.com/HadrienG/InSilicoSeq
conda install -c bioconda insilicoseq
```