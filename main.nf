#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { nevermore_main } from "./nevermore/workflows/nevermore"
include { gffquant_flow } from "./nevermore/workflows/gffquant"
include { fastq_input } from "./nevermore/workflows/input"

// if (params.input_dir && params.remote_input_dir) {
// 	log.info """
// 		Cannot process both --input_dir and --remote_input_dir. Please check input parameters.
// 	""".stripIndent()
// 	exit 1
// } else if (!params.input_dir && !params.remote_input_dir) {
// 	log.info """
// 		Neither --input_dir nor --remote_input_dir set.
// 	""".stripIndent()
// 	exit 1
// }

def input_dir = (params.input_dir) ? params.input_dir : params.remote_input_dir

// params.ignore_dirs = ""
params.remote_input_dir = false

workflow metaT_input {
	take:
		fastq_ch
	main:
		fastq_input(fastq_ch, params.remote_input)
	emit:
		reads = fastq_input.out.fastqs
}

workflow metaG_input {
	take:
		fastq_ch
	main:
		fastq_input(fastq_ch, params.remote_input)
	emit:
		reads = fastq_input.out.fastqs
}



workflow {

	metaT_input(
		Channel.fromPath(params.metaT_input_dir + "/*", type: "dir")
	)
	metaG_input(
		Channel.fromPath(params.metaG_input_dir + "/*", type: "dir")
	)


	metaT_input.out.reads.view()

	metaG_input.out.reads.view()
	


}
