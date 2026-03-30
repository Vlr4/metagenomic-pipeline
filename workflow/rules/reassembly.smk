rule reassembly:
    input:
        r1 = BASE / config["output"]["qc"]["read_qc"] / "{sample}" / "final_pure_reads_1.fastq",
        r2 = BASE / config["output"]["qc"]["read_qc"] / "{sample}" / "final_pure_reads_2.fastq",
        refined = SYMLINK / "{sample}_binning" / "bin_refinement" / "metawrap_70_10_bins"   
    output:
        stats = SYMLINK / "{sample}_binning" / "bin_reassembly" / "reassembled_bins.stats",
        plot = SYMLINK / "{sample}_binning" / "bin_reassembly" / "reassembly_results.png"
    params:
        out_dir = subpath(output.stats, parent=True),
        mem_gb = config["mem"]["reassembly"]
    
#    conda: "../envs/metawrap.yaml"
    threads: 
        config["threads"]["reassembly"]
    resources:
        mem_mb = math.ceil(config["mem"]["reassembly"] * 1.2 * 1024)
    shell:
        """
        source activate metawrap-env
        export PATH=/mnt/apps/users/vtelizhe/conda/envs/metawrap-env/bin:$PATH
        metawrap reassemble_bins \
          -o {params.out_dir} \
          -1 {input.r1} \
          -2 {input.r2} \
          -b {input.refined} \
          -t {threads} -m {params.mem_gb} -c 70 -x 10 \
          
        """
