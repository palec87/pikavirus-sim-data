process downloadNcbiZip {
    input:
    tuple val(accession_id), val(taxon), val(coverage), val(source)
    
    output:
    path "${taxon}-${accession_id}.zip", emit: archive
    
    script:
    """
    echo "Downloading data from NCBI"
    # if else statement
    if [ "${source}" == "virus" ]; then
        datasets download virus genome accession ${accession_id} --filename ${taxon}-${accession_id}.zip
    elif [ "${source}" == "gene" ]; then
        datasets download gene accession ${accession_id} --filename ${taxon}-${accession_id}.zip
    else
        datasets download genome accession ${accession_id} --filename ${taxon}-${accession_id}.zip
    fi
    """
}