rule Remove500:
    input:
        fasta="{sample}/Assembly/{sample}.contigs.fasta"
    output:
        "{sample}/Assembly/{sample}.fasta"
    conda:
        "environment.yaml"
    resources:  mem_mb = config["statRam"], disk_mb = config["statDisk"]
    threads: config.get("statThreads")
    shell:
        "reformat.sh in={input.fasta} out={output} minlength=500"
rule bwa_mem:
    input:
        reads=lambda wildcards: config["samples"][wildcards.sample],
        fasta="{sample}/Assembly/{sample}.fasta"
    output:
        "{sample}/Polished1/{sample}.sorted.sam"
    resources:
        mem_mb=config["bwaRam"],
        disk_mb=config["bwaDisk"]
    threads: config.get("bwathreads")
    conda:
        "environment.yaml"
    log:
        "logs/bwa/{sample}.log"
    benchmark:
        "benchmark/bwa/{sample}.tsv"
    shell:
        "bwa index {input.fasta} && bwa mem -xont2d -t {threads} {input.fasta} {input.reads} | samtools sort -o {output}"

rule polish:
    input:
        assembly="assembly/{sample}/assembly.tar.gz",
        reads=lambda wc: f"rawData/{wc.sample}_1.fastq.gz"
    output:
        polished="assembly/{sample}/polished/{sample}.polished1.fasta"
    resources:
        threads=config["resources"]["polish"]["Threads"],
        mem_gb=config["resources"]["polish"]["Ram"]
    conda: "../envs/polishing.yaml"
    shell:
        """
        tar -xzf {input.assembly}
        bwa index assembly/{wildcards.sample}/assembly/{wildcards.sample}.contigs.fasta
        bwa mem -t {resources.threads} \
        assembly/{wildcards.sample}/assembly/{wildcards.sample}.contigs.fasta \
        {input.reads} | \
        samtools sort -o assembly/{wildcards.sample}/polished/{wildcards.sample}.sorted.bam
        racon -t {resources.threads} \
        {input.reads} \
        assembly/{wildcards.sample}/polished/{wildcards.sample}.sorted.bam \
        assembly/{wildcards.sample}/assembly/{wildcards.sample}.contigs.fasta > {output.polished}
        """

rule mapping:
    input:
        reads=lambda wildcards: expand(f"{config['samples'][wildcards.sample]}"),
        polished1="assembly/{sample}/polished/{sample}.polished1.fasta"
    output:
        "{sample}/Polished2/{sample}.sorted.sam"
    resources:  mem_mb = config["bwaRam"], disk_mb = config["bwaDisk"]
    threads: config.get("bwathreads")
    benchmark:
        "benchmark/bwa2/{sample}.tsv"
    conda:
        "environment.yaml"
    shell:
        "bwa index {input.polished1} && bwa mem -x ont2d -t {threads} {input.polished1} {input.reads} | samtools sort -o {output}"
        
rule Polish2:
    input:
        polished1="assembly/{sample}/polished/{sample}.polished1.fasta",
        bam="{sample}/Polished2/{sample}.sorted.sam",
        reads=lambda wildcards: expand(f"{config['samples'][wildcards.sample]}")
    output:
        polished2="assembly/{sample}/Polished2/{sample}_polished2.fasta"
    resources:
        threads=config["resources"]["polish"]["Threads"],
        mem_gb=config["resources"]["polish"]["Ram"]
    benchmark:
        "benchmark/Polish2/{sample}.tsv"
    conda:
        "environment.yaml"
    params:
        direc="{sample}/Polished2"
    log:
        "logs/Pilon2/{sample}.log"
    shell:
        "racon --t {threads} {input.reads} {input.bam} {input.polished1} > {output.polished2}"
