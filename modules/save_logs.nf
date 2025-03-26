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
    echo "Trigger: ${params.abundance_file}" >> logs.txt
    cat ${params.abundance_file} >> logs.txt
    """
}