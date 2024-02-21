local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.olm;
local argocd = import 'lib/argocd.libjsonnet';

local app = argocd.App('olm', params.namespace.manager.name);

{
  olm: app,
}
