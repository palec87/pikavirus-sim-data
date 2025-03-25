params.outdir = 'ncbi_data_example'
params.nReads = '1M'
params.model = 'miseq'
params.input = 'species_input_example.csv'

include { downloadNcbiZip } from './modules/download_ncbi_zip.nf'
include { unzipNCBI_cov } from './modules/unzip_ncbi_cov.nf'
include { combineFastas } from './modules/combine_fastas.nf'


process generate_data {
    publishDir "${params.outdir}", mode: 'copy'

    input:
    path combined_fasta
    path coverage_file

    output:
    path "sim_data*"

    script:
    """
    iss generate \\
        --genomes ${combined_fasta} \\
        --n_reads ${params.nReads} \\
        --model ${params.model} \\
        --coverage_file ${coverage_file} \\
        --output sim_data \\
    """
}

process saveLogs {
    publishDir "${params.outdir}", mode: 'copy'

    input:
    val trigger
    val ch_input

    output:
    path "logs.txt"

    script:
    """
    touch logs.txt
    echo "Output directory: ${params.outdir}" >> logs.txt
    echo "Number of reads: ${params.nReads}" >> logs.txt
    echo "Model: ${params.model}" >> logs.txt
    echo "Input csv: ${ch_input}" >> logs.txt
    """
}

workflow {
    // def species_input = "species_input.csv"
    myFile = file("coverage.txt")
    ch_input = Channel.fromPath(params.input)
                            .splitCsv( header: true )
                            .map { row -> [row.accession, row.taxon, row.abundance] }

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
    input = Channel.fromPath(params.input)
                            .splitCsv( header: true )
                            .map { row -> [row.accession, row.taxon, row.abundance] }
                            .collect(flat: false)
    // save metadata
    saveLogs(trigger, input)

}
