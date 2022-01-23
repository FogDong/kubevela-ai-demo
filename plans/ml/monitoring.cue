package ml

// This will register the new capability and expose it to users
parameters: serveModel: monitoring: groups: [...#monitorGroup]

#monitorGroup: {
	name: string
	rules: [...#monitorRule]
}

#monitorRule: {
	alert: string
	expr:  string
	for:   string
	annotations: [string]: string
}

outputs: "monitoring.coreos.com/v1": ServiceMonitor: "\(parameters.metadata.namespace)": "\(parameters.metadata.name)": {
	metadata: labels: env: parameters.serveModel.env
	spec: {
		selector: matchLabels: app: parameters.metadata.name
		endpoints: [{
			port: parameters.serveModel.container.port
		}]
	}
}
