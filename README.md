## TerraTest

### Introduction

These days, for job recruitments, I believe that you have to get acquainted with some DevOps tools to make your living. In some companies 's needs, they use TerraTest to do testing a Terraform module before releasing this module for public uses by other teams/developers.

TerraTest is Go-based integration testing for infrastructure: it runs Terraform, inspects cloud resources, and asserts real-world behavior via go test.

This repository demonstrates a site-to-site VPN connection deployment between AWS and Azure using Terraform modules, and includes a Terratest-based Go test suite to validate the connection.

**Prerequisite Knowledge**

- Terraform
- Golang Programming

**Features**

- Perform "Integration Testing"
- Integrate with CI/CD
- Security & policy tools
- Test orchestration: disposable, separate.
- Observability: Record test logs, ship to central monitoring tools.
- Other alternatives: <Hmm, you can search it yourself ...>

### Project layout

- **infra**: [infra](infra) — Terraform configuration, modules, state, and credential helpers. Used for `terraform init/plan/apply`.
- **test**: [test](test) — Go Terratest tests (uses `go test`) that validate the deployed VPN connectivity and resources.

## TL;DR — Demo & Installation

Prerequisites

- **Terraform** (1.0+ recommended)
- **Go** (1.18+ recommended)
- **AWS CLI** and **Azure CLI** (or other method to provide cloud credentials)
- Credentials for both clouds available via environment variables, local CLI login, or files under `infra/credentials/`.

Quick start — deploy with Terraform

1. Change into the infra folder:

```bash
cd infra
```

2. Initialize Terraform and download providers/modules:

```bash
terraform init
```

3. (Optional) Validate configuration:

```bash
terraform validate
```

4. Create a plan and apply it:

```bash
terraform plan -var-file=terraform.tfvars
terraform apply
```

**Note:** If plan fails as terraform provider tries to register all azure providers. Then skip it

```bash
ARM_SKIP_PROVIDER_REGISTRATION=true terraform plan -var-file=terraform.tfvars
ARM_SKIP_PROVIDER_REGISTRATION=true terraform apply
```

5. When finished, destroy the environment:

```bash
terraform destroy -var-file=terraform.tfvars
```

**Notes**

- The `infra` directory contains `terraform.tfvars`, `providers.tf`, and module references. State files (`terraform.tfstate`) are created in `infra/` by default — follow your team/CI practices for remote state.
- Credentials are present in `infra/credentials/` in this workspace for local testing; do not commit real production sensitive keys to source control. Use environment variables or secure secret stores in CI. => Private key in this repo is for labs, has no impact to any production/personal data.

Running the Go/TerraTest suite

1. Change into the `test` folder:

```bash
cd test
```

2. Run the tests:

```bash
go test -v
```

3. To run a single test function (example):

```bash
go test -run TestSiteToSiteVPN -v
```

Environment and credentials for tests

- Ensure the test runner has access to AWS and Azure credentials. Typical options:
  - Export AWS credentials (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`) or use an `AWS_PROFILE` configured via the AWS CLI.
  - For Azure, provide `ARM_SUBSCRIPTION_ID`, `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, and `ARM_TENANT_ID`, or authenticate with `az login` prior to running tests.
  - Tests may also read credential files from `infra/credentials/` if configured accordingly.

CI notes

- In CI, run `terraform init` and `plan/apply` from the `infra` folder with secure environment variables or secrets mounted.
- Run the Go tests from the `test` folder after infrastructure is provisioned. Consider running tests against a disposable environment and tearing it down after validation.

Where to look

- Terraform configs: [infra](infra)
- Terratest code: [test](test)
- Terraform modules: [infra/modules](infra/modules)

If you'd like, I can also add a minimal `Makefile` or GitHub Actions workflow to automate `terraform` and `go test` runs — want me to add that?
