process extractAccession {
    input:
    path json_summary
    
    output:
    path "species_accesion.txt"
    
    script:
    """
    #!/usr/bin/env python
    import json
    from pathlib import Path
    path = Path("${json_summary}")

    with open(path, 'r') as f:
        data = json.load(f)

    with open('species_accesion.txt', 'w') as f:
        f.write(data['reports'][0]['accession'])
    """
}