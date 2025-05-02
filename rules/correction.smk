rule canu_correction:
    input:
        reads=lambda wc: f"rawData/{wc.sample}_1.fastq.gz"
    output:
        corrected=directory("assembly/{sample}/correction"),
        tarball="assembly/{sample}/correction.tar.gz"
    params:
        genome=config["assembly"]["genome_size"],
        error=config["assembly"]["correction"]["error_rate"],
        min_len=config["assembly"]["correction"]["min_read_length"],
        min_ovl=config["assembly"]["correction"]["min_overlap"]
    resources:
        threads=config["resources"]["correction"]["threads"],
        mem_gb=config["resources"]["correction"]["mem_gb"]
    conda: "../envs/assembly.yaml"
    shell:
        """
        canu -correct \
        -p {wildcards.sample} \
        -d {output.corrected} \
        genomeSize={params.genome} \
        correctedErrorRate={params.error} \
        minReadLength={params.min_len} \
        minOverlapLength={params.min_ovl} \
        -nanopore-raw {input.reads}
        tar -czf {output.tarball} {output.corrected}
        """
