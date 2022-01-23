package ml

import (
	"alpha.dagger.io/dagger"
)

parameters: {
	metadata: {
		name:      string & dagger.#Input
		namespace: string | *"default"
	}

	// build: {
	//  source: dagger.#Artifact & dagger.#Input
	//  setup: string
	//  env: [string]: string
	//  command: string

	//  ctr: os.#Container & {
	//   image: build.source
	//   setup: build.setup
	//   env: build.env
	//   command: build.command
	//  }
	// }

	trainModel: {
		container:    #container
		backoffLimit: int | *1
	}

	serveModel: container: #container

	serveModel: autoscaling: #autoscaling
}

#container: {
	image: string
	cmd: [...string]
}

#autoscaling: {
	min: int | *0
	max: int | *0
}

outputs: {
	name: parameters.metadata.name
} @dagger(output)
