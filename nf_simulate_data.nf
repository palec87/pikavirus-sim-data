params.outdir = "ncbi_data"

include { downloadNcbiZip } from './modules/download_ncbi_zip.nf'
include { unzipNCBI_cov } from './modules/unzip_ncbi_cov.nf'
include { combineFastas } from './modules/combine_fastas.nf'


process generate_data {
    publishDir "${params.outdir}", mode: 'copy'

    input:
    path combined_fasta
    path coverage_file
    // path config_accessions

    output:
    path "sim_data*"

    script:
    """
    iss generate \\
        --genomes ${combined_fasta} \\
        --n_reads 10K \\
        --model miseq \\
        --coverage_file ${coverage_file} \\
        --output sim_data \\
    """
}

workflow {
    def species_input = "species_input.csv"
    myFile = file("coverage.txt")
    ch_input = Channel.fromPath(species_input)
                            .splitCsv( header: true )
                            .map { row -> [row.accession, row.taxon, row.coverage] }

    // download ncbi archives
    downloadNcbiZip(ch_input)

    // unzip ncbi archives
    trigger = unzipNCBI_cov(downloadNcbiZip.out.archive, ch_input, myFile)
        .collect(flat: false)
        .flatMap()
    
    // from unzipped data to combined fasta
    combineFastas("${projectDir}/${params.outdir}", trigger)

    // from cobined fasta and coverage file to simulated data
    generate_data(combineFastas.out.multifasta, myFile)

}
