rule canu_trim:
    input:
        corrected="assembly/{sample}/correction.tar.gz"
    output:
        trimmed=directory("assembly/{sample}/trimming"),
        tarball="assembly/{sample}/trimming.tar.gz"
    params:
        genome=config["assembly"]["genome_size"],
        error=config["assembly"]["trimming"]["error_rate"],
        min_len=config["assembly"]["trimming"]["min_read_length"],
        min_ovl=config["assembly"]["trimming"]["min_overlap"],
        mer=config["assembly"]["trimming"]["mer_distinct"]
    resources:
        threads=config["resources"]["trimming"]["threads"],
        mem_gb=config["resources"]["trimming"]["mem_gb"]
    conda: "../envs/assembly.yaml"
    shell:
        """
        tar -xzf {input.corrected}
        canu -trim \
        -p {wildcards.sample} \
        -d {output.trimmed} \
        genomeSize={params.genome} \
        correctedErrorRate={params.error} \
        minReadLength={params.min_len} \
        minOverlapLength={params.min_ovl} \
        obtOvlMerDistinct={params.mer} \
        -nanopore-corrected assembly/{wildcards.sample}/correction/{wildcards.sample}.correctedReads.fasta.gz
        tar -czf {output.tarball} {output.trimmed}
        """
