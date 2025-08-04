rule read_qc:
    input:
        r1=lambda wildcards: f"{config['input']['short_reads']}/{wildcards.sample}_1.fastq",
        r2=lambda wildcards: f"{config['input']['short_reads']}/{wildcards.sample}_2.fastq"
    output:
        dir=lambda wildcards: f"{config['output']['qc']['read_qc']}/{wildcards.sample}"
    threads: config["threads"]["qc"]
    conda: "../envs/metawrap.yaml"
    shell:
        """
        mkdir -p {config[output][qc][read_qc]}
        metawrap read_qc -t {threads} {config[metawrap][read_qc_options]} \
            -1 {input.r1} -2 {input.r2} -o {output.dir}
        """