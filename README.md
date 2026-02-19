0. STRUCTURE
- All requested resources are in main.tf
- Ideally resources would be placed in separate files designeted for each type (extrapolating to SaaS example):
  * infra-compute.tf: VMs+NIC+PIP
  * infra-data.tf: databases, storage accounts, blob containers
  * infra-monitoring.tf: log analytics workspaces
  * infra-network.tf: Vnets, Subnets
  * infra-security.tf: firewalls, NSGs, role assignments, key vaults


•	How this would be deployed via CI/CD
1. BACKEND
Backend for this pipeline would be deployed via HCP Terraform. 
Reasoning:
    - HCP terraform will be used only for bootstrapping and nothing else - deployed and not touched anymore
    - as only 3 recources needed (RG, Storage account, blob container) per each backend it is forever free (unless you go over 500 resource in your account)
    - backend state hosting with history of plan/apply and access control
    - can be used to delpy backend for multiple tenants/orgs
  
Additionally:
- apart from deploying backend for infra we use it for OIDC creation and injection of secrets into GitHub actions pipeline settings

2. REPO LAYOUT
   For this simple scenario of  RG + VNet + VM single repositoy in GitHub appears ot be sufficient

   However, for the SaaS scenario with multiple tenants the following route seems to be more feasible:
   - Repo #1: contains Hub network resources (firewall, settings, APIM) + HubVNet +Spoke Vnets
   - Repo #2: AKS+Storage+Database+KeyVault (and optional app gateway). Perhaps even better if these resoruces are converted into a module.

    How repos interact:
    - When new Spoke Vnet deployed via Repo #1 pipeline, it also provides outputs for (for example) spoke_vnet_id, spoke_subnet_id (AKS, appgateway, data), tenant_name, app gateway settings, AKS settings
    - Outputs captured by GitHub Actions workflow which: copies Repo #2, injects outputs from previous step/secrets, triggers new repo pipeline and delpyes new tenants infra using parameters received

! Isolated state for each tenant

3. Workflow
   - each repo would have main/dev branches
   - before commiting changes to dev branch tf fmt, validate and TFlint would be triggered on engineers local machine
   - when Pull Request created to merge changes into main GitHub Actions would trigger tf fmt, validate, TF Lint and tf plan
   - upon approval by head engineer workflow would initiate "terarform apply"

•	How changes are reviewed and tracked for SOC 2
- Change management: PRs are apprvoed after evaluating every plan dureing a weekly change manageent meeting. Approval logged in git history. Plans stored in a separate read-only location

