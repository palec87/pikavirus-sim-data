params.outdir = 'sample3_miseq'
params.nReads = '10K'
params.model = 'miseq'
params.input = 'species_pikavirus_sample3.csv'
params.abundance_file = "${projectDir}/abundance_pikavirus_sample3.txt"
params.skip_download = false


// this is to run the example
// params.outdir = 'ncbi_data_example'
// params.nReads = '10K'
// params.model = 'miseq'
// params.input = 'species_example.csv'

include { downloadNcbiZip } from './modules/download_ncbi_zip.nf'
include { unzipNCBI_cov } from './modules/unzip_ncbi_cov.nf'
include { combineFastas } from './modules/combine_fastas.nf'
include { saveLogs } from './modules/save_logs.nf'


process generate_data {
    publishDir "${params.outdir}", mode: 'copy'

    input:
    path combined_fasta
    path combined_human_fasta

    output:
    path "sim_data*"

    script:
    """
    iss generate \\
        --genomes ${combined_fasta} ${combined_human_fasta}\\
        --n_reads ${params.nReads} \\
        --model ${params.model} \\
        --abundance_file ${params.abundance_file} \\
        --output sim_data \\
    """
}

workflow get_data {
    main:
    if (params.skip_download) {

        trigger = true

    }
    else {

        // myFile = file("coverage.txt")
        ch_input = Channel.fromPath(params.input)
                            .splitCsv( header: true )
                            .map { row -> [row.accession, row.taxon, row.abundance, row.source] }

        // download ncbi archives
        downloadNcbiZip(ch_input)

        // unzip ncbi archives
        trigger = unzipNCBI_cov(downloadNcbiZip.out.archive, ch_input)
    }
    

    emit:
    trigger
}

workflow {
    get_data()
    input = Channel.fromPath(params.input)
                            .splitCsv( header: true )
                            .map { row -> [row.accession, row.taxon, row.abundance, row.source] }
                            .collect(flat: false)

    // from unzipped data to combined fasta
    combineFastas("${projectDir}/${params.outdir}", get_data.out.trigger.collect())

    // from cobined fasta and coverage file to simulated data
    generate_data(combineFastas.out.multifasta, "${projectDir}/combined-human.fna")

    // save metadata
    saveLogs(get_data.out.trigger.collect(), input)
}
