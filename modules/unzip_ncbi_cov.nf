process unzipNCBI_cov {
    publishDir "${params.outdir}", mode: 'copy'
    input:
    path archive
    tuple val(accession_id), val(taxon), val(coverage), val(source)
    // path file_name
    
    output:
    path "${archive.baseName}"

    script:
    """
    echo "Unzipping data from NCBI"
    unzip ${archive} -d "${archive.baseName}"
    """
}

    // full_path=\$(find "${archive.baseName}" -type f -name "*.fna")
    // head -n 1 \$full_path | awk -v cov=${coverage} '{\$1=substr(\$1,2); print \$1 "\\t" cov}' >> ${file_name}