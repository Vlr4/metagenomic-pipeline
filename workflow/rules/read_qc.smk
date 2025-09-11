rule read_qc:
    input:
        r1 = lambda wildcards: f"{config["input"]["short_reads"]}/{wildcards.sample}_1.fastq",
        r2 = lambda wildcards: f"{config["input"]["short_reads"]}/{wildcards.sample}_2.fastq"
    output:
        pure_r1 = str(base / f"{config["output"]["qc"]["read_qc"]}/{{sample}}/final_pure_reads_1.fastq.gz"),
        pure_r2 = str(base / f"{config["output"]["qc"]["read_qc"]}/{{sample}}/final_pure_reads_2.fastq.gz"),
        host_r1 = str(base / f"{config["output"]["qc"]["read_qc"]}/{{sample}}/host_reads_1.fastq.gz"),
        host_r2 = str(base / f"{config["output"]["qc"]["read_qc"]}/{{sample}}/host_reads_2.fastq.gz"),
    params:
        qc_dir = str(base / f"{config["output"]["qc"]["read_qc"]}/{{sample}}")
    threads: config["threads"]["qc"]
#    conda: "../envs/metawrap.yaml"
    shell:
        """
        source activate metawrap-env
        mkdir -p {config[output][qc][read_qc]}
        metawrap read_qc -t {threads} {config[metawrap][read_qc_options]} \
            -1 {input.r1} -2 {input.r2} -o {params.qc_dir}
        """