package ml

// This will register the new capability and expose it to users
parameters: serveModel: monitoring: {
	groups: [...#monitorGroup]
}

#monitorGroup: {
	name: string
	rules: [...#monitorRule]
}

#monitorRule: {
	alert: string
	expr: string
	for: string
	annotations: [string]: string
}