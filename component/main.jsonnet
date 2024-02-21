// main template for olm
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();

// The hiera parameters for the component
local params = inv.parameters.olm;

local namespaceManager = kube.Namespace(params.namespace.manager.name) {
  metadata+: {
    annotations+: params.namespace.manager.annotations,
    labels+: params.namespace.manager.labels,
  },
};

local namespaceOperators = kube.Namespace(params.namespace.operators.name) {
  metadata+: {
    annotations+: params.namespace.operators.annotations,
    labels+: params.namespace.operators.labels,
  },
};

local catalogSources = [
  kube._Object('operators.coreos.com/v1alpha1', 'CatalogSource', name) {
    metadata+: {
      namespace: params.namespace.manager.name,
    },
    spec: params.sources[name],
  }
  for name in std.objectFields(params.sources)
];

// Define outputs below
{
  '00_namespace_manager': namespaceManager,
  '00_namespace_operators': namespaceOperators,
  '00_catalog_sources': catalogSources,
}
