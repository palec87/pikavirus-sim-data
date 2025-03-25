process combineFastas {
    errorStrategy 'retry'
    publishDir "${params.outdir}", mode: 'copy'

    input:
    path fasta_folder
    val trigger

    output:
    path "combined-mulitfasta.fasta", emit: multifasta
    // path "header.txt"

    script:
    """
    touch combined-mulitfasta.fasta
    for folder in "${fasta_folder}"/*/; do
        # Construct the full path by appending the additional path
        full_path=\$(find "\$folder" -type f -name "*.fna")
        
        # Print or process the full path
        echo \$full_path

        # write fasta to combined file
        cat \$full_path >> combined-mulitfasta.fasta

    done
    """
}