## Overview
A Codefresh plugin that runs the Datree CLI.  
Use this plugin to easily scan your k8s manifest files, Helm charts and Kustomizations for misconfigurations as part of your CI.

## Setup
Get started in 2 simple steps:  

* Obtain your Datree account token by following the instructions described [here](https://hub.datree.io/account-token).
* Configure your token by passing it directly to the 'DATREE_TOKEN' parameter, or by setting it as a [shared secret variable](https://codefresh.io/docs/docs/configure-ci-cd-pipeline/shared-configuration/) in your codefresh dashboard (see examples below).

## Usage

The following parameters determine the plugin's behavior:  
| Setting | Required | Description |
| --- | ----------- | --- |
| **DATREE_TOKEN** | Yes | your Datree CLI token. |
| **INPUT_PATH** | Yes | A path to the file/s you wish to run your Datree test against. This can be a single file or a [Glob pattern](https://www.digitalocean.com/community/tools/glob) signifying a directory. |
| **CLI_ARGUMENTS** | No | The desired [Datree CLI arguments](https://hub.datree.io/cli-arguments) for the policy check. |
| **IS_HELM_CHART** | No | Specify whether the given path is a Helm chart. If this option is unused, the path will be considered as a regular yaml file. |
| **HELM_ARGUMENTS** | No | The Helm arguments to be used, if the path is a Helm chart. |
| **IS_KUSTOMIZATION** | No | Specify whether the given path is a directory containing a "kustomization.yaml" file. If this option is unused, the path will be considered as a regular yaml file. |
| **KUSTOMIZE_ARGUMENTS** | No | The Kustomize arguments to be used, if the path is a Kustomization directory. |  

*For more information and examples of using this plugin with Helm/Kustomize, see below*

## Examples
Here is an example pipeline that runs a Datree policy check on a file in the repository. This example uses a shared secret variable for the CLI token called DATREE_TOKEN (can be configured via the codefresh dashboard):
```yaml
version: "1.0"
stages:
  - "clone"
  - "datree-policy-check"

steps:
  clone:
    title: "Cloning repository"
    type: "git-clone"
    repo: "myOrg/myRepo"
    revision: "${{CF_BRANCH}}"
    git: "github"
    stage: "clone"
    
  datree-policy-check:
    title: Run Datree policy check
    type: datree/datree-policy-check
    stage: "datree-policy-check"
    arguments:
      DATREE_TOKEN: "${{DATREE_TOKEN}}"
      INPUT_PATH: 'fileName.yaml'
```

### Using Helm
This plugin enables performing policy checks on Helm charts, by utilizing the [Datree Helm plugin](https://github.com/datreeio/helm-datree).
To test a Helm chart, simply set `IS_HELM_CHART` to 'true', and add any Helm arguments you wish to use to the `HELM_ARGUMENTS` parameter, like so:
```yaml
datree-policy-check:
    title: Run Datree policy check
    type: datree/datree-policy-check
    stage: "datree-policy-check"
    arguments:
      DATREE_TOKEN: "${{DATREE_TOKEN}}"
      INPUT_PATH: 'my/chart/directory'
      IS_HELM_CHART: true
      HELM_ARGUMENTS: "--values values.yaml"
```

### Using Kustomize
This plugin utilizes the Datree CLI's built-in Kustomize support. To use the plugin to test a kustomization, set `IS_KUSTOMIZATION` to 'true', and add any Kustomize arguments you wish to use to the `KUSTOMIZE_ARGUMENTS` parameter, like so:
```yaml
datree-policy-check:
    title: Run Datree policy check
    type: datree/datree-policy-check
    stage: "datree-policy-check"
    arguments:
      DATREE_TOKEN: "${{DATREE_TOKEN}}"
      INPUT_PATH: 'my/kustomization/directory'
      IS_KUSTOMIZATION: true
```
