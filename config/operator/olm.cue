// Copyright 2017-2021 Authors of Cilium
// SPDX-License-Identifier: Apache-2.0

package operator

import (
	"encoding/base64"
	"encoding/json"
	"strings"
)

_olm_items: [
	{
		apiVersion: "operators.coreos.com/v1alpha2"
		kind:       "OperatorGroup"
		metadata: {
			name:      "cilium"
			namespace: parameters.namespace
		}
		spec: targetNamespaces: [parameters.namespace]
	},
	{
		apiVersion: "operators.coreos.com/v1alpha1"
		kind:       "Subscription"
		metadata: {
			name:      "cilium"
			namespace: parameters.namespace
		}
		spec: {
			channel:             parameters.ciliumMajorMinor
			name:                "cilium"
			startingCSV:         "cilium.v\(parameters.ciliumVersion)-x\(parameters.configVersionSuffix)"
			installPlanApproval: "Manual"
			source:              "certified-operators"
			sourceNamespace:     "openshift-marketplace"
		}
	},
	#CSVWorkloadTemplate,
]

_alm_examples_metadata: {
	"cilium-openshift-default": description: "Default CiliumConfig CR for OpenShift"
}

_example_config_opts_common: {
	nativeRoutingCIDR: "10.128.0.0/14"
	endpointRoutes: enabled: true
	kubeProxyReplacement: "probe"
	cni: {
		binPath:  "/var/lib/cni/bin"
		confPath: "/var/run/multus/cni/net.d"
	}
	ipam: operator: {
		clusterPoolIPv4PodCIDR:  "10.128.0.0/14"
		clusterPoolIPv4MaskSize: "23"
	}
	prometheus: serviceMonitor: enabled: false
}

_example_config_opts_ipam_mode: ipam: mode: "cluster-pool"

_alm_examples: [
	{
		apiVersion: "cilium.io/v1alpha1"
		kind:       "CiliumConfig"
		metadata: {
			name:      "cilium-openshift-default"
			namespace: parameters.namespace
		}
		spec: {
			if strings.HasPrefix(parameters.ciliumVersion, "1.8") {
				config: _example_config_opts_ipam_mode
				global: _example_config_opts_common
			}
			if strings.HasPrefix(parameters.ciliumVersion, "1.9") || strings.HasPrefix(parameters.ciliumVersion, "1.10") ||
				strings.HasPrefix(parameters.ciliumVersion, "1.11") {
				_example_config_opts_common & _example_config_opts_ipam_mode & {
					hubble: tls: enabled: false
				}
			}
		}
	},
]

_csv_annotations: {
	categories:                                       "Networking,Security"
	support:                                          "support@isovalent.com"
	#certified:                                       "true"
	capabilities:                                     "Seamless Upgrades"
	repository:                                       "http://github.com/cilium/cilium"
	"alm-examples-metadata":                          json.Marshal(_alm_examples_metadata)
	"alm-examples":                                   json.Marshal(_alm_examples)
	"operators.openshift.io/infrastructure-features": "[\"disconnected\"]"
	"olm.skipRange":                                  ">=\(parameters.ciliumMajorMinor).0 <\(parameters.ciliumVersion)+x\(parameters.configVersionSuffix)"
	"features.operators.openshift.io/disconnected":     "true"
        "features.operators.openshift.io/fips-compliant":   "false"
        "features.operators.openshift.io/proxy-aware":      "true"
        "features.operators.openshift.io/tls-profiles":     "false"
        "features.operators.openshift.io/token-auth-aws":   "false"
        "features.operators.openshift.io/token-auth-azure": "false"
        "features.operators.openshift.io/token-auth-gcp":   "false"
        "features.operators.openshift.io/cni":              "true"
}

_logoString: """
	<svg width="119" height="35" viewBox="0 0 119 35" fill="none" xmlns="http://www.w3.org/2000/svg">
	<path fill-rule="evenodd" clip-rule="evenodd" d="M29.3361 18.8075H24.2368L21.6571 23.3262L24.2368 27.7838H29.3361L31.9157 23.3262L29.3361 18.8075Z" fill="#8061A9"/>
	<path fill-rule="evenodd" clip-rule="evenodd" d="M29.3361 6.83905H24.2368L21.6571 11.3577L24.2368 15.8153H29.3361L31.9157 11.3577L29.3361 6.83905Z" fill="#F17323"/>
	<path fill-rule="evenodd" clip-rule="evenodd" d="M19.0774 1.13983H13.9781L11.3984 5.65852L13.9781 10.1161H19.0774L21.6571 5.65852L19.0774 1.13983Z" fill="#F8C517"/>
	<path fill-rule="evenodd" clip-rule="evenodd" d="M8.81889 6.83905H3.71959L1.13989 11.3577L3.71959 15.8153H8.81889L11.3985 11.3577L8.81889 6.83905Z" fill="#CADD72"/>
	<path fill-rule="evenodd" clip-rule="evenodd" d="M19.0774 12.5383H13.9781L11.3984 17.057L13.9781 21.5146H19.0774L21.6571 17.057L19.0774 12.5383Z" fill="#E82629"/>
	<path fill-rule="evenodd" clip-rule="evenodd" d="M8.81889 18.8075H3.71959L1.13989 23.3262L3.71959 27.7838H8.81889L11.3985 23.3262L8.81889 18.8075Z" fill="#98C93E"/>
	<path fill-rule="evenodd" clip-rule="evenodd" d="M19.0774 24.5067H13.9781L11.3984 29.0254L13.9781 33.483H19.0774L21.6571 29.0254L19.0774 24.5067Z" fill="#628AC6"/>
	<path fill-rule="evenodd" clip-rule="evenodd" d="M18.8181 20.7783H14.2377L11.9205 16.8397L14.2377 12.8471H18.8181L21.1352 16.8397L18.8181 20.7783ZM19.6441 11.3984H13.3933L10.2587 16.831L13.3933 22.227H19.6441L22.797 16.831L19.6441 11.3984Z" fill="#363736"/>
	<path fill-rule="evenodd" clip-rule="evenodd" d="M13.3932 23.3669L10.2587 28.7995L13.3932 34.1954H19.6441L22.797 28.7995L19.6441 23.3669H13.3932ZM11.9204 28.8082L14.2376 24.8156H18.818L21.1352 28.8082L18.818 32.7468H14.2376L11.9204 28.8082Z" fill="#363736"/>
	<path fill-rule="evenodd" clip-rule="evenodd" d="M13.3932 0L10.2587 5.43263L13.3932 10.8285H19.6441L22.797 5.43263L19.6441 0H13.3932ZM11.9204 5.4412L14.2376 1.4487H18.818L21.1352 5.4412L18.818 9.37985H14.2376L11.9204 5.4412Z" fill="#363736"/>
	<path fill-rule="evenodd" clip-rule="evenodd" d="M23.6518 17.6676L20.5172 23.1002L23.6518 28.4961H29.9026L33.0555 23.1002L29.9026 17.6676H23.6518ZM22.1791 23.1088L24.4962 19.1162H29.0766L31.3937 23.1088L29.0766 27.0475H24.4962L22.1791 23.1088Z" fill="#363736"/>
	<path fill-rule="evenodd" clip-rule="evenodd" d="M23.6518 5.69922L20.5172 11.1319L23.6518 16.5278H29.9026L33.0555 11.1319L29.9026 5.69922H23.6518ZM22.1791 11.1405L24.4962 7.14791H29.0766L31.3937 11.1405L29.0766 15.0791H24.4962L22.1791 11.1405Z" fill="#363736"/>
	<path fill-rule="evenodd" clip-rule="evenodd" d="M3.13453 17.6676L0 23.1002L3.13453 28.4961H9.38542L12.5383 23.1002L9.38542 17.6676H3.13453ZM1.66179 23.1088L3.97892 19.1162H8.55933L10.8765 23.1088L8.55933 27.0475H3.97892L1.66179 23.1088Z" fill="#363736"/>
	<path fill-rule="evenodd" clip-rule="evenodd" d="M3.13453 5.69922L0 11.1319L3.13453 16.5278H9.38542L12.5383 11.1319L9.38542 5.69922H3.13453ZM1.66179 11.1405L3.97892 7.14791H8.55933L10.8765 11.1405L8.55933 15.0791H3.97892L1.66179 11.1405Z" fill="#363736"/>
	<path fill-rule="evenodd" clip-rule="evenodd" d="M118.045 26.2212H115.684C115.68 26.1511 115.672 26.079 115.672 26.0067C115.671 25.4755 115.672 24.9443 115.672 24.4132C115.672 21.8196 115.67 19.2259 115.673 16.6323C115.674 16.0004 115.609 15.3797 115.412 14.7769C115.054 13.6769 114.285 13.0758 113.148 12.9423C111.902 12.796 110.786 13.1155 109.807 13.9085C109.246 14.3634 108.76 14.8884 108.336 15.4706C108.291 15.5323 108.275 15.6193 108.26 15.6972C108.248 15.7569 108.257 15.8209 108.257 15.8831C108.257 19.2217 108.257 22.5603 108.257 25.899V26.1745H105.813C105.81 26.0969 105.804 26.0178 105.804 25.9385C105.803 24.6416 105.803 23.3449 105.803 22.048C105.803 20.2131 105.804 18.3783 105.803 16.5434C105.802 15.9188 105.721 15.3049 105.516 14.7127C105.15 13.6524 104.389 13.076 103.289 12.9438C101.995 12.7884 100.847 13.1358 99.8485 13.9777C99.3548 14.394 98.9271 14.868 98.5513 15.3919C98.4667 15.5097 98.43 15.6273 98.4302 15.7733C98.4339 18.1876 98.4329 20.6019 98.4329 23.0162C98.4329 24.0027 98.4328 24.9891 98.4328 25.9755C98.4328 26.0506 98.4329 26.1257 98.4329 26.1966C98.268 26.2411 96.4209 26.2568 96.0083 26.2211C95.9635 26.0785 95.9475 11.5179 95.9919 11.2328C96.1392 11.1898 97.6299 11.1799 97.8791 11.224C98.0319 11.9048 98.1863 12.5934 98.3506 13.3255C98.4321 13.2375 98.483 13.1848 98.5315 13.1298C98.8733 12.7418 99.2113 12.353 99.6207 12.0286C100.297 11.4925 101.037 11.105 101.892 10.9465C102.891 10.7614 103.881 10.7693 104.858 11.0677C105.742 11.3374 106.428 11.8838 106.989 12.6016C107.236 12.9179 107.441 13.2607 107.618 13.6209C107.647 13.6811 107.68 13.74 107.726 13.8283C107.789 13.7471 107.835 13.6904 107.878 13.6318C108.362 12.9788 108.924 12.4047 109.578 11.9209C110.653 11.1269 111.865 10.7921 113.189 10.8305C113.765 10.8472 114.332 10.9405 114.878 11.109C115.94 11.4361 116.781 12.0487 117.319 13.0516C117.732 13.8198 117.961 14.6327 118.013 15.4976C118.035 15.8759 118.043 16.2556 118.044 16.6347C118.046 19.7389 118.045 22.843 118.045 25.947C118.045 26.035 118.045 26.1229 118.045 26.2212Z" fill="black"/>
	<path fill-rule="evenodd" clip-rule="evenodd" d="M88.991 11.2089H91.4298C91.4346 11.2734 91.4428 11.333 91.4428 11.3927C91.4432 14.4486 91.4462 17.5046 91.44 20.5604C91.4386 21.2439 91.3973 21.9304 91.205 22.5891C90.674 24.4077 89.5103 25.6313 87.7045 26.2308C87.1904 26.4015 86.6563 26.4686 86.121 26.5185C85.1811 26.6062 84.2427 26.5721 83.3238 26.3539C82.3006 26.111 81.3691 25.6685 80.6397 24.8872C79.9731 24.1733 79.5297 23.3348 79.3131 22.3749C79.177 21.7718 79.1183 21.1617 79.1166 20.5486C79.1082 17.4927 79.1122 14.4368 79.1121 11.3809C79.1121 11.3333 79.1162 11.2859 79.1182 11.2414C79.2665 11.1891 81.306 11.1752 81.5764 11.2274V11.4846C81.5764 14.4163 81.5769 17.348 81.5759 20.2798C81.5758 20.7979 81.5963 21.3132 81.7041 21.8228C82.0195 23.3138 83.047 24.2679 84.5593 24.4664C85.1659 24.5459 85.7728 24.5417 86.3695 24.4041C87.4572 24.153 88.1978 23.4798 88.6343 22.4662C88.9232 21.795 88.9875 21.0798 88.9892 20.359C88.9937 18.4413 88.9909 16.5236 88.991 14.6059C88.991 13.5643 88.991 12.5226 88.991 11.481V11.2089Z" fill="black"/>
	<path fill-rule="evenodd" clip-rule="evenodd" d="M52.8848 13.6787C52.2998 13.5043 51.7552 13.3306 51.204 13.1809C50.5636 13.0069 49.9104 12.9029 49.2439 12.9094C48.6119 12.9155 47.9932 13.0143 47.3964 13.2204C46.5853 13.5004 45.9217 13.989 45.4141 14.6828C44.7801 15.5493 44.4233 16.5192 44.3261 17.5886C44.2698 18.2081 44.2455 18.8272 44.29 19.4478C44.3651 20.4982 44.6577 21.477 45.2476 22.3596C45.9359 23.3894 46.9044 23.9945 48.1017 24.2496C48.8993 24.4196 49.7043 24.4049 50.5102 24.3127C51.3027 24.2219 52.0604 23.9954 52.8081 23.7288C52.8848 23.7014 52.9629 23.678 53.0557 23.6477V25.6883C52.8476 25.7841 52.6363 25.9016 52.4115 25.9814C51.2962 26.3771 50.1399 26.5561 48.9611 26.5532C47.7334 26.5502 46.5565 26.2984 45.4433 25.7559C43.8736 24.9911 42.822 23.7743 42.2258 22.1478C41.869 21.1744 41.7026 20.1666 41.672 19.1315C41.6362 17.921 41.7771 16.7359 42.1551 15.5844C42.8801 13.3763 44.3549 11.9049 46.5429 11.1349C47.0156 10.9685 47.5012 10.891 47.9971 10.8463C48.5747 10.7943 49.1516 10.7528 49.7315 10.8008C50.7623 10.8861 51.7645 11.0785 52.6962 11.5566C52.8388 11.6297 52.8927 11.7112 52.8892 11.8738C52.8776 12.4046 52.8848 12.9358 52.8848 13.4669V13.6787Z" fill="black"/>
	<path fill-rule="evenodd" clip-rule="evenodd" d="M64.4589 26.1727H66.8852V3.33331H64.4589V26.1727Z" fill="black"/>
	<path fill-rule="evenodd" clip-rule="evenodd" d="M59.3872 26.1754H56.9906C56.9796 26.1673 56.9731 26.1641 56.9688 26.159C56.9645 26.1541 56.9607 26.1475 56.9597 26.1412C56.9546 26.1073 56.9465 26.0734 56.9465 26.0395C56.9468 21.1224 56.9477 16.2052 56.9491 11.2881C56.9492 11.2686 56.9589 11.2493 56.9636 11.2314C57.1197 11.1901 59.1441 11.1809 59.3872 11.2221V26.1754Z" fill="black"/>
	<path fill-rule="evenodd" clip-rule="evenodd" d="M71.9558 11.2094H74.3597C74.4046 11.3583 74.4191 25.8966 74.3738 26.1728H71.9558V11.2094Z" fill="black"/>
	<path fill-rule="evenodd" clip-rule="evenodd" d="M59.3336 7.68597H56.9289C56.8864 7.53126 56.8771 5.21567 56.9188 4.97137H59.324C59.3637 5.12006 59.3739 7.41087 59.3336 7.68597Z" fill="black"/>
	<path fill-rule="evenodd" clip-rule="evenodd" d="M71.9128 4.96277H74.3104C74.3589 5.10865 74.3778 7.26993 74.3339 7.67746H71.9128V4.96277Z" fill="black"/>
	</svg>
	"""

_logoEncoded: base64.Encode(null, _logoString)

_related_images: [
	{
		name: "cilium"
		image: parameters.ciliumImage
	},
        {
		name: "hubble-relay"
		image: parameters.hubbleRelayImage
	},
	{
		name: "cilium-operator"
		image: parameters.operatorImage
	},
	{
		name: "preflight"
		image: parameters.preflightImage
	},
	{
		name: "clustermesh"
		image: parameters.clustermeshImage
	},
	{
		name: "certgen"
		image: parameters.certgenImage
	},
	{
		name: "hubble-ui-backend"
		image: parameters.hubbleUIBackendImage
	},
	{
		name: "hubble-ui-frontend"
		image: parameters.hubbleUIFrontendImage
	},
	{
		name: "etcd-operator"
		image: parameters.etcdOperatorImage
	},
	{
		name: "nodeinit"
		image: parameters.nodeInitImage
	},
	{
		name: "clustermesh-etcd"
		image: parameters.clustermeshEtcdImage
	}
]

if parameters.hubbleUIProxyImage != "nothing" {
	_related_images: _related_images + [{
		name: "hubble-ui-proxy"
		image: parameters.hubbleUIProxyImage
	}]
}

#CSVWorkloadTemplate: {
	apiVersion: "operators.coreos.com/v1alpha1"
	kind:       "ClusterServiceVersion"
	metadata: {
		annotations: _csv_annotations
		name:        "cilium.v\(parameters.ciliumVersion)-x\(parameters.configVersionSuffix)"
		namespace:   parameters.namespace
	}
	spec: {
            if parameters.replaces != "nothing" {
		replaces: parameters.replaces
             }
		relatedImages: _related_images
		apiservicedefinitions: {}
		customresourcedefinitions: owned: [{
			name:    "ciliumconfigs.cilium.io"
			kind:    "CiliumConfig"
			version: "v1alpha1"
			resources: [
				{
					kind:    "DaemonSet"
					name:    "cilium"
					version: "v1"
				},
				{
					kind:    "Deployment"
					name:    "cilium-operator"
					version: "v1"
				},
				{
					kind:    "ConfigMap"
					name:    "cilium-config"
					version: "v1"
				},
			]
			statusDescriptors: [
				{
					description: "Helm release conditions"
					displayName: "Conditions"
					path:        "conditions"
				},
				{
					description: "Name of deployed Helm release"
					displayName: "Deployed release"
					path:        "deployedRelease"
				},
			]
		}]
		displayName: "Cilium"
		description: "Cilium - eBPF-based Networking, Security, and Observability"
		icon: [{
			base64data: _logoEncoded
			mediatype:  "image/svg+xml"
		}]
		maintainers: [{
			name:  "Cilium"
			email: "maintainer@cilium.io"
		}]
		install: {
			spec: {
				deployments: [{
					name: constants.name
					spec: _workloadSpec
				}]
				permissions: [{
					rules:              _leaderElectionRules + _helmOperatorRules
					serviceAccountName: constants.name
				}]
				clusterPermissions: [{
					rules:              _helmOperatorClusterRules + _ciliumClusterRules
					serviceAccountName: constants.name
				}]
			}
			strategy: "deployment"
		}
		installModes: [{
			supported: true
			type:      "OwnNamespace"
		}, {
			supported: true
			type:      "SingleNamespace"
		}, {
			supported: false
			type:      "MultiNamespace"
		}, {
			supported: false
			type:      "AllNamespaces"
		}]
		keywords: [
			"networking",
			"security",
			"observability",
			"eBPF",
		]
		links: [{
			name: "Cilium Homepage"
			url:  "https://cilium.io/"
		}]
		maturity: "stable"
		provider: name: "Isovalent"
		version: "\(parameters.ciliumVersion)+x\(parameters.configVersionSuffix)"
	}

}
