return {
  settings = {
    yaml = {
      -- Enable Kubernetes schema validation
      -- NOTE: yamlls will apply ALL schemas that match a file pattern
      -- To avoid conflicts, use specific file naming patterns for CRDs
      schemas = {
        -- Flagger CRDs - use specific file name patterns
        ['https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/flagger.app/canary_v1beta1.json'] = '*canary*.{yaml,yml}',
        ['https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/flagger.app/metrictemplate_v1beta1.json'] = '*metrictemplate*.{yaml,yml}',
        ['https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/flagger.app/alertprovider_v1beta1.json'] = '*alertprovider*.{yaml,yml}',

        -- Flux CRDs from datreeio/CRDs-catalog
        ['https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/source.toolkit.fluxcd.io/gitrepository_v1.json'] = '*gitrepository*.{yaml,yml}',
        ['https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/kustomize.toolkit.fluxcd.io/kustomization_v1.json'] = {
          '*kustomization*.{yaml,yml}',
          '!kustomization.yaml', -- Exclude base kustomization.yaml files (those are for kustomize tool, not Flux CRD)
        },
        ['https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/helm.toolkit.fluxcd.io/helmrelease_v2.json'] = '*helmrelease*.{yaml,yml}',
        ['https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/source.toolkit.fluxcd.io/helmrepository_v1.json'] = '*helmrepo*.{yaml,yml}',
        ['https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/notification.toolkit.fluxcd.io/alert_v1beta3.json'] = '*alert*.{yaml,yml}',
        ['https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/notification.toolkit.fluxcd.io/provider_v1beta3.json'] = '*provider*.{yaml,yml}',

        -- Add more CRDs as needed from https://github.com/datreeio/CRDs-catalog/tree/main
      },
      -- Use schema store which includes many common formats and Kubernetes core resources
      schemaStore = {
        enable = true,
        -- Automatically pull schemas from SchemaStore
        url = 'https://www.schemastore.org/api/json/catalog.json',
      },
      customTags = {
        -- Support for custom YAML tags (useful for Helm, Ansible, etc.)
        '!vault',
        '!encrypted/pkcs1-oaep scalar',
        '!reference sequence',
      },
      format = {
        enable = true,
      },
      validate = true,
      completion = true,
      hover = true,
    },
  },
}
