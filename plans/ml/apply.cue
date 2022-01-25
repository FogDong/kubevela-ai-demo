package ml

import (
	"encoding/json"
	
	"alpha.dagger.io/kubernetes"
)


applyResources: {
	for i, resource in resources {
		"\(i)": kubernetes.#Resources & {
			"kubeconfig": kubeconfig
			namespace: resource.metadata.namespace
			manifest: json.Marshal(resource)
		}
	}
}
