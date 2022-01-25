package ml

import (
	"alpha.dagger.io/dagger"
)

// set with `dagger input text kubeconfig -f "$HOME"/.kube/config -e kube`
kubeconfig: {string} @dagger(input)

parameters: {
	metadata: {
		name:      string & dagger.#Input
		namespace: string | *"default"
	}

	// build: {
	//  source: dagger.#Artifact & dagger.#Input
	//  push:   {
	//   target: string
	//   auth: {
	//    username: string
	//    secret:   string
	//   } | *null
	//  }
	//  image:    docker.#Build & {
	//   source: build.source
	//  }
	//  _push: docker.#Push & {
	//   source: image
	//   target: push.target
	//   if build.push.auth != null {
	//    auth: {
	//     username: build.push.auth.username
	//     secret:   build.push.auth.secret
	//    }
	//   }
	//  }
	// }

	trainModel: {
		container:    #container
		backoffLimit: int | *1
	}

	serveModel: {
		env:       string
		container: #container
	}

	serveModel: autoscaling: #autoscaling
}

#container: {
	image: string
	cmd: [...string]
	port: int | *80
}

#autoscaling: {
	min: int | *0
	max: int | *0
}

generateResource: [ApiVersion=_]: [Kind=_]: [Namespace=_]: [Name=_]: {
	apiVersion: ApiVersion
	kind:       Kind
	metadata: {
		name:      Name
		namespace: Namespace
		labels: {
			app: Name
			...
		}
		...
	}
	...
}

generateResource: "apps/v1": Deployment: "\(parameters.metadata.namespace)": "\(parameters.metadata.name)": {
	metadata: {
		labels: env:                  parameters.serveModel.env
		annotations: "dev.nocalhost": """
				name: nocalhost-api
				serviceType: deployment
				containers:
					- name: nocalhost-api
						dev:
							image: \(parameters.serveModel.container.image)
				"""
	}
	spec: {
		replicas: 1
		selector: matchLabels: app: parameters.metadata.name
		template: {
			metadata: labels: {
				app: parameters.metadata.name
				env: parameters.serveModel.env
			}
			spec: containers: [{
				image:   parameters.serveModel.container.image
				name:    parameters.metadata.name
				command: parameters.serveModel.container.cmd
				ports: [{
					containerPort: parameters.serveModel.container.port
					protocol:      "TCP"
				}]
				resources: {
					requests: {
						memory: "64Mi"
						cpu:    "250m"
					}
					limits: {
						memory: "128Mi"
						cpu:    "500m"
					}
				}
			}]
		}
	}
}

generateResource: v1: Service: "\(parameters.metadata.namespace)": "\(parameters.metadata.name)": {
	metadata: labels: env: parameters.serveModel.env
	spec: {
		type: "ClusterIP"
		ports: [{
			port:       parameters.serveModel.container.port
			targetPort: parameters.serveModel.container.port
		}]
		selector: app: parameters.metadata.name
	}
}

generateResource: "networking.k8s.io/v1": Ingress: "\(parameters.metadata.namespace)": "\(parameters.metadata.name)": {
	metadata: {
		labels: env: parameters.serveModel.env

		annotations: "nginx.ingress.kubernetes.io/rewrite-target": "/"
	}
	spec: rules: [{
		http: paths: [{
			path:     "/\(parameters.metadata.name)"
			pathType: "Prefix"
			backend: service: {
				name: parameters.metadata.name
				port: number: parameters.serveModel.container.port
			}
		}]
	}]
}

resources: [
	for _, v1 in generateResource {
		for _, v2 in v1 {
			for _, v3 in v2 {
				for _, v4 in v3 {
					v4
				}
			}
		}
	},
]
