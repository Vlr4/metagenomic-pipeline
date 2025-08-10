rule preassembly:
    input:
        r1=lambda wc: f"{config['output']['qc']['read_qc']}/{wc.sample}/final_pure_reads_1.fastq",
        r2=lambda wc: f"{config['output']['qc']['read_qc']}/{wc.sample}/final_pure_reads_2.fastq",
        nano=lambda wc: f"{config['output']['dehost']['sam']}/nano.{wc.sample}.dehost.fq.gz",
    output:
        dir=lambda wc: f"{config['output']['assembly']['spades']}/{wc.sample}_assembly",
    threads: config["spades"]["threads"]
    conda: "../envs/spades.yaml"
    shell:
        r"""
        mkdir -p {config[output][assembly][rawdata]} \
                 {config[output][assembly][hybrid_temp]} \
                 {config[output][assembly][spades]}
        spades.py {config[spades][options]} \
          -1 {input.r1} -2 {input.r2} \
          --nanopore {input.nano} \
          --threads {threads} --memory {config[spades][memory]} \
          -o {output.dir}
        """
